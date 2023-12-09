--[[
    Custom renderers need to return a table with the members outlined here.
    Members of the Settings subtable will be modified from outside the renderer, but defaults can be set here.
    The renderer should respect any modifications to the Settings table.


    Necessary Members:
    Settings(table)

    Necessary Functions:
    Initialize() - Called when renderer is attached to a timer panel to instantiate anything that should only be created once.
    Destroy() - Called if renderer is discarded, to clean up any floating resources.
    Begin() - Called prior to drawing timers and drag handle.
    End() - Called after drawing timers and drag handle.
    DrawDragHandle(position) - Should draw a handle used to drag the panel around.
        position(table) - Base position of the panel.
    DrawTimers(position, renderDataContainer) - Should draw all timer objects.
        position(table) - Base position of the panel.
        renderDataContainer(table) - Objects to be drawn.
    DrawTooltip(position, renderData) - Should draw a tooltip for the specified timer object.
        position(table) - Current mouse position.
        renderData(table) - Data for the object specified.
    DragHitTest(position) - Should return true if the mouse coordinates fall within the drag handle, false if not.
        position(table) - Current mouse position.
    TimerHitTest(position) - Should return the associated renderData if mouse coordinates fall within a timer, nil if not.
        position(table) - Current mouse position.

    Table Layouts:

    Settings
        Countdown (boolean) - If true, the timer should progress from full to empty, if false it should progress from empty to full.
        Scale (number) - Size multiplier, where 1 is the default size.
        ShowTenths (boolean) - If true, show a decimal place for partial seconds on timers with less than 1 minute remaining.

    Position
        X(float)
        Y(float)

    renderDataContainer(table) - Array-style table containing any number of renderData values.
        renderData(table)

    renderData
        Complete (true or nil) - If true, timer has elapsed and a completion animation should be shown.
        Creation (number) - The time (os.clock()) the timer was created.
        Duration (number) - Time remaining until timer expires(seconds).
        Label (string) - Text label to be shown.
        Local (table) - Table tied to the timer object for storing things that may need garbage collection.
            Delete (true or nil) - Reserved value.  If set to true, the timer will be removed next frame.
        Percent (number) - Percent of display to be shown, in range 0-1.
        Tooltip (string) - Text to draw tooltip.
    

    
]]--

local d3d = require('d3d8');
local ffi = require('ffi');
local gdi = require('gdifonts.include');

local function D3D_COLOR(input)
    return d3d.D3DCOLOR_ARGB(input.A, input.R, input.G, input.B);
end
local keys = T{ 'R', 'G', 'B', 'A' };
local function D3D_COLOR_BLEND(startColor, endColor, percent)
    local input = {};
    for _,key in pairs(keys) do
        input[key] = math.min(255, math.ceil((startColor[key] * (1 - percent)) + (endColor[key] * percent)));
    end
    return d3d.D3DCOLOR_ARGB(input.A, input.R, input.G, input.B);
end
local function CreateHitBox(x, y, width, height)
    return { MinX=x, MaxX=(x+width), MinY=y, MaxY=(y+height) };
end
local function TimeToString(timer, showTenths)
    if (timer >= 3600) then
        local h = math.floor(timer / 3600);
        local m = math.floor(math.fmod(timer, 3600) / 60);
        return string.format('%i:%02i', h, m);
    elseif (timer >= 60) then
        local m = math.floor(timer / 60);
        local s = math.floor(math.fmod(timer, 60));
        return string.format('%i:%02i', m, s);
    elseif (showTenths) then
        return string.format('%i.%i', math.floor(timer), math.floor(math.fmod(timer, 1) * 10));
    else
        return string.format('%i', math.floor(timer));
    end
end

local renderer = {};
--[[
    Internal function.  Not required.
]]--
function renderer:New(layout)
    local o = {};
    setmetatable(o, self);
    self.__index = self;
    o.Settings = {
        CountDown = true,
        Scale = 1,
        ShowTenths = true,
    };
    o.Layout = layout;
    return o;
end

function renderer:Initialize()
    self.Sprite = ffi.new('ID3DXSprite*[1]');
    if (ffi.C.D3DXCreateSprite(d3d.get_device(), self.Sprite) == ffi.C.S_OK) then
        self.Sprite = d3d.gc_safe_release(ffi.cast('ID3DXSprite*', self.Sprite[0]));
    else
        self.Sprite = nil;
        Error('Failed to create sprite.');
    end
    
    self.Bar = gTextureCache:GetTexture(self.Layout.Bar.Texture);
    self.BarRect = ffi.new('RECT', { 0, 0, self.Bar.Width, self.Bar.Height });
    self.Outline = gTextureCache:GetTexture(self.Layout.Bar.OutlineTexture);
    self.OutlineRect = ffi.new('RECT', { 0, 0, self.Outline.Width, self.Outline.Height });
    self.Drag = gdi:create_rect(self.Layout.DragHandle, true);
    self.HitBoxes = T{};
end

function renderer:Destroy()
end

function renderer:Begin()
    if (self.Sprite) then
        self.Sprite:Begin();
    end
end

function renderer:End()
    if (self.Sprite) then
        self.Sprite:End();
    end
end

--[[
    Internal function.  Not required.
]]--
function renderer:GetColor(renderData)
    local colorSettings = self.Layout.Color;
    local duration = renderData.Duration;
    if (duration < colorSettings.LowThreshold) then
        if self.Settings.Countdown then
            return D3D_COLOR(colorSettings.Low);
        else
            return D3D_COLOR(colorSettings.High);
        end
    elseif (duration < colorSettings.MidThreshold) then
        if (colorSettings.Blend) then
            local percent = ((duration - colorSettings.LowThreshold) / colorSettings.LowThreshold);            
            if self.Settings.Countdown then
                return D3D_COLOR_BLEND(colorSettings.Low, colorSettings.Middle, percent);
            else
                return D3D_COLOR_BLEND(colorSettings.High, colorSettings.Middle, percent);
            end
        else
            return D3D_COLOR(colorSettings.Middle);
        end
    elseif (duration < colorSettings.HighThreshold) then
        if (colorSettings.Blend) then
            local percent = ((duration - colorSettings.MidThreshold) / colorSettings.MidThreshold);
            if self.Settings.Countdown then
                return D3D_COLOR_BLEND(colorSettings.Middle, colorSettings.High, percent);
            else
                return D3D_COLOR_BLEND(colorSettings.Middle, colorSettings.Low, percent);
            end
        else
            return D3D_COLOR(colorSettings.Middle);
        end
    else
        if self.Settings.Countdown then
            return D3D_COLOR(colorSettings.High);
        else
            return D3D_COLOR(colorSettings.Low);
        end
    end
end

function renderer:DrawDragHandle(position)
    if (self.Sprite ~= nil) then
        local layout = self.Layout.DragHandle;
        local width = layout.width * self.Settings.Scale;
        local height = layout.height * self.Settings.Scale;
        local posX = position.X + (layout.offset_x * self.Settings.Scale);
        local posY = position.Y + (layout.offset_y * self.Settings.Scale);
        self.Drag:set_width(width);
        self.Drag:set_height(height);
        self.Drag:set_position_x(posX);
        self.Drag:set_position_y(posY);
        self.Drag:render(self.Sprite);
        self.DragHitBox = CreateHitBox(posX, posY, width, height);
    end
end

local vec_position = ffi.new('D3DXVECTOR2', { 0, 0, });
local vec_scale = ffi.new('D3DXVECTOR2', { 1, 1 });
local d3dwhite = d3d.D3DCOLOR_ARGB(255, 255, 255, 255);
function renderer:DrawTimers(position, renderDataContainer)
    self.HitBoxes = T{};
    local sprite = self.Sprite;
    if (sprite == nil) then
        return;
    end
    local scale = self.Settings.Scale;
    local barLayout = self.Layout.Bar;
    position.X = position.X + (barLayout.BaseOffsetX * scale);
    position.Y = position.Y + (barLayout.BaseOffsetY * scale);
    local width = barLayout.Width * scale;
    local height = barLayout.Height * scale;
    local showTenths = self.Settings.ShowTenths;
    for _,renderData in ipairs(renderDataContainer) do
        vec_scale.x = (barLayout.Width / self.Outline.Width) * scale;
        vec_scale.y = (barLayout.Height / self.Outline.Height) * scale;
        vec_position.x = position.X;
        vec_position.y = position.Y;
        sprite:Draw(self.Outline.Texture, self.OutlineRect, vec_scale, nil, 0.0, vec_position, D3D_COLOR(self.Layout.Color.BG));

        local color = self:GetColor(renderData);
        if (renderData.Complete) then
            if (renderData.Local.Visible == nil) then
                renderData.Local.Visible = false;
                renderData.Local.NextFrame = os.clock() + 0.2;
            elseif (os.clock() > renderData.Local.NextFrame) then
                renderData.Local.Visible = not renderData.Local.Visible;
                renderData.Local.NextFrame = os.clock() + 0.2;
            end
            if (renderData.Local.Visible) then
                self.BarRect.right = self.Bar.Width;
                vec_scale.x = (barLayout.Width / self.Bar.Width) * scale;
                vec_scale.y = (barLayout.Height / self.Bar.Height) * scale;
                sprite:Draw(self.Bar.Texture, self.BarRect, vec_scale, nil, 0.0, vec_position, color);
            end
        else
            local percent = self.Settings.CountDown and renderData.Percent or (1 - renderData.Percent);
            if (percent > 0) then
                self.BarRect.right = percent * self.Bar.Width;
                vec_scale.x = (barLayout.Width / self.Bar.Width) * scale;
                vec_scale.y = (barLayout.Height / self.Bar.Height) * scale;
                sprite:Draw(self.Bar.Texture, self.BarRect, vec_scale, nil, 0.0, vec_position, color);
            end
        end

        local labelLayout = self.Layout.Label;
        if (type(renderData.Label) == 'string') and (renderData.Label ~= '') then
            if (renderData.Local.label == nil) then
                renderData.Local.label = gdi:create_object(labelLayout, true);
            end

            local label = renderData.Local.label;
            label:set_font_height(labelLayout.font_height * scale);
            label:set_text(renderData.Label);
            label:set_position_x(position.X + (barLayout.NameOffsetX * scale));
            label:set_position_y(position.Y + (barLayout.NameOffsetY * scale));
            label:render(sprite);
        end

        if (renderData.Duration > 0) then
            if (renderData.Local.duration == nil) then
                renderData.Local.duration = gdi:create_object(labelLayout, true);
                renderData.Local.duration:set_font_alignment(2);
            end

            local duration = renderData.Local.duration;
            duration:set_font_height(labelLayout.font_height * scale);
            duration:set_text(TimeToString(renderData.Duration, showTenths));
            duration:set_position_x(position.X + ((barLayout.Width - barLayout.TimerOffsetX) * scale))
            duration:set_position_y(position.Y + (barLayout.TimerOffsetY * scale));
            duration:render(sprite);
        end

        self.HitBoxes:append({ RenderData=renderData, HitBox=CreateHitBox(position.X, position.Y, width, height) });
        position.X = position.X + (barLayout.HorizontalSpacing * scale);
        position.Y = position.Y + (barLayout.VerticalSpacing * scale);
    end
end

function renderer:DrawTooltip(position, renderData)
    if (self.Sprite == nil) or (renderData.Tooltip == nil) or (renderData.Tooltip == '') then
        return;
    end

    local layout = self.Layout.ToolTip;
    if (renderData.Local.tooltip == nil) then
        renderData.Local.tooltip = gdi:create_object(layout, true);
    end


    local tooltip = renderData.Local.tooltip;
    tooltip:set_font_height(math.floor(layout.font_height * self.Settings.Scale));
    tooltip:set_text(renderData.Tooltip);
    tooltip:set_position_x(position.X + (layout.offset_x * self.Settings.Scale));
    tooltip:set_position_y(position.Y + (layout.offset_y * self.Settings.Scale));

    self.Sprite:Begin();
    tooltip:render(self.Sprite);
    self.Sprite:End();
end

function renderer:DragHitTest(position)
    local x = position.X;
    local y = position.Y;
    local hitBox = self.DragHitBox;
    if hitBox then
        if (x >= hitBox.MinX) and (x <= hitBox.MaxX) then
            if (y >= hitBox.MinY) and (y <= hitBox.MaxY) then
                return true;
            end
        end
    end
    return false;
end

function renderer:TimerHitTest(position)
    local x = position.X;
    local y = position.Y;
    for _,entry in ipairs(self.HitBoxes) do
        local hitBox = entry.HitBox;
        if (x >= hitBox.MinX) and (x <= hitBox.MaxX) then
            if (y >= hitBox.MinY) and (y <= hitBox.MaxY) then
                return entry.RenderData;
            end
        end
    end
end

local function CreateRenderer(settings)
    return renderer:New(settings);
end

return CreateRenderer;
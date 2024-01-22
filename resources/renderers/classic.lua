--[[
Copyright (c) 2024 Thorny

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
--]]

--[[
    Custom renderers need to return a table with the members outlined here.
    Members of the Settings subtable will be modified from outside the renderer, but defaults can be set here.
    The renderer should respect any modifications to the Settings table.


    Necessary Members:
    Settings(table)

    Necessary Functions:
    New(skin) - Called to instantiate renderer.
        skin(table) - Loaded skin.
    Destroy() - Called if renderer is discarded, to clean up any floating resources.
    Begin() - Called prior to drawing timers and drag handle.
    End() - Called after drawing timers and drag handle.
    DrawDragHandle(sprite, position) - Should draw a handle used to drag the panel around.
        sprite(ID3DXSprite) - A sprite to draw with.  Begin will have been called already.
        position(table) - Base position of the panel.
    DrawTimers(sprite, position, renderDataContainer) - Should draw all timer objects.
        sprite(ID3DXSprite) - A sprite to draw with.  Begin will have been called already.
        position(table) - Base position of the panel.
        renderDataContainer(table) - Objects to be drawn.
    DrawTooltip(sprite, position, renderData) - Should draw a tooltip for the specified timer object.
        sprite(ID3DXSprite) - A sprite to draw with.  Begin will have been called already.
        position(table) - Current mouse position.
        renderData(table) - Data for the object specified.
    DragHitTest(position) - Should return true if the mouse coordinates fall within the drag handle, false if not.
        position(table) - Current mouse position.
    TimerHitTest(position) - Should return the associated renderData if mouse coordinates fall within a timer, nil if not.
        position(table) - Current mouse position.

    Settings
        Countdown (boolean) - If true, the timer should progress from full to empty, if false it should progress from empty to full.
        ReverseColors (boolean) - If true, any themed colors based on duration should be reversed.
            -This is to configure for the idea that a buff/debuff being at a low timer is bad, while a recast being low is good.
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
        Icon (string) - Icon to draw.
        Tooltip (string) - Text to draw tooltip.

    
    Skins:
        Renderer does not need to be skinnable, but there is extra support for it in config if so.
        All skin files should be placed in 'ashita/config/addons/ttimers/resources/skins/renderername/' and end in .lua.
        Skin files should be solely composed of serializable lua[no functions or cdata].  If using skins, at least one skin should be provided.
        If renderer is skinnable, the following function must be implemented:

        LoadSkin(skin) - Called to update skin.
            skin(table) - Name of the skin being used to initialize.  Name will be filename without path or .lua.


        The following member must be provided:
            DefaultSkin(string) - the name of the skin to be loaded if user has not yet provided a skin.

        The following function is optional:
            DrawSkinEditor(isOpen, saveChanges, skin) - Called to draw an imgui window to edit skins.  
                saveChanges(table) - Table with only one value, set to false.
                    Setting to true will save the skin to disc.
                isOpen(table) - Table with only one value, set to true.
                    Setting to false will close editor.
                skin(table) - Modifiable table containing skin data.
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
local function UINT_COLOR_TO_ARRAY(color)
    local out = {};
    out.A = bit.band(bit.rshift(color, 24), 0xFF);
    out.R = bit.band(bit.rshift(color, 16), 0xFF);
    out.G = bit.band(bit.rshift(color, 8), 0xFF);
    out.B = bit.band(color, 0xFF);
    return out;
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
renderer.DefaultSkin = 'windower';

--[[
    Internal function.  Not required.
]]--
function renderer:New(skin, settings)
    local o = {};
    setmetatable(o, self);
    self.__index = self;
    o.HitBoxes = T{};
    o.Settings = {
        CountDown = settings.CountDown,
        ReverseColors = settings.ReverseColors,
        Scale = settings.Scale,
        ShowTenths = settings.ShowTenths,
    };
    o:LoadSkin(skin);
    return o;
end

function renderer:LoadSkin(skin)
    self.Skin = skin:copy(true);
    self.Skin.Color.BG = UINT_COLOR_TO_ARRAY(self.Skin.Color.BG);
    if (self.Settings.ReverseColors) then
        local high = self.Skin.Color.High;
        self.Skin.Color.High = UINT_COLOR_TO_ARRAY(self.Skin.Color.Low);
        self.Skin.Color.Middle = UINT_COLOR_TO_ARRAY(self.Skin.Color.Middle);
        self.Skin.Color.Low = UINT_COLOR_TO_ARRAY(high);
    else
        self.Skin.Color.Low = UINT_COLOR_TO_ARRAY(self.Skin.Color.Low);
        self.Skin.Color.Middle = UINT_COLOR_TO_ARRAY(self.Skin.Color.Middle);
        self.Skin.Color.High = UINT_COLOR_TO_ARRAY(self.Skin.Color.High);
    end
    self.Bar = gTextureCache:GetTexture(self.Skin.Bar.Texture);
    self.BarRect = ffi.new('RECT', { 0, 0, self.Bar.Width, self.Bar.Height });
    self.IconRect = ffi.new('RECT', { 0, 0, 0, 0 });
    self.Outline = gTextureCache:GetTexture(self.Skin.Bar.OutlineTexture);
    self.OutlineRect = ffi.new('RECT', { 0, 0, self.Outline.Width, self.Outline.Height });
    self.Drag = gdi:create_rect(self.Skin.DragHandle, true);
    self.SkinTime = os.clock();
end

function renderer:Destroy()
end

function renderer:Begin()
end

function renderer:End()
end

--[[
    Internal function.  Not required.
]]--
function renderer:GetColor(renderData)
    local colorSettings = self.Skin.Color;
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

function renderer:DrawDragHandle(sprite, position)
    local layout = self.Skin.DragHandle;
    local width = layout.width * self.Settings.Scale;
    local height = layout.height * self.Settings.Scale;
    local posX = position.X + (layout.offset_x * self.Settings.Scale);
    local posY = position.Y + (layout.offset_y * self.Settings.Scale);
    self.Drag:set_width(width);
    self.Drag:set_height(height);
    self.Drag:set_position_x(posX);
    self.Drag:set_position_y(posY);
    self.Drag:render(sprite);
    self.DragHitBox = CreateHitBox(posX, posY, width, height);
end

local vec_position = ffi.new('D3DXVECTOR2', { 0, 0, });
local vec_scale = ffi.new('D3DXVECTOR2', { 1, 1 });
local d3dwhite = d3d.D3DCOLOR_ARGB(255, 255, 255, 255);
function renderer:DrawTimers(sprite, position, renderDataContainer)
    self.HitBoxes = T{};
    local scale = self.Settings.Scale;
    local barLayout = self.Skin.Bar;
    position.X = position.X + (barLayout.BaseOffsetX * scale);
    position.Y = position.Y + (barLayout.BaseOffsetY * scale);
    local width = barLayout.Width * scale;
    local height = barLayout.Height * scale;
    local showTenths = self.Settings.ShowTenths;
    for _,renderData in ipairs(renderDataContainer) do
        if ((renderData.Local.SkinTime == nil) or (renderData.Local.SkinTime < self.SkinTime)) then
            renderData.Local.label = nil;
            renderData.Local.duration = nil;
            renderData.Local.tooltip = nil;
            renderData.Local.SkinTime = self.SkinTime;
        end
        vec_scale.x = (barLayout.Width / self.Outline.Width) * scale;
        vec_scale.y = (barLayout.Height / self.Outline.Height) * scale;
        vec_position.x = position.X;
        vec_position.y = position.Y;
        sprite:Draw(self.Outline.Texture, self.OutlineRect, vec_scale, nil, 0.0, vec_position, D3D_COLOR(self.Skin.Color.BG));

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

        if (renderData.Icon ~= nil) then
            local icon = self.Skin.Icon;
            local tx = gTextureCache:GetTexture(renderData.Icon);
            if tx then
                self.IconRect.right = tx.Width;
                self.IconRect.bottom = tx.Height;
                vec_scale.x = (icon.Width * scale) / tx.Width;
                vec_scale.y = (icon.Height * scale) / tx.Height;
                vec_position.x = position.X + (icon.OffsetX * scale);
                vec_position.y = position.Y + (icon.OffsetY * scale);
                sprite:Draw(tx.Texture, self.IconRect, vec_scale, nil, 0.0, vec_position, d3dwhite);
            end
        end

        local labelLayout = self.Skin.Label;
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

function renderer:DrawTooltip(sprite, position, renderData)
    if (renderData.Tooltip == nil) or (renderData.Tooltip == '') then
        return;
    end

    local layout = self.Skin.ToolTip;
    if (renderData.Local.tooltip == nil) then
        renderData.Local.tooltip = gdi:create_object(layout, true);
    end


    local tooltip = renderData.Local.tooltip;
    tooltip:set_font_height(math.floor(layout.font_height * self.Settings.Scale));
    tooltip:set_text(renderData.Tooltip);
    tooltip:set_position_x(position.X + (layout.offset_x * self.Settings.Scale));
    tooltip:set_position_y(position.Y + (layout.offset_y * self.Settings.Scale));
    tooltip:render(sprite);
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

return renderer;
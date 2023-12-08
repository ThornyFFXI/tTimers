local d3d = require('d3d8');
local ffi = require('ffi');
local gdi = require('gdifonts.include');

local outlineData = {    
    width = 202,
    height = 16,
    corner_rounding = 6,
    fill_color = 0xFF303030,
};
local shrink = 1;
local baseWidth = outlineData.width - (2 * shrink);
local barData = {
    width = baseWidth,
    height = outlineData.height - (2 * shrink),
    corner_rounding = outlineData.corner_rounding - (2 * shrink),
    fill_color = 0xFFFFFFFF,
    gradient_style = gdi.Gradient.TopToBottom,
    gradient_color =  0x80FFFFFF,
};
local labelData = {
    font_color = 0xFFFFFFFF,
    font_family = 'Arial',
    font_height = 11,
    outline_color = 0xFF000000,
    outline_width = 2,
    visible = true,
};
local tipData = {
    font_color = 0xFFFFFFFF,
    font_family = 'Arial',
    font_height = 10,
    visible = true,
    background = {
        visible = true,
        corner_rounding = 3,
        outline_width = 2,
        fill_color = 0xFF000000,
    }
};
local dragData = {
    width = 15,
    height = 15,
    corner_rounding = 2,
    fill_color = 0xFF0047B3,
    outline_color = 0xFF000000,
    outline_width = 1,
    gradient_style = gdi.Gradient.TopLeftToBottomRight,
    gradient_color =  0x8080B3FF,
    visible = true;
};

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
    These values are reserved and will be modified from outside of the renderer.
    They should be honored by the renderer.

    Scale (number) - Size multiplier, where 1 is the default size.
    ShowTenths (boolean) - If true, show a decimal place for partial seconds on timers with less than 1 minute remaining.
]]
renderer.Settings = {
    Scale = 1,
    ShowTenths = true,
};

--[[
    Called to create all assets necessary for the renderer to function.
]]--
function renderer:Initialize()
    self.Sprite = ffi.new('ID3DXSprite*[1]');
    if (ffi.C.D3DXCreateSprite(d3d.get_device(), self.Sprite) == ffi.C.S_OK) then
        self.Sprite = d3d.gc_safe_release(ffi.cast('ID3DXSprite*', self.Sprite[0]));
    else
        self.Sprite = nil;
        Error('Failed to create sprite.');
    end
    
    self.Bar = gdi:create_rect(barData, true);
    self.Drag = gdi:create_rect(dragData, true);
    self.Outline = gdi:create_rect(outlineData, true);
    self.HitBoxes = T{};
end

--[[
    Called when renderer is destroyed, to free assets.
]]--
function renderer:Destroy()
    self.Bar = nil;
    self.Drag = nil;
    self.Outline = nil;
end

--[[
    Called prior to drawing.
]]--
function renderer:Begin()
    if (self.Sprite) then
        self.Sprite:Begin();
    end
end


--[[
    Called once all draw calls are complete.
]]--
function renderer:End()
    if (self.Sprite) then
        self.Sprite:End();
    end
end


--[[
    Draw a handle to be used for moving the timer panel around.  Provided position will be base position.
    
    position(table)
        X - x position
        Y - y position
    This will be the base position of the element.
]]--

function renderer:DrawDragHandle(position)
    if (self.Sprite ~= nil) then
        local width = dragData.width * self.Settings.Scale;
        local height = dragData.height * self.Settings.Scale;
        self.Drag:set_width(width);
        self.Drag:set_height(height);
        self.Drag:set_position_x(position.X);
        self.Drag:set_position_y(position.Y);
        self.Drag:render(self.Sprite);

        self.DragHitBox = CreateHitBox(position.X, position.Y, width, height);
    end
end

--[[
    position(table)
        X - x position
        Y - y position
    For first timer, this will be the base position of the element.
    This call should alter both values to indicate the position of the next timer.
    
    
    renderDataContainer(table):
        renderData(each entry):
            Color (number, uint32 hex ARGB) - The color the element should be displayed as.
            Complete (true or nil) - If true, timer has elapsed and a completion animation should be shown.
            Creation (number) - The time (os.clock()) the timer was created.
            Duration (number) - Time remaining(seconds).
            Label (string) - Text label to be shown.
            Local (table) - Table tied to the timer object for storing things that may need garbage collection.
            Member 'Delete' of the Local table is reserved, and if set to true will delete the timer.
            Percent (number, ranged 0-1) - Percent of display to be shown.
            Tooltip (string) - Text to draw tooltip.

    This function should create a method of tracking hitboxes for each timer drawn, so that renderer:HitTest can reference it.
]]--
local vec_position = ffi.new('D3DXVECTOR2', { 0, 0, });
local d3dwhite = d3d.D3DCOLOR_ARGB(255, 255, 255, 255);
function renderer:DrawTimers(position, renderDataContainer)
    self.HitBoxes = T{};
    local sprite = self.Sprite;
    if (sprite == nil) then
        return;
    end
    local scale = self.Settings.Scale;
    local showTenths = self.Settings.ShowTenths;
    local vec_scale = ffi.new('D3DXVECTOR2', { scale, scale });
    for _,renderData in ipairs(renderDataContainer) do
        local outline = self.Outline;
        outline:set_position_x(position.X);
        outline:set_position_y(position.Y);
        local texture, rect = outline:get_texture();
        vec_position.x = position.X;
        vec_position.y = position.Y;
        sprite:Draw(texture, rect, vec_scale, nil, 0.0, vec_position, d3dwhite);

        local width = (outline.settings.width * scale);
        local height = (outline.settings.height * scale);

        local bar = self.Bar;
        if (renderData.Complete) then
            if (renderData.Local.Visible == nil) then
                renderData.Local.Visible = false;
                renderData.Local.NextFrame = os.clock() + 0.2;
            elseif (os.clock() > renderData.Local.NextFrame) then
                renderData.Local.Visible = not renderData.Local.Visible;
                renderData.Local.NextFrame = os.clock() + 0.2;
            end
            if (renderData.Local.Visible) then
                texture, rect = bar:get_texture();
                rect.right = baseWidth;
                vec_position.x = position.X + (shrink * scale);
                vec_position.y = position.Y + (shrink * scale);
                sprite:Draw(texture, rect, vec_scale, nil, 0.0, vec_position, renderData.Color);
            end
        else
            local barWidth = renderData.Percent * baseWidth;
            if (barWidth > 0) then
                texture, rect = bar:get_texture();
                rect.right = barWidth;
                vec_position.x = position.X + (shrink * scale);
                vec_position.y = position.Y + (shrink * scale);
                sprite:Draw(texture, rect, vec_scale, nil, 0.0, vec_position, renderData.Color);
            end
        end

        if (type(renderData.Label) == 'string') and (renderData.Label ~= '') then
            if (renderData.Local.label == nil) then
                renderData.Local.label = gdi:create_object(labelData, true);
            end

            local label = renderData.Local.label;
            label:set_font_height(labelData.font_height * scale);
            label:set_text(renderData.Label);
            label:set_position_x(position.X + (6 * scale));
            label:set_position_y(position.Y + (1.5 * scale));
            label:render(sprite);
        end

        if (renderData.Duration > 0) then
            if (renderData.Local.duration == nil) then
                renderData.Local.duration = gdi:create_object(labelData, true);
                renderData.Local.duration:set_font_alignment(2);
            end

            local duration = renderData.Local.duration;
            duration:set_font_height(labelData.font_height * scale);
            duration:set_text(TimeToString(renderData.Duration, showTenths));
            duration:set_position_x(position.X + (width - (6 * scale)))
            duration:set_position_y(position.Y + (1.5 * scale));
            duration:render(sprite);
        end

        self.HitBoxes:append({ RenderData=renderData, HitBox=CreateHitBox(position.X, position.Y, width, height) });
        position.Y = position.Y + height + (2 * scale);
    end
end

--[[
    position - Table containing X and Y members indicating position of mouse.
    
    renderData(table):
        Color (number, uint32 hex ARGB) - The color the element should be displayed as.
        Complete (true or nil) - If true, timer has elapsed and a completion animation should be shown.
            Creation (number) - The time (os.clock()) the timer was created.
        Duration (number) - Time remaining(seconds).
        Label (string) - Text label to be shown.
        Local (table) - Table tied to the timer object for storing things that may need garbage collection.
        Member 'Delete' of the Local table is reserved, and if set to true will delete the timer.
        Percent (number, ranged 0-1) - Percent of display to be shown.
        Tooltip (string) - Text to draw tooltip.

    Return: A function in the format func(x,y) that returns if mouse is currently over the drawn element.
    position should be modified to indicate position of next element in group.
]]--
function renderer:DrawTooltip(position, renderData)
    if (self.Sprite == nil) or (renderData.Tooltip == nil) or (renderData.Tooltip == '') then
        return;
    end

    if (renderData.Local.tooltip == nil) then
        renderData.Local.tooltip = gdi:create_object(tipData, true);
    end

    local tooltip = renderData.Local.tooltip;
    tooltip:set_font_height(math.floor(tipData.font_height * self.Settings.Scale));
    tooltip:set_text(renderData.Tooltip);
    tooltip:set_position_x(position.X);
    tooltip:set_position_y(position.Y + (15 * self.Settings.Scale));
    tooltip:render(self.Sprite);
end

function renderer:DragHitTest(x, y)
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

function renderer:TimerHitTest(x, y)
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
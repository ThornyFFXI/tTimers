local d3d = require('d3d8');
local ffi = require('ffi');
local gdi = require('gdifonts.include');

local rectData = {    
    width = 242,
    height = 16,
    corner_rounding = 6,
    fill_color = 0xFF303030,
};
local shrink = 1;
local baseWidth = rectData.width - (2 * shrink);
local rectData2 = {    
    width = baseWidth,
    height = rectData.height - (2 * shrink),
    corner_rounding = rectData.corner_rounding - (2 * shrink),
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

local function HitTest(params, x, y)
    if (x >= params.MinX) and (x <= params.MaxX) then
        if (y >= params.MinY) and (y <= params.MaxY) then
            return true;
        end
    end
    return false;
end
local function CreateHitTest(x, y, width, height)
    local params = {MinX=x, MaxX=(x+width), MinY=y, MaxY=(y+height)};
    return HitTest:bind1(params);
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
    Draw a handle to be used for moving the timer panel around.  Provided position will be base position.

    sprite (ffi d3d8sprite)
    
    position(table)
        X - x position
        Y - y position
    This will be the base position of the element.

    scale(number)
        Scale the handle should be drawn to.

    Return: A function in the format func(x,y) that returns if mouse is currently over the drawn element.
]]--
function renderer:DrawDragHandle(sprite, position, scale)

    return CreateHitTest(0, 0, -1, -1);
end

--[[
    sprite (ffi d3d8sprite)

    position(table)
        X - x position
        Y - y position
    For first timer, this will be the base position of the element.
    This call should alter both values to indicate the position of the next timer.
    
    
    renderData(table):
        Color (number, uint32 hex ARGB) - The color the element should be displayed as.
        Complete (true or nil) - If true, timer has elapsed and a completion animation should be shown.
        Creation (number) - Time of creation using os.clock().
        Duration (number) - Time remaining(seconds).
        Label (string) - Text label to be shown.
        Local (table) - Table tied to the timer object for storing things that may need garbage collection.
        Member 'Delete' of the Local table is reserved, and if set to true will delete the timer.
        Percent (number, ranged 0-1) - Percent of display to be shown.
        Scale - Draw scale.
        ShowTenths (number) - Whether tenths of seconds should be shown when duration is under 1 minute.
        Tooltip (string) - Text to draw tooltip.

    Return: A function in the format func(x,y) that returns if mouse is currently over the drawn element.
    position should be modified to indicate position of next element in group.
]]--
local vec_position = ffi.new('D3DXVECTOR2', { 0, 0, });
local d3dwhite = d3d.D3DCOLOR_ARGB(255, 255, 255, 255);
function renderer:DrawTimer(sprite, position, renderData)
    local vec_scale = ffi.new('D3DXVECTOR2', { renderData.Scale, renderData.Scale });
    if (renderData.Local.outline == nil) then
        renderData.Local.outline = gdi:create_rect(rectData, true);
        renderData.Local.bar = gdi:create_rect(rectData2, true);
    end

    local outline = renderData.Local.outline;
    outline:set_position_x(position.X);
    outline:set_position_y(position.Y);
    local texture, rect = outline:get_texture();
    vec_position.x = position.X;
    vec_position.y = position.Y;
    sprite:Draw(texture, rect, vec_scale, nil, 0.0, vec_position, d3dwhite);

    local width = (outline.settings.width * renderData.Scale);
    local height = (outline.settings.height * renderData.Scale);

    local bar = renderData.Local.bar;
    if (renderData.Complete) then
        if (renderData.Local.Visible == nil) then
            renderData.Local.Visible = false;
            renderData.Local.NextFrame = os.clock() + 0.2;
        elseif (os.clock() > renderData.Local.NextFrame) then
            renderData.Local.Visible = not renderData.Local.Visible;
            renderData.Local.NextFrame = os.clock() + 0.2;
        end
        if (renderData.Local.Visible) then
            bar:set_width(baseWidth);
            texture, rect = bar:get_texture();
            rect.right = baseWidth;
            vec_position.x = position.X + shrink;
            vec_position.y = position.Y + shrink;
            sprite:Draw(texture, rect, vec_scale, nil, 0.0, vec_position, renderData.Color);
        end
    else
        local width = renderData.Percent * baseWidth;
        if (width > 0) then
            if (width < (rectData2.corner_rounding * 3)) then
                bar:set_width(baseWidth);
            end

            texture, rect = bar:get_texture();
            rect.right = width;
            vec_position.x = position.X + shrink;
            vec_position.y = position.Y + shrink;
            sprite:Draw(texture, rect, vec_scale, nil, 0.0, vec_position, renderData.Color);
        end
    end

    if (type(renderData.Label) == 'string') and (renderData.Label ~= '') then
        if (renderData.Local.label == nil) then
            renderData.Local.label = gdi:create_object(labelData, true);
        end

        local label = renderData.Local.label;
        label:set_font_height(labelData.font_height * renderData.Scale);
        label:set_text(renderData.Label);
        label:set_position_x(position.X + (6 * renderData.Scale));
        label:set_position_y(position.Y + (1.5 * renderData.Scale));
        label:render(sprite);
    end

    if (renderData.Duration > 0) then
        if (renderData.Local.duration == nil) then
            renderData.Local.duration = gdi:create_object(labelData, true);
            renderData.Local.duration:set_font_alignment(2);
        end

        local duration = renderData.Local.duration;
        duration:set_font_height(labelData.font_height * renderData.Scale);
        duration:set_text(TimeToString(renderData.Duration, renderData.ShowTenths));
        duration:set_position_x(position.X + (width - (6 * renderData.Scale)))
        duration:set_position_y(position.Y + (1.5 * renderData.Scale));
        duration:render(sprite);
    end

    local hitTest = CreateHitTest(position.X, position.Y, width, height);
    position.Y = position.Y + height + (2 * renderData.Scale);
    return hitTest;
end

--[[
    Sprite (d3d8sprite) - for rendering, begin has already been called.
    position - Table containing X and Y members indicating position of mouse.
    
    renderData(table):
        Color (number, uint32 hex ARGB) - The color the element should be displayed as.
        Complete (true or nil) - If true, timer has elapsed and a completion animation should be shown.
        Creation (number) - Time of creation using os.clock().
        Duration (number) - Time remaining(seconds).
        Label (string) - Text label to be shown.
        Local (table) - Table tied to the timer object for storing things that may need garbage collection.
        Member 'Delete' of the Local table is reserved, and if set to true will delete the timer.
        Percent (number, ranged 0-1) - Percent of display to be shown.
        Scale - Draw scale.
        ShowTenths (number) - Whether tenths of seconds should be shown when duration is under 1 minute.
        Tooltip (string) - Text to draw tooltip.

    Return: A function in the format func(x,y) that returns if mouse is currently over the drawn element.
    position should be modified to indicate position of next element in group.
]]--
function renderer:DrawTooltip(sprite, position, renderData)
    if (renderData.Local.tooltip == nil) then
        renderData.Local.tooltip = gdi:create_object(tipData, true);
    end

    local tooltip = renderData.Local.tooltip;
    tooltip:set_font_height(math.floor(tipData.font_height * renderData.Scale));
    tooltip:set_text(renderData.Tooltip);
    tooltip:set_position_x(position.X);
    tooltip:set_position_y(position.Y + (15 * renderData.Scale));
    tooltip:render(sprite);
end

--[[
    Called to create all assets necessary for the renderer to function.
]]--
function renderer:Initialize()
end

--[[
    Called when renderer is destroyed, to free assets.
]]--
function renderer:Destroy()

end

return renderer;
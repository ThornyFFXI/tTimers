local gdi = require('gdifonts.include');
local settings = {
    Bar = {
        Texture = 'elements/bar_sharp.png',
        OutlineTexture = 'elements/outline_sharp.png',
        Width = 170,
        Height = 16,
        BaseOffsetX = 0,
        BaseOffsetY = -17,
        NameOffsetX = 6,
        NameOffsetY = 1.5,
        TimerOffsetX = 6,
        TimerOffsetY = 1.5,
        HorizontalSpacing = 0,
        VerticalSpacing = -17,
    };
    Color = {
        Blend = true,
        LowThreshold = 10,
        MidThreshold = 30,
        HighThreshold = 60,
        BG = { R=0, G=0, B=0, A=255 },
        Low = { R=255, G=0, B=0, A=255 },
        Middle = { R=255, G=255, B=0, A=255 },
        High = { R=0, G=255, B=0, A=255 },
    };
    Label = {
        font_color = 0xFFFFFFFF,
        font_family = 'Arial',
        font_height = 11,
        outline_color = 0xFF000000,
        outline_width = 2,
        visible = true,
    };
    ToolTip = {
        offset_x = 0,
        offset_y = 0,
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
    DragHandle = {
        offset_x = 0,
        offset_y = -15,
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
};

local baseFile = loadfile(string.format('%saddons/%s/resources/renderers/dependencies/base.lua', AshitaCore:GetInstallPath(), addon.name));
local baseFunction = baseFile();
local renderer = baseFunction(settings);
print(type(renderer));
return renderer;
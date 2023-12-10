local gdi = require('gdifonts.include');
local font = 'Arial';
if gdi:get_font_available('Friz Quadrata') then
    font = 'Friz Quadrata';
end

local settings = T{
    Bar = T{
        Texture = 'skins/classic/assets/bar_wow.png',
        OutlineTexture = 'skins/classic/assets/outline_wow.png',
        Width = 170,
        Height = 16,
        BaseOffsetX = 0,
        BaseOffsetY = -17,
        NameOffsetX = 6,
        NameOffsetY = 0.5,
        TimerOffsetX = 6,
        TimerOffsetY = 0.5,
        HorizontalSpacing = 0,
        VerticalSpacing = -17,
    };
    Color = T{
        Blend = false,
        LowThreshold = 10,
        MidThreshold = 30,
        HighThreshold = 60,
        BG = T{ R=0, G=0, B=0, A=255 },
        Low = T{ R=162, G=110, B=0, A=255 },
        Middle = T{ R=162, G=110, B=0, A=255 },
        High = T{ R=162, G=110, B=0, A=255 },
    };
    Label = T{
        font_color = 0xFFFFFFFF,
        font_family = font,
        font_height = 11,
        outline_color = 0xFF000000,
        outline_width = 2,
        visible = true,
    };
    ToolTip = T{
        offset_x = 0,
        offset_y = 12,
        font_color = 0xFFFFFFFF,
        font_family = font,
        font_height = 10,
        visible = true,
        background = T{
            visible = true,
            corner_rounding = 3,
            outline_width = 2,
            fill_color = 0xFF000000,
        }
    };
    DragHandle = T{
        offset_x = 0,
        offset_y = -15,
        width = 15,
        height = 15,
        corner_rounding = 2,
        fill_color = 0xFF0047B3,
        outline_color = 0xFF000000,
        outline_width = 1,
        gradient_style = 3,
        gradient_color =  0x8080B3FF,
        visible = true;
    };
};
return settings;
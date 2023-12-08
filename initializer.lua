--Initialize Globals..
gTextureCache    = require('texturecache');
settings         = require('settings');

--Initialize Settings..
gDefaultSettings = T{
    Buff = T{
        Enabled = true,
        Position = T{ X=80, Y=200 },
        Renderer = 'classic',
        Scale = 1.25,
        MaxTimers = 10,
        ShiftCancel = true,
        CountDown = true,
        ShowTenths = true,
        SortType = 'Nominal',
        AnimateCompletion = true,
        CompletionDuration = 3,
        UseTooltips = true;
        ColorThresholds = T{
            T{ Mode='Seconds', Limit=15, Color=0xFFFF0000 },
            T{ Mode='Seconds', Limit=30, Color=0xFF999900 },
            T{ Mode='Default', Color=0xFF00FF00 },
        },
    },
    
    Debuff = T{
        Enabled = true,
        Position = T{ X=80, Y=200 },
        Renderer = 'classic',
        Scale = 1.25,
        MaxTimers = 10,
        ShiftCancel = true,
        CountDown = true,
        ShowTenths = true,
        SortType = 'Nominal',
        AnimateCompletion = true,
        CompletionDuration = 3,
        UseTooltips = true;
        ColorThresholds = T{
            T{ Mode='Seconds', Limit=15, Color=0xFFFF0000 },
            T{ Mode='Seconds', Limit=30, Color=0xFF999900 },
            T{ Mode='Default', Color=0xFF00FF00 },
        },
    },
    
    Recast = T{
        Enabled = true,
        Position = T{ X=80, Y=200 },
        Renderer = 'classic',
        Scale = 1.25,
        MaxTimers = 10,
        ShiftCancel = true,
        CountDown = false,
        ShowTenths = true,
        SortType = 'Nominal',
        AnimateCompletion = true,
        CompletionDuration = 3,
        UseTooltips = true;
        ColorThresholds = T{
            T{ Mode='Seconds', Limit=15, Color=0xFF00FF00 },
            T{ Mode='Seconds', Limit=30, Color=0xFF999900 },
            T{ Mode='Default', Color=0xFFFF0000 },
        },
    },
    
    Custom = T{
        Enabled = true,
        Position = T{ X=335, Y=200 },
        Renderer = 'classic',
        Scale = 1.25,
        MaxTimers = 10,
        ShiftCancel = true,
        CountDown = false,
        ShowTenths = true,
        SortType = 'Nominal',
        AnimateCompletion = true,
        CompletionDuration = 3,
        UseTooltips = true;
        ColorThresholds = T{
            T{ Mode='Seconds', Limit=15, Color=0xFF00FF00 },
            T{ Mode='Seconds', Limit=30, Color=0xFF999900 },
            T{ Mode='Default', Color=0xFFFF0000 },
        },
    },
};
gSettings = settings.load(gDefaultSettings:copy(true));

--Initialize panels..
local group          = require('timergroup');
gPanels = T{
    ['Buff'] = group:New(gSettings.Buff),
    ['Debuff'] = group:New(gSettings.Debuff),
    ['Recast'] = group:New(gSettings.Recast),
    ['Custom'] = group:New(gSettings.Custom),
};

--Register callback so character change updates panels..
local function UpdateSettings(newSettings)
    gSettings = newSettings;
    for name,entry in ipairs(gPanels) do
        local panelSettings = gSettings[name];
        entry:UpdateSettings(panelSettings, true);
    end
end
settings.register('settings', 'settings_update', UpdateSettings);
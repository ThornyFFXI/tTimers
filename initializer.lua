--Initialize Globals..
gTextureCache    = require('texturecache');
settings         = require('settings');

--Initialize Settings..
local defaultSettings = T{
    Buffs = {
        Enabled = true,
        Position = { X=80, Y=200 },
        Renderer = 'default',
        Scale = 1,
        MaxBars = 6,
        ShiftCancel = true,
        CountDown = true,
        ShowTenths = true,
        SortType = 'Nominal',
        AnimateCompletion = true,
        CompletionDuration = 3,
        UseTooltips = true;
        ColorThresholds = {
            { Mode='Seconds', Limit=15, Color=0xFFFF0000 },
            { Mode='Seconds', Limit=30, Color=0xFF999900 },
            { Mode='Default', Color=0xFF00FF00 },
        },
    },
    
    Debuffs = {
        Enabled = true,
        Position = { X=80, Y=200 },
        Renderer = 'default',
        Scale = 1,
        MaxBars = 6,
        ShiftCancel = true,
        CountDown = true,
        ShowTenths = true,
        SortType = 'Nominal',
        AnimateCompletion = true,
        CompletionDuration = 3,
        UseTooltips = true;
        ColorThresholds = {
            { Mode='Seconds', Limit=15, Color=0xFFFF0000 },
            { Mode='Seconds', Limit=30, Color=0xFF999900 },
            { Mode='Default', Color=0xFF00FF00 },
        },
    },
    
    Recasts = {
        Enabled = true,
        Position = { X=80, Y=200 },
        Renderer = 'default',
        Scale = 1,
        MaxBars = 6,
        ShiftCancel = true,
        CountDown = false,
        ShowTenths = true,
        SortType = 'Nominal',
        AnimateCompletion = true,
        CompletionDuration = 3,
        UseTooltips = true;
        ColorThresholds = {
            { Mode='Seconds', Limit=15, Color=0xFF00FF00 },
            { Mode='Seconds', Limit=30, Color=0xFF999900 },
            { Mode='Default', Color=0xFFFF0000 },
        },
    },
    
    Custom = {
        AllowDrag = true,
        Enabled = true,
        Position = { X=80, Y=200 },
        Renderer = 'default',
        Scale = 1.2,
        MaxBars = 6,
        ShiftCancel = true,
        CountDown = true,
        ShowTenths = true,
        SortType = 'Nominal',
        AnimateCompletion = true,
        CompletionDuration = 3,
        UseTooltips = true;
        ColorThresholds = {
            { Mode='Seconds', Limit=15, Color=0xFFFF0000 },
            { Mode='Seconds', Limit=30, Color=0xFF999900 },
            { Mode='Default', Color=0xFF00FF00 },
            { Mode='Seconds', Limit=15, Color=0xFF00FF00 },
            { Mode='Seconds', Limit=30, Color=0xFF999900 },
            { Mode='Default', Color=0xFFFF0000 },
        },
    },
};
gSettings = defaultSettings;
--gSettings = settings.load(defaultSettings);


--Initialize panels..
local group          = require('timergroup');
gPanels = T{
    ['Buffs'] = group:New(gSettings.Buffs),
    ['Debuffs'] = group:New(gSettings.Debuffs),
    ['Recasts'] = group:New(gSettings.Recasts),
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
--settings.register('settings', 'settings_update', UpdateSettings);
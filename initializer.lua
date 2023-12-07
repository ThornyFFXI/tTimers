--Initialize Globals..
gTextureCache    = require('texturecache');
settings         = require('settings');

--Initialize Settings..
local defaultSettings = T{
    Buffs = {
        Position = { X=0, Y=0 },
        Scale = 1,
        Enabled = true,
        Renderer = 'default',
        ShiftCancel = true,
        CountDown = true,
        ShowTenths = true,
        SortType = 'Nominal',
        AnimateCompletion = true,
        CompletionDuration = 3,
        UseTooltips = true;
        DefaultColor = 0xFF00FF00,
        ColorThresholds = {
            { Mode='Seconds', Limit=15, Color=0xFFFF0000 },
            { Mode='Seconds', Limit=30, Color=0xFF999900 },
        },
    },
    
    Debuffs = {
        Position = { X=0, Y=0 },
        Scale = 1,
        Enabled = true,
        Renderer = 'default',
        ShiftCancel = true,
        CountDown = true,
        ShowTenths = true,
        SortType = 'Nominal',
        AnimateCompletion = true,
        CompletionDuration = 3,
        UseTooltips = true;
        DefaultColor = 0xFF00FF00,
        ColorThresholds = {
            { Mode='Seconds', Limit=15, Color=0xFFFF0000 },
            { Mode='Seconds', Limit=30, Color=0xFF999900 },
        },
    },
    
    Recasts = {
        Position = { X=0, Y=0 },
        Scale = 1,
        Enabled = true,
        Renderer = 'default',
        ShiftCancel = true,
        CountDown = false,
        ShowTenths = true,
        SortType = 'Nominal',
        AnimateCompletion = true,
        CompletionDuration = 3,
        UseTooltips = true;
        DefaultColor = 0xFFFF0000,
        ColorThresholds = {
            { Mode='Seconds', Limit=15, Color=0xFF00FF00 },
            { Mode='Seconds', Limit=30, Color=0xFF999900 },
        },
    },
    
    Custom = {
        Position = { X=80, Y=200 },
        Scale = 1,
        Enabled = true,
        Renderer = 'default',
        ShiftCancel = true,
        CountDown = false,
        ShowTenths = true,
        SortType = 'Nominal',
        AnimateCompletion = true,
        CompletionDuration = 3,
        UseTooltips = true;
        DefaultColor = 0xFFFF0000,
        ColorThresholds = {
            { Mode='Seconds', Limit=15, Color=0xFF00FF00 },
            { Mode='Seconds', Limit=30, Color=0xFF999900 },
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
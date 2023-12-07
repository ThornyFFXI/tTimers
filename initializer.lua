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
        SortType = 'Duration',
        DefaultColor = 0xFF00FF00,
        AnimateCompletion = true,
        CompletionDuration = 3,
        ColorThresholds = {
            { Duration=15, Color=0xFFFF0000 },
            { Duration=30, Color=0xFF00FFFF },
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
        SortType = 'Duration',
        DefaultColor = 0xFF00FF00,
        AnimateCompletion = true,
        CompletionDuration = 3,
        ColorThresholds = {
            { Mode='Seconds', Limit=15, Color=0xFFFF0000 },
            { Mode='Percent', Limit=30, Color=0xFF00FFFF },
        },
    },
    
    Recasts = {
        Position = { X=0, Y=0 },
        Scale = 1,
        Enabled = true,
        Renderer = 'default',
        ShiftCancel = true,
        CountDown = true,
        ShowTenths = true,
        SortType = 'Duration',
        DefaultColor = 0xFFFF0000,
        AnimateCompletion = true,
        CompletionDuration = 3,
        ColorThresholds = {
            { Mode='Seconds', Limit=15, Color=0xFF00FF00 },
            { Mode='Percent', Limit=30, Color=0xFF00FFFF },
        },
    },
    
    Custom = {
        Position = { X=0, Y=0 },
        Scale = 1,
        Enabled = true,
        Renderer = 'default',
        ShiftCancel = true,
        CountDown = true,
        ShowTenths = true,
        SortType = 'Duration',
        DefaultColor = 0xFFFF0000,
        AnimateCompletion = true,
        CompletionDuration = 3,
        UseTooltips = true,
        ColorThresholds = {
            { Mode='Seconds', Limit=15, Color=0xFF00FF00 },
            { Mode='Percent', Limit=30, Color=0xFF00FFFF },
        },
    },
};
gSettings = settings.load(defaultSettings);


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
settings.register('settings', 'settings_update', UpdateSettings);
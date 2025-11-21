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

--Initialize Globals..
chat = require('chat');
gTextureCache    = require('texturecache');
settings         = require('settings');

local baseX = 0;
local baseY = 250;

--Initialize Settings..
gDefaultSettings = T{
    Buff = T{
        Enabled = true,
        Position = T{ X=baseX, Y=baseY },
        Renderer = 'classic',
        Scale = 1,
        MaxTimers = 10,
        ShiftCancel = true,
        CtrlBlock = true,
        CountDown = true,
        ReverseColors = true,
        ShowTenths = true,
        SortType = 'Nominal',
        AnimateCompletion = true,
        CompletionDuration = 3,
        UseTooltips = true;
        SpellIconList = T{},
        AbilityIconList = T{},
        WeaponSkillIconList = T{},
        SplitByDuration = true,
        TrackMode = 'Self Cast Only',
        Blocked = T{
            --Add reasonable defaults..
        },
        Skin = T{
            ["classic"] = "windower_bottom_justified";
        },
    },
    
    Debuff = T{
        Enabled = true,
        Position = T{ X=baseX, Y=baseY },
        Renderer = 'classic',
        Scale = 1,
        MaxTimers = 10,
        ShiftCancel = true,
        CtrlBlock = true,
        CountDown = true,
        ReverseColors = true,
        ShowTenths = true,
        SortType = 'Nominal',
        AnimateCompletion = true,
        CompletionDuration = 3,
        UseTooltips = true;
        SplitByDuration = true,
        TrackMode = 'Self Cast Only',
        ShowMobIndex = true,
        Blocked = T{
            --Add reasonable defaults..
        },
        Skin = T{},
    },
    
    Recast = T{
        Enabled = true,
        Position = T{ X=baseX+216, Y=baseY },
        Renderer = 'classic',
        Scale = 1,
        MaxTimers = 10,
        ShiftCancel = true,
        CtrlBlock = true,
        CountDown = false,
        ReverseColors = false,
        ShowTenths = true,
        SortType = 'Nominal',
        AnimateCompletion = true,
        CompletionDuration = 3,
        UseTooltips = true;
        Blocked = T{
            --Defaults to empty..
        },
        Skin = T{
            ["classic"] = "windower_bottom_justified";
        },
    },
    
    Custom = T{
        Enabled = true,
        Position = T{ X=baseX+216, Y=baseY },
        Renderer = 'classic',
        Scale = 1,
        MaxTimers = 10,
        ShiftCancel = true,
        CtrlBlock = true,
        CountDown = false,
        ReverseColors = false,
        ShowTenths = true,
        SortType = 'Nominal',
        AnimateCompletion = true,
        CompletionDuration = 3,
        UseTooltips = true;
        Skin = T{},
        UpdateCustom = false,
    },
    HideWithPrimitives = true,
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
    for name,entry in pairs(gPanels) do
        local panelSettings = gSettings[name];
        entry:UpdateSettings(panelSettings, true);
    end
end
settings.register('settings', 'settings_update', UpdateSettings);
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

local d3d = require('d3d8');
local ffi = require('ffi');
local config        = require('config');
local customTracker = require('trackers.custom');
local dummyTracker  = require('trackers.dummy');
local trackers      = T{
    { Name='Buff',   Tracker=require('trackers.buff') },
    { Name='Debuff', Tracker=require('trackers.debuff') },
    { Name='Recast', Tracker=require('trackers.recast') },
    { Name='Custom',  Tracker=customTracker },
}

local sprite = ffi.new('ID3DXSprite*[1]');
if (ffi.C.D3DXCreateSprite(d3d.get_device(), sprite) == ffi.C.S_OK) then
    sprite = d3d.gc_safe_release(ffi.cast('ID3DXSprite*', sprite[0]));
else
    sprite = nil;
    Error('Failed to create sprite.');
end

ashita.events.register('d3d_present', 'd3d_present_cb', function ()
    config:Render();
    if (sprite == nil) then
        return;
    end

    sprite:Begin();
    for _,entry in ipairs(trackers) do
        local panel = gPanels[entry.Name];
        if (panel.ShowDebugTimers) then
            entry.Tracker:Tick();
            panel:Render(sprite, dummyTracker:Tick(entry.Name));
        else
            panel:Render(sprite, entry.Tracker:Tick());
        end
    end
    for i = #trackers,1,-1 do
        local panel = gPanels[trackers[i].Name];
        panel:RenderTooltip(sprite);
    end
    sprite:End();
end);

ashita.events.register('mouse', 'mouse_cb', function (e)
    for name,panel in pairs(gPanels) do
        panel:HandleMouse(e);
    end
end);

ashita.events.register('command', 'command_cb', function (e)
    local args = e.command:args();
    if (#args == 0 or string.lower(args[1]) ~= '/tt') then
        return;
    end
    e.blocked = true;

    if (#args == 1) then
        config:Show();
        return;
    end

    if (#args > 1) then
        if (args[2] == 'reposition') then
            for name,panel in pairs(gPanels) do
                panel.AllowDrag = true;
                panel.ShowDebugTimers = true;
            end
            return;
        end
        
        if (args[2] == 'lock') then
            for name,panel in pairs(gPanels) do
                panel.AllowDrag = false;
                panel.ShowDebugTimers = false;
            end
            return;
        end

        if (args[2] == 'custom') then
            if (#args >= 4) then
                local duration;
                if type(args[4]) == 'string' then
                    local multiplier = 1;
                    local trail = string.lower(string.sub(args[4], -1, -1));
                    if trail == 's' then
                        args[4] = args[4]:sub(1, -2);
                    elseif (trail == 'm') then
                        multiplier = 60;
                        args[4] = args[4]:sub(1, -2);
                    elseif (trail == 'h') then
                        multiplier = 3600;
                        args[4] = args[4]:sub(1, -2);
                    end
                    local time = tonumber(args[4]);
                    if type(time) == 'number' then
                        duration = time * multiplier;
                    end
                end
                if (type(duration) == 'number') then
                    local newCustomTimer = {
                        Creation = os.clock(),
                        Label = args[3],
                        Local = T{},
                        Expiration = os.clock() + duration,
                        TotalDuration = duration;
                    };
                    if (#args > 4) then
                        newCustomTimer.Tooltip = args[5];
                    end
                    customTracker:AddTimer(newCustomTimer);
                end
            end
            e.blocked = true;
            return;
        end

        print(chat.header('tTimers') .. chat.message('Command Descriptions:'));
        print(chat.header('tTimers') .. chat.color1(2, '/tt') .. chat.message(' - Opens configuration menu.'));
        print(chat.header('tTimers') .. chat.color1(2, '/tt reposition') .. chat.message(' - Starts reposition mode, which shows debug timers to fill all panels and provides draggable handles to move them.'));
        print(chat.header('tTimers') .. chat.color1(2, '/tt lock') .. chat.message(' - Ends repositioning mode and saves positions for the current character.'));
        print(chat.header('tTimers') .. chat.color1(2, '/tt custom [label] [duration]') .. chat.message(' - Adds a custom timer.  Duration can be specified in number of seconds or using s,m, or h suffixes with or without decimal places(30m, 1h, 10.5m, etc).'));
    end
end);
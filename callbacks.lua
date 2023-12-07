local config = require('config');
local d3d = require('d3d8');
local ffi = require('ffi');

local buffTracker = require('bufftracker');
local debuffTracker = require('debufftracker');
local recastTracker = require('recasttracker');
local customTimers = T{};

local sprite = ffi.new('ID3DXSprite*[1]');
if (ffi.C.D3DXCreateSprite(d3d.get_device(), sprite) == ffi.C.S_OK) then
    sprite = d3d.gc_safe_release(ffi.cast('ID3DXSprite*', sprite[0]));
else
    sprite = nil;
    Error('Failed to create sprite.');
end

ashita.events.register('d3d_present', 'd3d_present_cb', function ()
    sprite:Begin();
    gPanels.Buffs:Render(sprite, buffTracker:Tick());
    gPanels.Debuffs:Render(sprite, debuffTracker:Tick());
    gPanels.Recasts:Render(sprite, recastTracker:Tick());
    gPanels.Custom:Render(sprite, customTimers);
    customTimers = customTimers:filteri(function(a) return (a.Local.Delete ~= true) end);
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
        if (args[2] == 'custom') then
            if (#args >= 4) then
                local newCustomTimer = {
                    Creation = os.clock(),
                    Label = args[3],
                    Local = T{},
                    Expiration = os.clock() + tonumber(args[4])
                };
                if (#args > 4) then
                    newCustomTimer.Tooltip = args[5];
                end
                customTimers:append(newCustomTimer);
            end
            e.blocked = true;
            return;
        end
    end
end);
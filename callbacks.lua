local config        = require('config');
local customTracker = require('trackers.custom');
local dummyTracker  = require('trackers.dummy');
local trackers      = T{
    { Name='Buff',   Tracker=require('trackers.buff') },
    { Name='Debuff', Tracker=require('trackers.debuff') },
    { Name='Recast', Tracker=require('trackers.recast') },
    { Name='Custom',  Tracker=customTracker },
}

ashita.events.register('d3d_present', 'd3d_present_cb', function ()
    local forcePanel, configState = config:Render();
    for _,entry in ipairs(trackers) do
        local panel = gPanels[entry.Name];
        if (forcePanel == entry.Name) and (configState.AllowDrag[1]) then
            panel.AllowDrag = true;
        else
            panel.AllowDrag = false;
        end
        if (forcePanel == entry.Name) and (configState.ShowDebugTimers[1]) then
            panel:Render(dummyTracker:Tick(entry.Name));
        else
            panel:Render(entry.Tracker:Tick());
        end
    end
    for i = #trackers,1,-1 do
        local panel = gPanels[trackers[i].Name];
        if panel:RenderTooltip() then
            break;
        end
    end
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
                customTracker:AddTimer(newCustomTimer);
            end
            e.blocked = true;
            return;
        end
    end
end);
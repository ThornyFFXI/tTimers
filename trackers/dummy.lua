local tracker = {};
local times = T{ 0, 10, 20, 30, 60, 300, 600, 1200, 3600 };
local panelState = {};
function tracker:Tick(panelName)
    local state = panelState[panelName];
    local time = os.clock();
    local max = gPanels[panelName].Settings.MaxTimers;
    if (state == nil) or (os.clock() > state.Reset) or (max ~= state.Max) then
        local newState = {
            ActiveTimers = T{},
            Max = max,
            Reset = os.clock() + 30,
        };
        for i = 1,max+1 do
            local duration = times[i];
            if duration == nil then
                duration = times[#times];
            end

            local newCustomTimer = {
                Creation = os.clock(),
                Label = string.format('Dummy %s %u', panelName, i),
                Local = T{},
                Expiration = os.clock() + duration,
                Tooltip = string.format('You are now hovering over Dummy %s %u.', panelName, i);
                TotalDuration = duration,
            };
            newState.ActiveTimers:append(newCustomTimer);
        end
        state = newState;
        panelState[panelName] = state;
    end

    state.ActiveTimers = state.ActiveTimers:filteri(function(a) return (a.Delete ~= true) end);
    state.ActiveTimers:each(function(a) a.Duration = a.Expiration - time; end);
    return state.ActiveTimers;
end

return tracker;
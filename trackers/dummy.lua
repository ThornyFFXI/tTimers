local tracker = {};
tracker.State = {
    ActiveTimers = T{};
    Reset = 0,
};

local times = T{ 0, 10, 20, 30, 60, 300, 600, 1200, 3600 };
local lastPanel;
local MaxTimers;
function tracker:Tick(panelName)
    local max = gPanels[panelName].Settings.MaxTimers;
    if (os.clock() > self.State.Reset) or (panelName ~= lastPanel) or (max ~= MaxTimers) then
        lastPanel = panelName;
        MaxTimers = max;
        self.ActiveTimers = T{};
        for i = 1,MaxTimers+1 do
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
            };
            self.ActiveTimers:append(newCustomTimer);
        end
        self.State.Reset = os.clock() + 30;
    end

    self.ActiveTimers = self.ActiveTimers:filteri(function(a) return (a.Local.Delete ~= true) end);
    return self.ActiveTimers;
end

return tracker;
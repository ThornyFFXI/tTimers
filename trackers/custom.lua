local tracker = {};
tracker.State = {
    ActiveTimers = T{};
    Reset = 0,
};

function tracker:AddTimer(timer)
    self.State.ActiveTimers:append(timer);
end

function tracker:Tick()
    self.State.ActiveTimers = self.State.ActiveTimers:filteri(function(a) return (a.Local.Delete ~= true) end);
    return self.State.ActiveTimers;
end

return tracker;
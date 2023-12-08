local tracker = {};
tracker.State = {
    ActiveTimers = T{};
    Reset = 0,
};

function tracker:Tick()
    return self.State.ActiveTimers;
end

return tracker;
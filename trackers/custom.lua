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

local tracker = {};
tracker.State = {
    ActiveTimers = T{};
    Reset = 0,
};

function tracker:AddTimer(timer)
    if (not gSettings.Custom.UpdateCustom or not tracker:UpdateTimer(timer)) then
        self.State.ActiveTimers:append(timer);
    end
end

function tracker:UpdateTimer(timer)    
    local found = false
    for key, existingTimer in ipairs(self.State.ActiveTimers) do
        if (not found and existingTimer.Label == timer.Label) then
            existingTimer.Creation = timer.Creation
            existingTimer.Local = timer.Local
            existingTimer.Expiration = timer.Expiration
            existingTimer.TotalDuration = timer.TotalDuration
            found = true
        elseif (existingTimer.Label == timer.Label) then
            existingTimer.Local.Delete = true;
        end        
    end
    return found
end

function tracker:Tick()
    local time = os.clock();
    self.State.ActiveTimers = self.State.ActiveTimers:filteri(function(a) return (a.Local.Delete ~= true) end);
    self.State.ActiveTimers:each(function(a) a.Duration = a.Expiration - time; end);
    return self.State.ActiveTimers;
end

return tracker;
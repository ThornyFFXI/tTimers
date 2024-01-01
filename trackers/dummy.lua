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

    state.ActiveTimers = state.ActiveTimers:filteri(function(a) return (a.Local.Delete ~= true) end);
    state.ActiveTimers:each(function(a) a.Duration = a.Expiration - time; end);
    return state.ActiveTimers;
end

return tracker;
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
ffi.cdef [[
    int16_t GetKeyState(int32_t vkey);
]]
local function IsControlPressed()
    return (bit.band(ffi.C.GetKeyState(0x11), 0x8000) ~= 0);
end
local function IsShiftPressed()
    return (bit.band(ffi.C.GetKeyState(0x10), 0x8000) ~= 0);
end
local TimerGroup = {};

function TimerGroup:New(newSettings)
    local o = {};
    setmetatable(o, self);
    self.__index = self;
    o.AllowDrag = false;
    o.DragActive = false;
    o.DragPosition = { 0, 0 };
    o.Mouse = { X = -1, Y = -1 };
    o.Settings = {};
    o.ShowDebugTimers = false;
    o:UpdateSettings(newSettings, true);
    return o;
end

function TimerGroup:HandleMouse(e)
    self.Mouse.X = e.x;
    self.Mouse.Y = e.y;

    if self.DragActive then
        local pos = self.Settings.Position;
        pos.X = pos.X + (e.x - self.DragPosition[1]);
        pos.Y = pos.Y + (e.y - self.DragPosition[2]);
        self.DragPosition[1] = e.x;
        self.DragPosition[2] = e.y;
        if (e.message == 514) or (not self.AllowDrag) then
            self.DragActive = false;
            self.Settings.Original.Position = self.Settings.Position;
            settings.save();
        end
    elseif (self.AllowDrag) and (e.message == 513) and self.TimerRenderer:DragHitTest({X=e.x, Y=e.y}) then
        self.DragActive = true;
        self.DragPosition[1] = e.x;
        self.DragPosition[2] = e.y;
        self.MouseBlocked = true;
        e.blocked = true;
        return;
    end

    if (e.message == 513) then
        if (self.Settings.CtrlBlock) and (IsControlPressed()) then
            local renderData = self.TimerRenderer:TimerHitTest({X=self.Mouse.X, Y=self.Mouse.Y});
            if renderData then
                renderData.Local.Delete = true;
                renderData.Local.Block = true;
                e.blocked = true;
                self.MouseBlocked = true;
                return;
            end

        elseif (self.Settings.ShiftCancel) and (IsShiftPressed()) then
            local renderData = self.TimerRenderer:TimerHitTest({X=self.Mouse.X, Y=self.Mouse.Y});
            if renderData then
                renderData.Local.Delete = true;
                e.blocked = true;
                self.MouseBlocked = true;
                return;
            end
        end
    end

    if (e.message == 514) and (self.MouseBlocked) then
        e.blocked = true;
        self.MouseBlocked = nil;
    end
end

--[[
    Data must contain the following members:
    Creation [os.clock()]
    Duration (number) - Time until timer expires, in seconds.
    TotalDuration (number) - Total duration of timer.
    Label [string]
    Local [table] - Table for storing items at scope of timer.  Member 'Delete' is reserved, and if set to true, removes the timer.
    Expiration [os.clock()]

    Data can optionally contain:
    Tooltip [string]
    Icon [string]
]]--
function TimerGroup:Render(sprite, timers)
    for _, timerData in ipairs(timers) do
        if (timerData.Duration <= 0) then
            if ((timerData.Duration * -1) > self.Settings.CompletionDuration) then
                timerData.Local.Delete = true;
            end
        end
    end

    if (self.Settings.Enabled == false) then
        return;
    end

    local renderDataContainer = T {};
    for _, timerData in ipairs(timers) do
        if (timerData.Local.Delete ~= true) then
            local renderData = {};
            renderData.Creation = timerData.Creation;
            renderData.Duration = timerData.Duration;
            if (renderData.Duration <= 0) then
                if (self.Settings.AnimateCompletion) then
                    renderData.Complete = true;
                end
                renderData.Percent = 0;
            else
                renderData.Percent = renderData.Duration / timerData.TotalDuration;
            end
            
            if (renderData.Duration > 0) or (renderData.Complete) then
                renderData.Icon = timerData.Icon;
                renderData.Local = timerData.Local;
                renderData.Label = timerData.Label;
                renderData.Tooltip = timerData.Tooltip;
                renderDataContainer:append(renderData);
            end
        end
    end

    if (self.Settings.SortType == 'Creation') then
        table.sort(renderDataContainer, function(a, b) return (a.Creation < b.Creation) end);
    elseif (self.Settings.SortType == 'Alphabetical') then
        table.sort(renderDataContainer, function(a, b) return (a.Label < b.Label) end);
    elseif (self.Settings.SortType == 'Nominal') then
        table.sort(renderDataContainer, function(a, b) return (a.Duration < b.Duration) end);
    elseif (self.Settings.SortType == 'Percentage') then
        table.sort(renderDataContainer, function(a, b) return (a.Percent < b.Percent) end);
    end

    local count = #renderDataContainer;
    if (count > self.Settings.MaxTimers) then
        for i = (self.Settings.MaxTimers + 1), count do
            renderDataContainer[i] = nil;
        end
    end

    self.TimerRenderer:Begin();
    self.TimerRenderer:DrawTimers(sprite, { X = self.Settings.Position.X, Y = self.Settings.Position.Y }, renderDataContainer);
    self.TimerRenderer:End();
end

function TimerGroup:RenderTooltip(sprite)
    if (self.AllowDrag) then
        self.TimerRenderer:DrawDragHandle(sprite, { X = self.Settings.Position.X, Y = self.Settings.Position.Y });
    end
    if (self.Settings.UseTooltips) then
        local renderData = self.TimerRenderer:TimerHitTest({X=self.Mouse.X, Y=self.Mouse.Y});
        if renderData then
            self.TimerRenderer:DrawTooltip(sprite, { X = self.Mouse.X, Y = self.Mouse.Y }, renderData);
            return true;
        end
    end
end

function TimerGroup:UpdateSettings(newSettings, force)
    if (self.Settings.Renderer ~= newSettings.Renderer) or (force == true) or (self.TimerRenderer == nil) then
        if (self.TimerRenderer ~= nil) then
            self.TimerRenderer:Destroy();
            self.TimerRenderer = nil;
        end

        local potentialPaths = T {
            string.format('%sconfig/addons/%s/resources/renderers/%s.lua', AshitaCore:GetInstallPath(), addon.name, newSettings.Renderer),
            string.format('%saddons/%s/resources/renderers/%s.lua', AshitaCore:GetInstallPath(), addon.name, newSettings.Renderer)
        };

        local renderer;
        for _, path in ipairs(potentialPaths) do
            if (path ~= '') and (ashita.fs.exists(path)) then
                renderer = LoadFile_s(path);
                if (renderer ~= nil) then
                    break;
                end
            end
        end

        if (renderer == nil) then
            Error(string.format('Failed to load renderer: $H%s$R', newSettings.Renderer));
        else
            local skinName = newSettings.Skin[newSettings.Renderer];
            if (skinName == nil) then
                newSettings.Skin[newSettings.Renderer] = renderer.DefaultSkin;
                skinName = renderer.DefaultSkin;
                settings.save();
            end
            local skinPath = GetFilePath(string.format('skins/%s/%s.lua', newSettings.Renderer, skinName));
            local skin = LoadFile_s(skinPath);
            self.TimerRenderer = renderer:New(skin, newSettings);
        end
    elseif (self.TimerRenderer ~= nil) then
        self.TimerRenderer.Settings = {
            CountDown = newSettings.CountDown,
            ReverseColors = newSettings.ReverseColors,
            Scale = newSettings.Scale,
            ShowTenths = newSettings.ShowTenths,
        };
        if (type(self.TimerRenderer.LoadSkin) == 'function') and (newSettings.Skin[newSettings.Renderer] ~= self.Settings.Skin) then
            local skinName = newSettings.Skin[newSettings.Renderer];
            local skinPath = GetFilePath(string.format('skins/%s/%s.lua', newSettings.Renderer, skinName));
            local skin = LoadFile_s(skinPath);
            self.TimerRenderer:LoadSkin(skin);
        end
    end

    self.Settings = T(newSettings):copy(true);
    self.Settings.Original = newSettings;
end

function TimerGroup:UpdateSkin(skin)
    if (type(self.TimerRenderer.LoadSkin) == 'function') then
        self.TimerRenderer:LoadSkin(skin);
    end
end

return TimerGroup;

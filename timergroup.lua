local d3d = require('d3d8');
local ffi = require('ffi');
ffi.cdef [[
    int16_t GetKeyState(int32_t vkey);
]]
local function IsShiftPressed()
    return (bit.band(ffi.C.GetKeyState(0x10), 0x8000) ~= 0);
end

local function UINT32_TO_D3D_COLOR(uint)
    local alpha = bit.rshift(bit.band(uint, 0xFF000000), 24);
    local red   = bit.rshift(bit.band(uint, 0x00FF0000), 16);
    local green = bit.rshift(bit.band(uint, 0x0000FF00), 8);
    local blue  = bit.band(uint, 0x000000FF);
    return d3d.D3DCOLOR_ARGB(alpha, red, green, blue);
end

local TimerGroup = {};

function TimerGroup:New(settings)
    local o = {};
    setmetatable(o, self);
    self.__index = self;
    o.AllowDrag = false;
    o.DragActive = false;
    o.DragPosition = { 0, 0 };
    o.Mouse = { X = -1, Y = -1 };
    o.Settings = {};
    o.ShowDebugTimers = false;
    o:UpdateSettings(settings, true);
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
    elseif (self.AllowDrag) and (e.message == 513) and self.TimerRenderer:DragHitTest(e.x, e.y) then
        self.DragActive = true;
        self.DragPosition[1] = e.x;
        self.DragPosition[2] = e.y;
        self.MouseBlocked = true;
        e.blocked = true;
        return;
    end

    if (e.message == 513) then
        if (self.Settings.ShiftCancel) and (IsShiftPressed()) then
            local renderData = self.TimerRenderer:TimerHitTest(self.Mouse.X, self.Mouse.Y);
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
]]--
function TimerGroup:Render(timers)
    local time = os.clock();
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

            local comparePercent = renderData.Percent * 100;
            for _, setting in ipairs(self.Settings.ColorThresholds) do
                if (setting.Mode == 'Seconds') then
                    if (renderData.Duration < setting.Limit) then
                        renderData.Color = setting.Color;
                        break;
                    end
                elseif (setting.Mode == 'Percent') then
                    if (comparePercent < setting.Limit) then
                        renderData.Color = setting.Color;
                        break;
                    end
                else
                    renderData.Color = setting.Color;
                    break;
                end
            end

            if (renderData.Duration > 0) or (renderData.Complete) then
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

    if (not self.Settings.CountDown) then
        for _, renderData in ipairs(renderDataContainer) do
            renderData.Percent = (1 - renderData.Percent);
        end
    end

    self.TimerRenderer:Begin();
    self.TimerRenderer:DrawTimers({ X = self.Settings.Position.X, Y = self.Settings.Position.Y }, renderDataContainer);
    if (self.AllowDrag) then
        self.TimerRenderer:DrawDragHandle({ X = self.Settings.Position.X, Y = self.Settings.Position.Y });
    end
    self.TimerRenderer:End();
end
function TimerGroup:RenderTooltip();
    if (not self.AllowDrag) and (self.Settings.UseTooltips) then
        local renderData = self.TimerRenderer:TimerHitTest(self.Mouse.X, self.Mouse.Y);
        if renderData then
            self.TimerRenderer:Begin();
            self.TimerRenderer:DrawTooltip({ X = self.Mouse.X, Y = self.Mouse.Y }, renderData);
            self.TimerRenderer:End();
            return true;
        end
    end
end

function TimerGroup:UpdateSettings(settings, force)
    if (self.Settings.TimerRenderer ~= settings.TimerRenderer) or (force == true) or (self.TimerRenderer == nil) then
        if (self.TimerRenderer ~= nil) then
            self.TimerRenderer:Destroy();
            self.TimerRenderer = nil;
        end

        local potentialPaths = T {
            settings.Renderer,
            string.format('%sconfig/addons/%s/renderers/%s', AshitaCore:GetInstallPath(), addon.name, settings.Renderer),
            string.format('%sconfig/addons/%s/renderers/%s.lua', AshitaCore:GetInstallPath(), addon.name, settings.Renderer),
            string.format('%saddons/%s/renderers/%s', AshitaCore:GetInstallPath(), addon.name, settings.Renderer),
            string.format('%saddons/%s/renderers/%s.lua', AshitaCore:GetInstallPath(), addon.name, settings.Renderer)
        };

        for _, path in ipairs(potentialPaths) do
            if (path ~= '') and (ashita.fs.exists(path)) then
                self.TimerRenderer = LoadFile_s(path);
                if (self.TimerRenderer ~= nil) then
                    break;
                end
            end
        end

        if (self.TimerRenderer == nil) then
            Error(string.format('Failed to load renderer: $H%s$R', settings.Renderer));
        else
            self.TimerRenderer.Settings = {
                Scale = settings.Scale,
                ShowTenths = settings.ShowTenths,
            };
            self.TimerRenderer:Initialize();
        end
    elseif (self.TimerRenderer ~= nil) then
        self.TimerRenderer.Settings = {
            Scale = settings.Scale,
            ShowTenths = settings.ShowTenths,
        };
    end

    self.Settings = T(settings):copy(true);
    self.Settings.Original = settings;
    for _, colorThreshold in ipairs(self.Settings.ColorThresholds) do
        colorThreshold.Color = UINT32_TO_D3D_COLOR(colorThreshold.Color);
    end
end

return TimerGroup;

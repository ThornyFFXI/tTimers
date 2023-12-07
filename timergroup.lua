local d3d      = require('d3d8');
local ffi      = require('ffi');
local TimerGroup = {};

local function HitTest(x, y, hitboxes)
    for _,entry in ipairs(hitboxes) do
        if (entry.Hitbox(x, y)) then
            return entry;
        end
    end
end
local function IsShiftPressed()
    return (bit.band(ffi.C.GetKeyState(0x10), 0x8000) ~= 0);
end

function TimerGroup:New(settings)
    local o = {};
    setmetatable(o, self);
    self.__index = self;
    o.Mouse = { X=-1, Y=-1 };
    o.Settings = {};
    o:UpdateSettings(settings, true);
    return o;
end

function TimerGroup:HandleMouse(e)
    self.Mouse.X = e.x;
    self.Mouse.Y = e.y;

    if (e.message == 513) then
        if (self.ShiftCancel) and (IsShiftPressed()) then
            local entry = HitTest(self.Mouse.X, self.Mouse.Y, self.Hitboxes);
            if entry then
                entry.Local.Delete = true;
            end
        end
    end
end

--[[
    Data must contain the following members:
    Creation [os.clock()]
    Label [string]
    Local [table] - Table for storing items at scope of timer.  Member 'Delete' is reserved, and if set to true, removes the timer.
    Expiration [os.clock()]

    Data can optionally contain:
    Tooltip [string]
]]--
function TimerGroup:Render(sprite, data)
    local time = os.clock();
    for _,entry in ipairs(data) do
        entry.Duration = entry.Expiration - time;
        if (entry.Duration <= 0) then
            if ((entry.Duration * -1) > self.Settings.CompletionDuration) then
                entry.Local.Delete = true;
            end
        end
    end

    if (self.Settings.Enabled == false) then
        return;
    end

    local sortable = T{};
    for _,entry in ipairs(data) do
        if (entry.Local.Delete ~= true) then
            local renderData = {};
            renderData.Creation = entry.Creation;
            renderData.Duration = entry.Expiration - time;
            if (renderData.Duration <= 0) then
                if (self.Settings.AnimateCompletion) then
                    renderData.Complete = true;
                end
                renderData.Percent = 0;
            else
                renderData.Percent = renderData.Duration / (entry.Expiration - entry.Creation);
                if (self.Settings.CountUp) then
                    renderData.Percent = (1 - renderData.Percent);
                end
            end

            local comparePercent = renderData.Percent * 100;
            renderData.Color = self.Settings.DefaultColor;
            for _,setting in ipairs(self.Settings.ColorThresholds) do
                if (setting.Mode == 'Seconds') then
                    if (renderData.Duration < setting.Limit) then
                        renderData.Color = setting.Color;
                        break;
                    end
                elseif (comparePercent < setting.Limit) then
                    renderData.Color = setting.Color;
                    break;
                end
            end

            if (renderData.Duration > 0) or (renderData.Complete) then
                renderData.Local = entry.Local;
                renderData.Label = entry.Label;
                renderData.Scale = self.Settings.Scale;
                renderData.ShowTenths = self.Settings.ShowTenths;
                renderData.Tooltip = entry.Tooltip;
                sortable:append(renderData);
            end
        end
    end

    if (self.Settings.SortType == 'Creation') then
        table.sort(sortable, function(a,b) return (a.Creation < b.Creation) end);
    elseif (self.Settings.SortType == 'Alphabetical') then
        table.sort(sortable, function(a,b) return (a.Label < b.Label) end);
    else
        table.sort(sortable, function(a,b) return (a.Duration < b.Duration) end);
    end

    local position = { X=self.Settings.Position.X, Y=self.Settings.Position.Y };
    self.Hitboxes = T{};
    for index,entry in ipairs(sortable) do
        local hitbox = self.TimerRenderer:DrawTimer(sprite, position, entry);
        self.Hitboxes:append({ Hitbox=hitbox, Local=entry.Local, Tooltip=entry.Tooltip });
        if (index == self.Settings.MaxBars) then
            break;
        end
    end

    if (self.Settings.UseTooltips) then
        self:RenderMouseOver(sprite);
    end
    
    if (self.AllowDrag) then
        self.TimerRenderer:DrawDragHandle({X=self.Settings.Position.X, Y=self.Settings.Position.Y });
    end
end

function TimerGroup:RenderMouseOver(sprite)
    local hit = HitTest(self.Mouse.X, self.Mouse.Y, self.Hitboxes);
    if hit and (hit.Tooltip) then
        self.TimerRenderer:DrawTooltip(sprite, { X=self.Mouse.X, Y=self.Mouse.Y }, hit.Tooltip);
    end
end

local function UINT32_TO_D3D_COLOR(uint)
    local alpha = bit.rshift(bit.band(uint, 0xFF000000), 24);
    local red   = bit.rshift(bit.band(uint, 0x00FF0000), 16);
    local green = bit.rshift(bit.band(uint, 0x0000FF00), 8);
    local blue  = bit.band(uint, 0x000000FF);

    return d3d.D3DCOLOR_ARGB(alpha, red, green, blue);
end
function TimerGroup:UpdateSettings(settings, force)
    if (self.Settings.TimerRenderer ~= settings.TimerRenderer) or (force == true) or (self.TimerRenderer == nil) then
        if (self.TimerRenderer ~= nil) then
            self.TimerRenderer:Destroy();
            self.TimerRenderer = nil;
        end
        
        local potentialPaths = T{
            settings.Renderer,
            string.format('%sconfig/addons/%s/renderers/%s', AshitaCore:GetInstallPath(), addon.name, settings.Renderer),
            string.format('%sconfig/addons/%s/renderers/%s.lua', AshitaCore:GetInstallPath(), addon.name, settings.Renderer),
            string.format('%saddons/%s/renderers/%s', AshitaCore:GetInstallPath(), addon.name, settings.Renderer),
            string.format('%saddons/%s/renderers/%s.lua', AshitaCore:GetInstallPath(), addon.name, settings.Renderer)
        };

        for _,path in ipairs(potentialPaths) do
            if (path ~= '') and (ashita.fs.exists(path)) then
                self.TimerRenderer = LoadFile_s(path);
                if (self.TimerRenderer ~= nil) then
                    break;
                end
            end
        end
        
        if (self.TimerRenderer == nil) then
            Error(string.format('Failed to load renderer: $H%s$R', settings.Renderer));
        end
    end
    
    self.Settings = T(settings):copy(true);
    self.Settings.DefaultColor = UINT32_TO_D3D_COLOR(self.Settings.DefaultColor);
    for _,entry in ipairs(self.Settings.ColorThresholds) do
        entry.Color = UINT32_TO_D3D_COLOR(entry.Color);
    end
end

return TimerGroup;
local header = { 1.0, 0.75, 0.55, 1.0 };
local imgui = require('imgui');
local panels = T { 'Buff', 'Debuff', 'Recast', 'Custom' };
local sortTypes = T { 'Nominal', 'Percentage', 'Alphabetical', 'Creation' };

local config = {
    State = {
        IsOpen = { false },
        SelectedPanel = 1,
        ForceShowPanel = false,
    },
};

function config:GetRenderers(settings)
    local renderers = T{};
    local paths = T{
        string.format('%sconfig/addons/%s/resources/renderers/', AshitaCore:GetInstallPath(), addon.name),
        string.format('%saddons/%s/resources/renderers/', AshitaCore:GetInstallPath(), addon.name),
    };

    for _,path in ipairs(paths) do
        if not (ashita.fs.exists(path)) then
            ashita.fs.create_directory(path);
        end
        local contents = ashita.fs.get_directory(path, '.*\\.lua');
        for _,file in pairs(contents) do
            file = string.sub(file, 1, -5);
            if not renderers:contains(file) then
                renderers:append(file);
            end
        end
    end
    
    self.State.Renderers = renderers;
    self.State.SelectedRenderer = 1;
    for index,renderer in ipairs(renderers) do
        if (settings.Renderer == renderer) then
            self.State.SelectedRenderer = index;
        end
    end

    self.State.SelectedSort = 1;
    for index,sortType in ipairs(sortTypes) do
        if (settings.SortType == sortType) then
            self.State.SelectedSort = index;
        end
    end
end


function config:Render()
    local state = self.State;

    if (state.IsOpen[1]) then
        if (imgui.Begin(string.format('%s v%s Configuration', addon.name, addon.version), state.IsOpen, ImGuiWindowFlags_AlwaysAutoResize)) then
            imgui.BeginGroup();
            if imgui.BeginTabBar('##tTimersConfigTabBar', ImGuiTabBarFlags_NoCloseWithMiddleMouseButton) then
                if imgui.BeginTabItem('Panels##tTimersConfigLayoutsTab') then
                    imgui.TextColored(header, 'Panel Type');
                    imgui.ShowHelp('Allows you to select which panel\'s settings you wish to change.');
                    if (imgui.BeginCombo('##tTimersPanelSelection', panels[state.SelectedPanel], ImGuiComboFlags_None)) then
                        for index,panelName in ipairs(panels) do
                            if (imgui.Selectable(panelName, index == state.SelectedPanel)) then
                                state.SelectedPanel = index;
                                self:GetRenderers(gPanels[panelName].Settings);
                            end
                        end
                        imgui.EndCombo();
                    end

                    local panelName = panels[state.SelectedPanel];
                    local panelSettings = gSettings[panelName];
                    local panel = gPanels[panelName];
                    
                    imgui.TextColored(header, 'Panel Renderer');
                    imgui.ShowHelp('Allows you to choose which renderer will draw the timer elements.');
                    if (imgui.BeginCombo('##tTimersRendererSelection', self.State.Renderers[self.State.SelectedRenderer], ImGuiComboFlags_None)) then
                        for index,renderer in ipairs(self.State.Renderers) do
                            if (imgui.Selectable(renderer, index == state.SelectedRenderer)) then
                                state.SelectedRenderer = index;
                                panelSettings.Renderer = renderer;
                                panel:UpdateSettings(panelSettings, true);
                                settings.save();
                            end
                        end
                        imgui.EndCombo();
                    end
                    imgui.TextColored(header, 'Draw Scale');
                    imgui.ShowHelp('Allows you to resize the timer panel.');
                    local buffer = { panelSettings.Scale };
                    if (imgui.SliderFloat('##tTimersDrawScale', buffer, 0.5, 3, '%.2f', ImGuiSliderFlags_AlwaysClamp)) then
                        panelSettings.Scale = buffer[1];
                        panel:UpdateSettings(panelSettings);
                        settings.save();
                    end
                    
                    imgui.TextColored(header, 'Max Timers');
                    imgui.ShowHelp('Determines the max number of timers to be shown at a time.');
                    buffer = { panelSettings.MaxTimers };
                    if (imgui.SliderInt('##tTimersMaxTimers', buffer, 1, 20, '%u', ImGuiSliderFlags_AlwaysClamp)) then
                        panelSettings.MaxTimers = buffer[1];
                        panel:UpdateSettings(panelSettings);
                        settings.save();
                    end
                    
                    imgui.TextColored(header, 'Completion Animation');
                    imgui.ShowHelp('When enabled, timers will animate upon completion, for the specified duration in seconds, before disappearing.');
                    buffer = { panelSettings.AnimateCompletion };
                    if (imgui.Checkbox(string.format('%s##tTimersConfig_%s', 'Animate Completion', 'AnimateCompletion'), buffer)) then
                        panelSettings.AnimateCompletion = buffer[1];
                        panel:UpdateSettings(panelSettings);
                        settings.save();
                    end
                    buffer = { panelSettings.CompletionDuration };
                    if (imgui.SliderFloat('##tTimersCompletionDuration', buffer, 0.5, 6, '%.2f', ImGuiSliderFlags_AlwaysClamp)) then
                        panelSettings.CompletionDuration = buffer[1];
                        panel:UpdateSettings(panelSettings);
                        settings.save();
                    end
                    
                    imgui.TextColored(header, 'Sort Type');
                    imgui.ShowHelp('Determines the order timers will be displayed in.');
                    if (imgui.BeginCombo('##tTimersSortSelection', sortTypes[self.State.SelectedSort], ImGuiComboFlags_None)) then
                        for index,sortType in ipairs(sortTypes) do
                            if (imgui.Selectable(sortType, index == state.SelectedSort)) then
                                state.SelectedSort = index;
                                panelSettings.SortType = sortType;
                                panel:UpdateSettings(panelSettings);
                                settings.save();
                            end
                        end
                        imgui.EndCombo();
                    end

                    imgui.TextColored(header, 'General');
                    if (imgui.Checkbox(string.format('%s##tTimersConfig_%s', 'Enabled', 'Enabled'), { panelSettings.Enabled })) then
                        panelSettings.Enabled = not panelSettings.Enabled;
                        panel:UpdateSettings(panelSettings);
                        settings.save();
                    end
                    imgui.ShowHelp('If not enabled, this panel won\'t show at all.');
                    
                    buffer[1] = panel.AllowDrag;
                    if (imgui.Checkbox(string.format('%s##tTimersConfig_%s', 'Allow Drag', 'AllowDrag'), buffer)) then
                        panel.AllowDrag = buffer[1];
                    end
                    imgui.ShowHelp('When enabled, you can drag the timer panel around.  This will end when config window is closed or another panel is selected.');
                    buffer[1] = panel.ShowDebugTimers;
                    if (imgui.Checkbox(string.format('%s##tTimersConfig_%s', 'Show Debug Timers', 'ShowDebugTimers'), buffer)) then
                        panel.ShowDebugTimers = buffer[1];
                    end
                    imgui.ShowHelp('When enabled, the timer panel will be filled with debug timers.  This will end when config window is closed or another panel is selected.  Dummy timers will self-reset every 30 seconds.');
                    
                    imgui.TextColored(header, 'Behavior');
                    buffer = { panelSettings.ShiftCancel };
                    if (imgui.Checkbox(string.format('%s##tTimersConfig_%s', 'Allow Cancel', 'ShiftCancel'), buffer)) then
                        panelSettings.ShiftCancel = buffer[1];
                        panel:UpdateSettings(panelSettings);
                        settings.save();
                    end
                    imgui.ShowHelp('When enabled, shift-clicking a timer will remove it immediately.');
                    
                    buffer = { panelSettings.CountDown };
                    if (imgui.Checkbox(string.format('%s##tTimersConfig_%s', 'Count Down', 'CountDown'), buffer)) then
                        panelSettings.CountDown = buffer[1];
                        panel:UpdateSettings(panelSettings);
                        settings.save();
                    end
                    imgui.ShowHelp('When enabled, timers will begin full and count down to 0.');
                    
                    
                    buffer = { panelSettings.ShowTenths };
                    if (imgui.Checkbox(string.format('%s##tTimersConfig_%s', 'Show Tenths', 'ShowTenths'), buffer)) then
                        panelSettings.ShowTenths = buffer[1];
                        panel:UpdateSettings(panelSettings);
                        settings.save();
                    end
                    imgui.ShowHelp('When enabled, recast numbers will show 1/10 seconds when less than a minute remains.');
                    
                    buffer = { panelSettings.UseTooltips };
                    if (imgui.Checkbox(string.format('%s##tTimersConfig_%s', 'Show Tooltips', 'ShowTooltips'), buffer)) then
                        panelSettings.UseTooltips = buffer[1];
                        panel:UpdateSettings(panelSettings);
                        settings.save();
                    end
                    imgui.ShowHelp('When enabled, hovering your mouse over a timer will show a tooltip if available.');
                    

                    if (imgui.Button('Edit Colors##tTimersEditColors')) then
                        
                    end
                    imgui.SameLine();
                    if (imgui.Button('Copy To All Panels##tTimersCopyToPanels')) then
                        for _,panel in ipairs(panels) do
                            local targetSettings = gSettings[panel];
                            for key,value in pairs(panelSettings) do
                                if (key ~= 'Position') and (key ~= 'Enabled') then
                                    if type(value) == 'table' then
                                        targetSettings[key] = value:copy(true);
                                    else
                                        targetSettings[key] = value;
                                    end
                                end
                            end
                            gPanels[panel]:UpdateSettings(targetSettings, true);
                        end
                        settings.save();
                    end
                    
                    if (imgui.Button('Defaults(This Panel)##tTimersDefaultThis')) then                        
                        gSettings[panelName] = gDefaultSettings[panelName]:copy(true);
                        gPanels[panelName]:UpdateSettings(gSettings[panelName], true);
                        settings.save();
                        self:GetRenderers(gPanels[panelName].Settings);
                    end
                    imgui.SameLine();
                    if (imgui.Button('Defaults(All Panels)##tTimersDefaultAll')) then
                        for _,panel in ipairs(panels) do
                            gSettings[panel] = gDefaultSettings[panel]:copy(true);
                            gPanels[panel]:UpdateSettings(gSettings[panel], true);
                        end
                        settings.save();
                        self:GetRenderers(gPanels[panelName].Settings);
                    end

                    imgui.EndTabItem();
                end
                
                if imgui.BeginTabItem('Buffs##tTimersConfigBuffsTab') then
                    imgui.EndTabItem();
                end

                imgui.EndTabBar();
            end
            imgui.End();
        end
        
        if (state.IsOpen[1] == false) then
            for name,panel in pairs(gPanels) do
                panel.AllowDrag = false;
                panel.ShowDebugTimers = false;
            end
        end
    end

    if (state.ForceShowPanel) then
        return panels[state.SelectedPanel], state;
    end
end

function config:Show()
    self.State.IsOpen[1] = true;
    self:GetRenderers(gPanels.Buff.Settings);
end

return config;
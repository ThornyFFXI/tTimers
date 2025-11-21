local imgui = require('imgui');
local editor = {
    Selections = {},
};

function editor:DrawTab(label, sourceTable, textFunction)
    if imgui.BeginTabItem(label, string.format("tTimersBlocked%sEditor", label)) then
        local data = T{};
        for key,entry in pairs(sourceTable) do
            data:append({ Key=key, Label=textFunction(key) });
        end
        table.sort(data, function(a,b) return a.Label < b.Label end);
        local removeEntry;
        local selectedEntry;
        
        imgui.TextColored({ 1.0, 0.75, 0.55, 1.0 }, label);
        imgui.BeginChild(string.format("tTimersBlocked%sEditorPanel", label), { 0, 0 }, ImGuiChildFlags_AutoResizeY);
        for _,entry in ipairs(data) do
            local isSelected = (self.Selections[label] == entry.Label);
            if imgui.Selectable(entry.Label, isSelected) then
                self.Selections[label] = entry.Label;
                selectedEntry = entry;
            elseif isSelected then
                selectedEntry = entry;
            end

            if (imgui.IsItemHovered() and imgui.IsMouseDoubleClicked(0)) then
                removeEntry = entry;
            end
        end
        imgui.EndChild();
        if (imgui.Button('Remove Selected')) and selectedEntry then
            sourceTable[selectedEntry.Key] = nil;
            settings.save();
        end
        if (removeEntry) then
            sourceTable[removeEntry.Key] = nil;
            settings.save();
        end
        if imgui.Button('Remove All') then
            for k,_ in pairs(sourceTable) do
                sourceTable[k] = nil;
            end
            settings.save();
        end
        imgui.EndTabItem();
    end
end

local function stringToLabel(str)
    local prefix, suffix = str:match("([^:]+):(.+)");
    if prefix == nil or suffix == nil then
        return "Unknown";
    end
    if (prefix == "Spell") then
        local num = tonumber(suffix);
        if num then
            local res = AshitaCore:GetResourceManager():GetSpellById(num);
            if res then
                return res.Name[1];
            end
            return string.format('Unknown Spell[%u]', num);
        end
        return "Unknown Spell";
    end
    if (prefix == "Ability") then
        local num = tonumber(suffix);
        if num then
            local res = AshitaCore:GetResourceManager():GetAbilityById(num-256);
            if res then
                return res.Name[1];
            end
            return string.format('Unknown Ability[%u]', num);
        end
        return "Unknown Ability";
    end
    if (prefix == "Label") then
        return suffix;
    end
    
    return "Unknown";
end

function editor:DrawTabs()
    self:DrawTab("Blocked Buffs", gSettings.Buff.Blocked, stringToLabel);
    self:DrawTab("Blocked Debuffs", gSettings.Debuff.Blocked, stringToLabel);
    self:DrawTab("Blocked Recasts", gSettings.Recast.Blocked, stringToLabel);
end

return editor;
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

local thisFile = debug.getinfo(1, "S").source:sub(2);
local dataTracker = dofile(string.gsub(thisFile, 'include.lua', 'data.lua'));

local abilityCalculators = {};
local mobAbilityCalculators = {};
local petAbilityCalculators = {};
local spellCalculators = {};
local weaponSkillCalculators = {};

do
    local calculators = T{
        { file='abilities.lua', buffer=abilityCalculators },
        { file='bluemagic.lua', buffer=spellCalculators },
        { file='dark.lua', buffer=spellCalculators },
        { file='enfeebling.lua', buffer=spellCalculators },
        { file='enhancing.lua', buffer=spellCalculators },
        { file='geomancy.lua', buffer=spellCalculators },
        { file='incidental.lua', buffer=spellCalculators },
        { file='miscspells.lua', buffer=spellCalculators },
        { file='ninjutsu.lua', buffer=spellCalculators },
        { file='songs.lua', buffer=spellCalculators },
        { file='weaponskills.lua', buffer=weaponSkillCalculators },
    };
    for _,calculator in ipairs(calculators) do
        dofile(string.gsub(thisFile, 'include.lua', calculator.file))(dataTracker, calculator.buffer);
    end
end

local exports = {};

function exports:GetDataTracker()
    return dataTracker;
end

function exports:GetAbilityDuration(actionId, targetId)
    local calculator = abilityCalculators[actionId];
    if calculator ~= nil then
        return calculator(targetId);
    else
        return nil;
    end
end

function exports:GetMobAbilityDuration(actionId, targetId)
    local calculator = mobAbilityCalculators[actionId];
    if calculator ~= nil then
        return calculator(targetId);
    else
        return nil;
    end
end

function exports:GetPetAbilityDuration(actionId, targetId)
    local calculator = petAbilityCalculators[actionId];
    if calculator ~= nil then
        return calculator(targetId);
    else
        return nil;
    end
end

function exports:GetSpellDuration(actionId, targetId)
    local calculator = spellCalculators[actionId];
    if calculator ~= nil then
        return calculator(targetId);
    else
        return nil;
    end
end

function exports:GetWeaponskillDuration(actionId, targetId)
    local calculator = weaponSkillCalculators[actionId];
    if calculator ~= nil then
        return calculator(targetId);
    else
        return nil;
    end
end

--DEBUG: Tries calling all potential handlers to check for errors and prints a list of which are marked to ashita folder..
local debugMode = false;
if (debugMode) then
    local ws = {};
    for i = 1,512 do
        local abil = AshitaCore:GetResourceManager():GetAbilityById(i);
        if (abil) and (string.len(abil.Name[1]) > 1) then
            if (weaponSkillCalculators[i] ~= nil) then
                ws[i] = true;
            else
                ws[i] = false;
            end
        end
    end
    local out = io.open(string.format('%sWS.lua', AshitaCore:GetInstallPath()), 'w');
    out:write('local active = T{\n');
    for i = 1,512 do
        if (ws[i] == true) then
            local abil = AshitaCore:GetResourceManager():GetAbilityById(i);
            out:write(string.format('    %u, --%s\n', i, abil.Name[1]));
            weaponSkillCalculators[i](1);
        end
    end
    out:write('};\nlocal inactive = T{\n');
    for i = 1,512 do
        if (ws[i] == false) then
            local abil = AshitaCore:GetResourceManager():GetAbilityById(i);
            out:write(string.format('    %u, --%s\n', i, abil.Name[1]));
        end
    end
    out:write('};');
    out:close();


    local abil = {};
    for i = 1,1024 do
        local ability = AshitaCore:GetResourceManager():GetAbilityById(i + 512);
        if (abil) and (string.len(ability.Name[1]) > 1) then
            if (abilityCalculators[i] ~= nil) then
                abil[i] = true;
            else
                abil[i] = false;
            end
        end
    end
    local out = io.open(string.format('%sabilities.lua', AshitaCore:GetInstallPath()), 'w');
    out:write('local active = T{\n');
    for i = 1,1024 do
        if (abil[i] == true) then
            local ability = AshitaCore:GetResourceManager():GetAbilityById(i + 512);
            out:write(string.format('    %u, --%s\n', i, ability.Name[1]));
            abilityCalculators[i](1);
        end
    end
    out:write('};\nlocal inactive = T{\n');
    for i = 1,1024 do
        if (abil[i] == false) then
            local ability = AshitaCore:GetResourceManager():GetAbilityById(i + 512);
            out:write(string.format('    %u, --%s\n', i, ability.Name[1]));
        end
    end
    out:write('};');
    out:close();

    local spell = {};
    for i = 1,1024 do
        local spellData = AshitaCore:GetResourceManager():GetSpellById(i);
        if (spellData) and (string.len(spellData.Name[1]) > 1) then
            if (spellCalculators[i] ~= nil) then
                spell[i] = true;
            else
                spell[i] = false;
            end
        end
    end
    local out = io.open(string.format('%sspells.lua', AshitaCore:GetInstallPath()), 'w');
    out:write('local active = T{\n');
    for i = 1,1024 do
        if (spell[i] == true) then
            local spellData = AshitaCore:GetResourceManager():GetSpellById(i);
            out:write(string.format('    %u, --%s\n', i, spellData.Name[1]));
            spellCalculators[i](1);
        end
    end
    out:write('};\nlocal inactive = T{\n');
    for i = 1,1024 do
        if (spell[i] == false) then
            local spellData = AshitaCore:GetResourceManager():GetSpellById(i);
            out:write(string.format('    %u, --%s\n', i, spellData.Name[1]));
        end
    end
    out:write('};');
    out:close();
end

return exports;

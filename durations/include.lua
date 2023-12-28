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

local thisFile = debug.getinfo(2, "S").source:sub(2);
local dataTracker = dofile(string.gsub(thisFile, 'include.lua', 'data.lua'));

local abilityCalculators = {};
local mobAbilityCalculators = {};
local petAbilityCalculators = {};
local spellCalculators = {};
local weaponSkillCalculators = {};

do
    local calculators = T{
        { file='enfeebling.lua', buffer=spellCalculators },
        { file='enhancing.lua', buffer=spellCalculators },
        --[[
        { file='abilities.lua', buffer=abilityCalculators },
        { file='bluemagic.lua', buffer=spellCalculators },
        { file='dark.lua', buffer=spellCalculators },
        { file='geomancy.lua', buffer=spellCalculators },
        { file='incidental.lua', buffer=spellCalculators },
        { file='miscspells.lua', buffer=spellCalculators },
        { file='ninjutsu.lua', buffer=spellCalculators },
        { file='songs.lua', buffer=spellCalculators },
        { file='weaponskills.lua', buffer=weaponSkillCalculators },
        ]]--
    }
    for _,calculator in ipairs(calculators) do
        dofile(string.gsub(thisFile, 'include.lua', calculator.file))(dataTracker, calculator.buffer);
    end
end

local exports = {};

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

function exports.GetPetAbilityDuration(actionId, targetId)
    local calculator = petAbilityCalculators[actionId];
    if calculator ~= nil then
        return calculator(targetId);
    else
        return nil;
    end
end

function exports.GetSpellDuration(actionId, targetId)
    local calculator = spellCalculators[actionId];
    if calculator ~= nil then
        return calculator(targetId);
    else
        return nil;
    end
end

function exports.GetWeaponskillDuration(actionId, targetId)
    local calculator = weaponSkillCalculators[actionId];
    if calculator ~= nil then
        return calculator(targetId);
    else
        return nil;
    end
end

return exports;

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

local indiDuration = {
    [21085] = 15, --Solstice
    [27192] = 12, --Bagua Pants
    [27193] = 15, --Bagua Pants +1
    [23284] = 18, --Bagua Pants +2
    [23619] = 21, --Bagua Pants +3
    [27451] = 15, --Azimuth Gaiters
    [27452] = 20, --Azimuth Gaiters +1
    [26266] = 20 --Nantosuelta's Cape
};

local function CalculateGeomancyDuration(targetId)
    local augments = gData.ParseAugments();
    return (600 * augments.GeomancyDuration);
end

local function CalculateIndicolureDuration(targetId)
    local augments = gData.ParseAugments();
    local duration = 180 + gData.EquipSum(indiDuration);
    local indiduration = augments.Generic[0x4E2];
    if indiDuration then
        local multiplier = 1.00;
        for _,v in pairs(indiDuration) do
            multiplier = multiplier + (0.01 * (v + 1));
        end
        duration = duration * multiplier;
    end
    return duration;
end

local function FillSpellTable(spellTable)
    --Indi-Regen
    spellTable[768] = function(targetId)
        return CalculateIndicolureDuration(targetId);
    end

    --Indi-Poison
    spellTable[769] = function(targetId)
        return CalculateIndicolureDuration(targetId);
    end

    --Indi-Refresh
    spellTable[770] = function(targetId)
        return CalculateIndicolureDuration(targetId);
    end

    --Indi-Haste
    spellTable[771] = function(targetId)
        return CalculateIndicolureDuration(targetId);
    end

    --Indi-STR
    spellTable[772] = function(targetId)
        return CalculateIndicolureDuration(targetId);
    end

    --Indi-DEX
    spellTable[773] = function(targetId)
        return CalculateIndicolureDuration(targetId);
    end

    --Indi-VIT
    spellTable[774] = function(targetId)
        return CalculateIndicolureDuration(targetId);
    end

    --Indi-AGI
    spellTable[775] = function(targetId)
        return CalculateIndicolureDuration(targetId);
    end

    --Indi-INT
    spellTable[776] = function(targetId)
        return CalculateIndicolureDuration(targetId);
    end

    --Indi-MND
    spellTable[777] = function(targetId)
        return CalculateIndicolureDuration(targetId);
    end

    --Indi-CHR
    spellTable[778] = function(targetId)
        return CalculateIndicolureDuration(targetId);
    end

    --Indi-Fury
    spellTable[779] = function(targetId)
        return CalculateIndicolureDuration(targetId);
    end

    --Indi-Barrier
    spellTable[780] = function(targetId)
        return CalculateIndicolureDuration(targetId);
    end

    --Indi-Acumen
    spellTable[781] = function(targetId)
        return CalculateIndicolureDuration(targetId);
    end

    --Indi-Fend
    spellTable[782] = function(targetId)
        return CalculateIndicolureDuration(targetId);
    end

    --Indi-Precision
    spellTable[783] = function(targetId)
        return CalculateIndicolureDuration(targetId);
    end

    --Indi-Voidance
    spellTable[784] = function(targetId)
        return CalculateIndicolureDuration(targetId);
    end

    --Indi-Focus
    spellTable[785] = function(targetId)
        return CalculateIndicolureDuration(targetId);
    end

    --Indi-Attunement
    spellTable[786] = function(targetId)
        return CalculateIndicolureDuration(targetId);
    end

    --Indi-Wilt
    spellTable[787] = function(targetId)
        return CalculateIndicolureDuration(targetId);
    end

    --Indi-Frailty
    spellTable[788] = function(targetId)
        return CalculateIndicolureDuration(targetId);
    end

    --Indi-Fade
    spellTable[789] = function(targetId)
        return CalculateIndicolureDuration(targetId);
    end

    --Indi-Malaise
    spellTable[790] = function(targetId)
        return CalculateIndicolureDuration(targetId);
    end

    --Indi-Slip
    spellTable[791] = function(targetId)
        return CalculateIndicolureDuration(targetId);
    end

    --Indi-Torpor
    spellTable[792] = function(targetId)
        return CalculateIndicolureDuration(targetId);
    end

    --Indi-Vex
    spellTable[793] = function(targetId)
        return CalculateIndicolureDuration(targetId);
    end

    --Indi-Languor
    spellTable[794] = function(targetId)
        return CalculateIndicolureDuration(targetId);
    end

    --Indi-Slow
    spellTable[795] = function(targetId)
        return CalculateIndicolureDuration(targetId);
    end

    --Indi-Paralysis
    spellTable[796] = function(targetId)
        return CalculateIndicolureDuration(targetId);
    end

    --Indi-Gravity
    spellTable[797] = function(targetId)
        return CalculateIndicolureDuration(targetId);
    end

    --Geo-Regen
    spellTable[798] = function(targetId)
        return CalculateGeomancyDuration(targetId);
    end

    --Geo-Poison
    spellTable[799] = function(targetId)
        return CalculateGeomancyDuration(targetId);
    end

    --Geo-Refresh
    spellTable[800] = function(targetId)
        return CalculateGeomancyDuration(targetId);
    end

    --Geo-Haste
    spellTable[801] = function(targetId)
        return CalculateGeomancyDuration(targetId);
    end

    --Geo-STR
    spellTable[802] = function(targetId)
        return CalculateGeomancyDuration(targetId);
    end

    --Geo-DEX
    spellTable[803] = function(targetId)
        return CalculateGeomancyDuration(targetId);
    end

    --Geo-VIT
    spellTable[804] = function(targetId)
        return CalculateGeomancyDuration(targetId);
    end

    --Geo-AGI
    spellTable[805] = function(targetId)
        return CalculateGeomancyDuration(targetId);
    end

    --Geo-INT
    spellTable[806] = function(targetId)
        return CalculateGeomancyDuration(targetId);
    end

    --Geo-MND
    spellTable[807] = function(targetId)
        return CalculateGeomancyDuration(targetId);
    end

    --Geo-CHR
    spellTable[808] = function(targetId)
        return CalculateGeomancyDuration(targetId);
    end

    --Geo-Fury
    spellTable[809] = function(targetId)
        return CalculateGeomancyDuration(targetId);
    end

    --Geo-Barrier
    spellTable[810] = function(targetId)
        return CalculateGeomancyDuration(targetId);
    end

    --Geo-Acumen
    spellTable[811] = function(targetId)
        return CalculateGeomancyDuration(targetId);
    end

    --Geo-Fend
    spellTable[812] = function(targetId)
        return CalculateGeomancyDuration(targetId);
    end

    --Geo-Precision
    spellTable[813] = function(targetId)
        return CalculateGeomancyDuration(targetId);
    end

    --Geo-Voidance
    spellTable[814] = function(targetId)
        return CalculateGeomancyDuration(targetId);
    end

    --Geo-Focus
    spellTable[815] = function(targetId)
        return CalculateGeomancyDuration(targetId);
    end

    --Geo-Attunement
    spellTable[816] = function(targetId)
        return CalculateGeomancyDuration(targetId);
    end

    --Geo-Wilt
    spellTable[817] = function(targetId)
        return CalculateGeomancyDuration(targetId);
    end

    --Geo-Frailty
    spellTable[818] = function(targetId)
        return CalculateGeomancyDuration(targetId);
    end

    --Geo-Fade
    spellTable[819] = function(targetId)
        return CalculateGeomancyDuration(targetId);
    end

    --Geo-Malaise
    spellTable[820] = function(targetId)
        return CalculateGeomancyDuration(targetId);
    end

    --Geo-Slip
    spellTable[821] = function(targetId)
        return CalculateGeomancyDuration(targetId);
    end

    --Geo-Torpor
    spellTable[822] = function(targetId)
        return CalculateGeomancyDuration(targetId);
    end

    --Geo-Vex
    spellTable[823] = function(targetId)
        return CalculateGeomancyDuration(targetId);
    end

    --Geo-Languor
    spellTable[824] = function(targetId)
        return CalculateGeomancyDuration(targetId);
    end

    --Geo-Slow
    spellTable[825] = function(targetId)
        return CalculateGeomancyDuration(targetId);
    end

    --Geo-Paralysis
    spellTable[826] = function(targetId)
        return CalculateGeomancyDuration(targetId);
    end

    --Geo-Gravity
    spellTable[827] = function(targetId)
        return CalculateGeomancyDuration(targetId);
    end
end

return FillSpellTable;
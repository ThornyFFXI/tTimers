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
local dataTracker;

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
    local augments = dataTracker:ParseAugments();
    local multiplier = 1 + (augments.GeomancyDuration or 0);
    return (600 * multiplier);
end

local function CalculateIndicolureDuration(targetId)
    local augments = dataTracker:ParseAugments();
    local duration = 180 + dataTracker:EquipSum(indiDuration);
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

local function Initialize(tracker, buffer)
    dataTracker = tracker;

    --Indi-Regen
    buffer[768] = function(targetId)
        return CalculateIndicolureDuration(targetId);
    end

    --Indi-Poison
    buffer[769] = function(targetId)
        return CalculateIndicolureDuration(targetId);
    end

    --Indi-Refresh
    buffer[770] = function(targetId)
        return CalculateIndicolureDuration(targetId);
    end

    --Indi-Haste
    buffer[771] = function(targetId)
        return CalculateIndicolureDuration(targetId);
    end

    --Indi-STR
    buffer[772] = function(targetId)
        return CalculateIndicolureDuration(targetId);
    end

    --Indi-DEX
    buffer[773] = function(targetId)
        return CalculateIndicolureDuration(targetId);
    end

    --Indi-VIT
    buffer[774] = function(targetId)
        return CalculateIndicolureDuration(targetId);
    end

    --Indi-AGI
    buffer[775] = function(targetId)
        return CalculateIndicolureDuration(targetId);
    end

    --Indi-INT
    buffer[776] = function(targetId)
        return CalculateIndicolureDuration(targetId);
    end

    --Indi-MND
    buffer[777] = function(targetId)
        return CalculateIndicolureDuration(targetId);
    end

    --Indi-CHR
    buffer[778] = function(targetId)
        return CalculateIndicolureDuration(targetId);
    end

    --Indi-Fury
    buffer[779] = function(targetId)
        return CalculateIndicolureDuration(targetId);
    end

    --Indi-Barrier
    buffer[780] = function(targetId)
        return CalculateIndicolureDuration(targetId);
    end

    --Indi-Acumen
    buffer[781] = function(targetId)
        return CalculateIndicolureDuration(targetId);
    end

    --Indi-Fend
    buffer[782] = function(targetId)
        return CalculateIndicolureDuration(targetId);
    end

    --Indi-Precision
    buffer[783] = function(targetId)
        return CalculateIndicolureDuration(targetId);
    end

    --Indi-Voidance
    buffer[784] = function(targetId)
        return CalculateIndicolureDuration(targetId);
    end

    --Indi-Focus
    buffer[785] = function(targetId)
        return CalculateIndicolureDuration(targetId);
    end

    --Indi-Attunement
    buffer[786] = function(targetId)
        return CalculateIndicolureDuration(targetId);
    end

    --Indi-Wilt
    buffer[787] = function(targetId)
        return CalculateIndicolureDuration(targetId);
    end

    --Indi-Frailty
    buffer[788] = function(targetId)
        return CalculateIndicolureDuration(targetId);
    end

    --Indi-Fade
    buffer[789] = function(targetId)
        return CalculateIndicolureDuration(targetId);
    end

    --Indi-Malaise
    buffer[790] = function(targetId)
        return CalculateIndicolureDuration(targetId);
    end

    --Indi-Slip
    buffer[791] = function(targetId)
        return CalculateIndicolureDuration(targetId);
    end

    --Indi-Torpor
    buffer[792] = function(targetId)
        return CalculateIndicolureDuration(targetId);
    end

    --Indi-Vex
    buffer[793] = function(targetId)
        return CalculateIndicolureDuration(targetId);
    end

    --Indi-Languor
    buffer[794] = function(targetId)
        return CalculateIndicolureDuration(targetId);
    end

    --Indi-Slow
    buffer[795] = function(targetId)
        return CalculateIndicolureDuration(targetId);
    end

    --Indi-Paralysis
    buffer[796] = function(targetId)
        return CalculateIndicolureDuration(targetId);
    end

    --Indi-Gravity
    buffer[797] = function(targetId)
        return CalculateIndicolureDuration(targetId);
    end

    --Geo-Regen
    buffer[798] = function(targetId)
        return CalculateGeomancyDuration(targetId);
    end

    --Geo-Poison
    buffer[799] = function(targetId)
        return CalculateGeomancyDuration(targetId);
    end

    --Geo-Refresh
    buffer[800] = function(targetId)
        return CalculateGeomancyDuration(targetId);
    end

    --Geo-Haste
    buffer[801] = function(targetId)
        return CalculateGeomancyDuration(targetId);
    end

    --Geo-STR
    buffer[802] = function(targetId)
        return CalculateGeomancyDuration(targetId);
    end

    --Geo-DEX
    buffer[803] = function(targetId)
        return CalculateGeomancyDuration(targetId);
    end

    --Geo-VIT
    buffer[804] = function(targetId)
        return CalculateGeomancyDuration(targetId);
    end

    --Geo-AGI
    buffer[805] = function(targetId)
        return CalculateGeomancyDuration(targetId);
    end

    --Geo-INT
    buffer[806] = function(targetId)
        return CalculateGeomancyDuration(targetId);
    end

    --Geo-MND
    buffer[807] = function(targetId)
        return CalculateGeomancyDuration(targetId);
    end

    --Geo-CHR
    buffer[808] = function(targetId)
        return CalculateGeomancyDuration(targetId);
    end

    --Geo-Fury
    buffer[809] = function(targetId)
        return CalculateGeomancyDuration(targetId);
    end

    --Geo-Barrier
    buffer[810] = function(targetId)
        return CalculateGeomancyDuration(targetId);
    end

    --Geo-Acumen
    buffer[811] = function(targetId)
        return CalculateGeomancyDuration(targetId);
    end

    --Geo-Fend
    buffer[812] = function(targetId)
        return CalculateGeomancyDuration(targetId);
    end

    --Geo-Precision
    buffer[813] = function(targetId)
        return CalculateGeomancyDuration(targetId);
    end

    --Geo-Voidance
    buffer[814] = function(targetId)
        return CalculateGeomancyDuration(targetId);
    end

    --Geo-Focus
    buffer[815] = function(targetId)
        return CalculateGeomancyDuration(targetId);
    end

    --Geo-Attunement
    buffer[816] = function(targetId)
        return CalculateGeomancyDuration(targetId);
    end

    --Geo-Wilt
    buffer[817] = function(targetId)
        return CalculateGeomancyDuration(targetId);
    end

    --Geo-Frailty
    buffer[818] = function(targetId)
        return CalculateGeomancyDuration(targetId);
    end

    --Geo-Fade
    buffer[819] = function(targetId)
        return CalculateGeomancyDuration(targetId);
    end

    --Geo-Malaise
    buffer[820] = function(targetId)
        return CalculateGeomancyDuration(targetId);
    end

    --Geo-Slip
    buffer[821] = function(targetId)
        return CalculateGeomancyDuration(targetId);
    end

    --Geo-Torpor
    buffer[822] = function(targetId)
        return CalculateGeomancyDuration(targetId);
    end

    --Geo-Vex
    buffer[823] = function(targetId)
        return CalculateGeomancyDuration(targetId);
    end

    --Geo-Languor
    buffer[824] = function(targetId)
        return CalculateGeomancyDuration(targetId);
    end

    --Geo-Slow
    buffer[825] = function(targetId)
        return CalculateGeomancyDuration(targetId);
    end

    --Geo-Paralysis
    buffer[826] = function(targetId)
        return CalculateGeomancyDuration(targetId);
    end

    --Geo-Gravity
    buffer[827] = function(targetId)
        return CalculateGeomancyDuration(targetId);
    end
end

return Initialize;
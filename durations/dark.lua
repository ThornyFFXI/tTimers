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


local absorbDuration = {
    [18559] = 9, --Void Scythe

    [13887] = 10, --Black Sallet
    [13888] = 10, --Onyx Sallet
    [14010] = 10, --Black Gadlings
    [14011] = 10, --Onyx Gadlings
    [15400] = 10, --Black Cuisses
    [15401] = 10, --Onyx Cuisses
    [15339] = 10, --Black Sollerets
    [15340] = 10, --Onyx Sollerets

    [15013] = 10, --Vicious Mufflers
    [10994] = 20, --Chuparrosa Mantle

};
local absorbPercent = {
    [23047] = 0.10, --Ig. Burgonet +2
    [23382] = 0.20, --Ig. Burgonet +3
    [26253] = 0.10, --Ankou's Mantle
    [26188] = 0.10, --Kishar Ring
};

local function Initialize(tracker, buffer)
    dataTracker = tracker;

    --Absorb-ACC
    buffer[242] = function(targetId)
        local base = 90 + dataTracker:EquipSum(absorbDuration);
        return base * (1.0 + dataTracker:EquipSum(absorbPercent));
    end

    --Absorb-STR
    buffer[266] = function(targetId)
        local base = 90 + dataTracker:EquipSum(absorbDuration);
        return base * (1.0 + dataTracker:EquipSum(absorbPercent));
    end
    
    --Absorb-DEX
    buffer[267] = function(targetId)
        local base = 90 + dataTracker:EquipSum(absorbDuration);
        return base * (1.0 + dataTracker:EquipSum(absorbPercent));
    end
    
    --Absorb-VIT
    buffer[268] = function(targetId)
        local base = 90 + dataTracker:EquipSum(absorbDuration);
        return base * (1.0 + dataTracker:EquipSum(absorbPercent));
    end
    
    --Absorb-AGI
    buffer[269] = function(targetId)
        local base = 90 + dataTracker:EquipSum(absorbDuration);
        return base * (1.0 + dataTracker:EquipSum(absorbPercent));
    end
    
    --Absorb-INT
    buffer[270] = function(targetId)
        local base = 90 + dataTracker:EquipSum(absorbDuration);
        return base * (1.0 + dataTracker:EquipSum(absorbPercent));
    end
    
    --Absorb-MND
    buffer[271] = function(targetId)
        local base = 90 + dataTracker:EquipSum(absorbDuration);
        return base * (1.0 + dataTracker:EquipSum(absorbPercent));
    end

    --Absorb-CHR
    buffer[272] = function(targetId)
        local base = 90 + dataTracker:EquipSum(absorbDuration);
        return base * (1.0 + dataTracker:EquipSum(absorbPercent));
    end

    --Dread Spikes
    buffer[277] = function(targetId)
        return 180;
    end

    --Klimaform
    buffer[287] = function(targetId)
        return 300;
    end

    --Endark
    buffer[311] = function(targetId)
        return 180;
    end

    --Endark II
    buffer[856] = function(targetId)
        return 180;
    end
end

return Initialize;
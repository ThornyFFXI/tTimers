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

local rankItems = {
    --Ajax +1
    [27639] = {
        [0] = {
            [1] = { { Stat='EnhancingDuration', Value=0 } },
            [2] = { { Stat='EnhancingDuration', Value=0 } },
            [3] = { { Stat='EnhancingDuration', Value=0 } },
            [4] = { { Stat='EnhancingDuration', Value=0 } },
            [5] = { { Stat='EnhancingDuration', Value=0 } },
            [6] = { { Stat='EnhancingDuration', Value=0.01 } },
            [7] = { { Stat='EnhancingDuration', Value=0.02 } },
            [8] = { { Stat='EnhancingDuration', Value=0.03 } },
            [9] = { { Stat='EnhancingDuration', Value=0.04 } },
            [10] = { { Stat='EnhancingDuration', Value=0.05 } },
            [11] = { { Stat='EnhancingDuration', Value=0.06 } },
            [12] = { { Stat='EnhancingDuration', Value=0.07 } },
            [13] = { { Stat='EnhancingDuration', Value=0.08 } },
            [14] = { { Stat='EnhancingDuration', Value=0.09 } },
            [15] = { { Stat='EnhancingDuration', Value=0.10 } },
        },
    },

    --Dls. Torque
    [25441] = {
        [0] = {
            [1] = { { Stat='EnhancingDuration', Value=0.01 }, { Stat='EnfeeblingDuration', Value=0.01 } },
            [2] = { { Stat='EnhancingDuration', Value=0.02 }, { Stat='EnfeeblingDuration', Value=0.02 } },
            [3] = { { Stat='EnhancingDuration', Value=0.03 }, { Stat='EnfeeblingDuration', Value=0.03 } },
            [4] = { { Stat='EnhancingDuration', Value=0.04 }, { Stat='EnfeeblingDuration', Value=0.04 } },
            [5] = { { Stat='EnhancingDuration', Value=0.05 }, { Stat='EnfeeblingDuration', Value=0.05 } },
            [6] = { { Stat='EnhancingDuration', Value=0.06 }, { Stat='EnfeeblingDuration', Value=0.06 } },
            [7] = { { Stat='EnhancingDuration', Value=0.07 }, { Stat='EnfeeblingDuration', Value=0.07 } },
            [8] = { { Stat='EnhancingDuration', Value=0.08 }, { Stat='EnfeeblingDuration', Value=0.08 } },
            [9] = { { Stat='EnhancingDuration', Value=0.09 }, { Stat='EnfeeblingDuration', Value=0.09 } },
            [10] = { { Stat='EnhancingDuration', Value=0.10 }, { Stat='EnfeeblingDuration', Value=0.10 } },
            [11] = { { Stat='EnhancingDuration', Value=0.11 }, { Stat='EnfeeblingDuration', Value=0.11 } },
            [12] = { { Stat='EnhancingDuration', Value=0.12 }, { Stat='EnfeeblingDuration', Value=0.12 } },
            [13] = { { Stat='EnhancingDuration', Value=0.13 }, { Stat='EnfeeblingDuration', Value=0.13 } },
            [14] = { { Stat='EnhancingDuration', Value=0.14 }, { Stat='EnfeeblingDuration', Value=0.14 } },
            [15] = { { Stat='EnhancingDuration', Value=0.15 }, { Stat='EnfeeblingDuration', Value=0.15 } },
        },
    },
    
    --Dls. Torque +1
    [25442] = {
        [0] = {
            [1] = { { Stat='EnhancingDuration', Value=0.01 }, { Stat='EnfeeblingDuration', Value=0.01 } },
            [2] = { { Stat='EnhancingDuration', Value=0.02 }, { Stat='EnfeeblingDuration', Value=0.02 } },
            [3] = { { Stat='EnhancingDuration', Value=0.03 }, { Stat='EnfeeblingDuration', Value=0.03 } },
            [4] = { { Stat='EnhancingDuration', Value=0.04 }, { Stat='EnfeeblingDuration', Value=0.04 } },
            [5] = { { Stat='EnhancingDuration', Value=0.05 }, { Stat='EnfeeblingDuration', Value=0.05 } },
            [6] = { { Stat='EnhancingDuration', Value=0.06 }, { Stat='EnfeeblingDuration', Value=0.06 } },
            [7] = { { Stat='EnhancingDuration', Value=0.07 }, { Stat='EnfeeblingDuration', Value=0.07 } },
            [8] = { { Stat='EnhancingDuration', Value=0.08 }, { Stat='EnfeeblingDuration', Value=0.08 } },
            [9] = { { Stat='EnhancingDuration', Value=0.09 }, { Stat='EnfeeblingDuration', Value=0.09 } },
            [10] = { { Stat='EnhancingDuration', Value=0.10 }, { Stat='EnfeeblingDuration', Value=0.10 } },
            [11] = { { Stat='EnhancingDuration', Value=0.11 }, { Stat='EnfeeblingDuration', Value=0.11 } },
            [12] = { { Stat='EnhancingDuration', Value=0.12 }, { Stat='EnfeeblingDuration', Value=0.12 } },
            [13] = { { Stat='EnhancingDuration', Value=0.13 }, { Stat='EnfeeblingDuration', Value=0.13 } },
            [14] = { { Stat='EnhancingDuration', Value=0.14 }, { Stat='EnfeeblingDuration', Value=0.14 } },
            [15] = { { Stat='EnhancingDuration', Value=0.15 }, { Stat='EnfeeblingDuration', Value=0.15 } },
            [16] = { { Stat='EnhancingDuration', Value=0.16 }, { Stat='EnfeeblingDuration', Value=0.16 } },
            [17] = { { Stat='EnhancingDuration', Value=0.17 }, { Stat='EnfeeblingDuration', Value=0.17 } },
            [18] = { { Stat='EnhancingDuration', Value=0.18 }, { Stat='EnfeeblingDuration', Value=0.18 } },
            [19] = { { Stat='EnhancingDuration', Value=0.19 }, { Stat='EnfeeblingDuration', Value=0.19 } },
            [20] = { { Stat='EnhancingDuration', Value=0.20 }, { Stat='EnfeeblingDuration', Value=0.20 } },
        },
    },

    --Dls. Torque +2
    [25443] = {
        [0] = {
            [1] = { { Stat='EnhancingDuration', Value=0.01 }, { Stat='EnfeeblingDuration', Value=0.01 } },
            [2] = { { Stat='EnhancingDuration', Value=0.02 }, { Stat='EnfeeblingDuration', Value=0.02 } },
            [3] = { { Stat='EnhancingDuration', Value=0.03 }, { Stat='EnfeeblingDuration', Value=0.03 } },
            [4] = { { Stat='EnhancingDuration', Value=0.04 }, { Stat='EnfeeblingDuration', Value=0.04 } },
            [5] = { { Stat='EnhancingDuration', Value=0.05 }, { Stat='EnfeeblingDuration', Value=0.05 } },
            [6] = { { Stat='EnhancingDuration', Value=0.06 }, { Stat='EnfeeblingDuration', Value=0.06 } },
            [7] = { { Stat='EnhancingDuration', Value=0.07 }, { Stat='EnfeeblingDuration', Value=0.07 } },
            [8] = { { Stat='EnhancingDuration', Value=0.08 }, { Stat='EnfeeblingDuration', Value=0.08 } },
            [9] = { { Stat='EnhancingDuration', Value=0.09 }, { Stat='EnfeeblingDuration', Value=0.09 } },
            [10] = { { Stat='EnhancingDuration', Value=0.10 }, { Stat='EnfeeblingDuration', Value=0.10 } },
            [11] = { { Stat='EnhancingDuration', Value=0.11 }, { Stat='EnfeeblingDuration', Value=0.11 } },
            [12] = { { Stat='EnhancingDuration', Value=0.12 }, { Stat='EnfeeblingDuration', Value=0.12 } },
            [13] = { { Stat='EnhancingDuration', Value=0.13 }, { Stat='EnfeeblingDuration', Value=0.13 } },
            [14] = { { Stat='EnhancingDuration', Value=0.14 }, { Stat='EnfeeblingDuration', Value=0.14 } },
            [15] = { { Stat='EnhancingDuration', Value=0.15 }, { Stat='EnfeeblingDuration', Value=0.15 } },
            [16] = { { Stat='EnhancingDuration', Value=0.16 }, { Stat='EnfeeblingDuration', Value=0.16 } },
            [17] = { { Stat='EnhancingDuration', Value=0.17 }, { Stat='EnfeeblingDuration', Value=0.17 } },
            [18] = { { Stat='EnhancingDuration', Value=0.18 }, { Stat='EnfeeblingDuration', Value=0.18 } },
            [19] = { { Stat='EnhancingDuration', Value=0.19 }, { Stat='EnfeeblingDuration', Value=0.19 } },
            [20] = { { Stat='EnhancingDuration', Value=0.20 }, { Stat='EnfeeblingDuration', Value=0.20 } },
            [21] = { { Stat='EnhancingDuration', Value=0.21 }, { Stat='EnfeeblingDuration', Value=0.21 } },
            [22] = { { Stat='EnhancingDuration', Value=0.22 }, { Stat='EnfeeblingDuration', Value=0.22 } },
            [23] = { { Stat='EnhancingDuration', Value=0.23 }, { Stat='EnfeeblingDuration', Value=0.23 } },
            [24] = { { Stat='EnhancingDuration', Value=0.24 }, { Stat='EnfeeblingDuration', Value=0.24 } },
            [25] = { { Stat='EnhancingDuration', Value=0.25 }, { Stat='EnfeeblingDuration', Value=0.25 } },
        },
    },
    

    --Bagua Charm
    [25537] = {
        [0] = {
            [1] = { { Stat='GeomancyDuration', Value=0.01 } },
            [2] = { { Stat='GeomancyDuration', Value=0.02 } },
            [3] = { { Stat='GeomancyDuration', Value=0.03 } },
            [4] = { { Stat='GeomancyDuration', Value=0.04 } },
            [5] = { { Stat='GeomancyDuration', Value=0.05 } },
            [6] = { { Stat='GeomancyDuration', Value=0.06 } },
            [7] = { { Stat='GeomancyDuration', Value=0.07 } },
            [8] = { { Stat='GeomancyDuration', Value=0.08 } },
            [9] = { { Stat='GeomancyDuration', Value=0.09 } },
            [10] = { { Stat='GeomancyDuration', Value=0.1 } },
            [11] = { { Stat='GeomancyDuration', Value=0.11 } },
            [12] = { { Stat='GeomancyDuration', Value=0.12 } },
            [13] = { { Stat='GeomancyDuration', Value=0.13 } },
            [14] = { { Stat='GeomancyDuration', Value=0.14 } },
            [15] = { { Stat='GeomancyDuration', Value=0.15 } },
        },
    },

    --Bagua Charm +1
    [25538] = {
        [0] = {
            [1] = { { Stat='GeomancyDuration', Value=0.01 } },
            [2] = { { Stat='GeomancyDuration', Value=0.02 } },
            [3] = { { Stat='GeomancyDuration', Value=0.03 } },
            [4] = { { Stat='GeomancyDuration', Value=0.04 } },
            [5] = { { Stat='GeomancyDuration', Value=0.05 } },
            [6] = { { Stat='GeomancyDuration', Value=0.06 } },
            [7] = { { Stat='GeomancyDuration', Value=0.07 } },
            [8] = { { Stat='GeomancyDuration', Value=0.08 } },
            [9] = { { Stat='GeomancyDuration', Value=0.09 } },
            [10] = { { Stat='GeomancyDuration', Value=0.1 } },
            [11] = { { Stat='GeomancyDuration', Value=0.11 } },
            [12] = { { Stat='GeomancyDuration', Value=0.12 } },
            [13] = { { Stat='GeomancyDuration', Value=0.13 } },
            [14] = { { Stat='GeomancyDuration', Value=0.14 } },
            [15] = { { Stat='GeomancyDuration', Value=0.15 } },
            [16] = { { Stat='GeomancyDuration', Value=0.16 } },
            [17] = { { Stat='GeomancyDuration', Value=0.17 } },
            [18] = { { Stat='GeomancyDuration', Value=0.18 } },
            [19] = { { Stat='GeomancyDuration', Value=0.19 } },
            [20] = { { Stat='GeomancyDuration', Value=0.2 } },
        },
    },

    --Bagua Charm +2
    [25539] = {
        [0] = {
            [1] = { { Stat='GeomancyDuration', Value=0.01 } },
            [2] = { { Stat='GeomancyDuration', Value=0.02 } },
            [3] = { { Stat='GeomancyDuration', Value=0.03 } },
            [4] = { { Stat='GeomancyDuration', Value=0.04 } },
            [5] = { { Stat='GeomancyDuration', Value=0.05 } },
            [6] = { { Stat='GeomancyDuration', Value=0.06 } },
            [7] = { { Stat='GeomancyDuration', Value=0.07 } },
            [8] = { { Stat='GeomancyDuration', Value=0.08 } },
            [9] = { { Stat='GeomancyDuration', Value=0.09 } },
            [10] = { { Stat='GeomancyDuration', Value=0.1 } },
            [11] = { { Stat='GeomancyDuration', Value=0.11 } },
            [12] = { { Stat='GeomancyDuration', Value=0.12 } },
            [13] = { { Stat='GeomancyDuration', Value=0.13 } },
            [14] = { { Stat='GeomancyDuration', Value=0.14 } },
            [15] = { { Stat='GeomancyDuration', Value=0.15 } },
            [16] = { { Stat='GeomancyDuration', Value=0.16 } },
            [17] = { { Stat='GeomancyDuration', Value=0.17 } },
            [18] = { { Stat='GeomancyDuration', Value=0.18 } },
            [19] = { { Stat='GeomancyDuration', Value=0.19 } },
            [20] = { { Stat='GeomancyDuration', Value=0.2 } },
            [21] = { { Stat='GeomancyDuration', Value=0.21 } },
            [22] = { { Stat='GeomancyDuration', Value=0.22 } },
            [23] = { { Stat='GeomancyDuration', Value=0.23 } },
            [24] = { { Stat='GeomancyDuration', Value=0.24 } },
            [25] = { { Stat='GeomancyDuration', Value=0.25 } },
        },
    },
};

local mhRankItems = {
    --Comm. Knife
    [21579] = {
        [2] = {
            [1] = { { Stat='PhantomRoll', Value=1 } },
            [2] = { { Stat='PhantomRoll', Value=3 } },
            [3] = { { Stat='PhantomRoll', Value=5 } },
            [4] = { { Stat='PhantomRoll', Value=7 } },
            [5] = { { Stat='PhantomRoll', Value=9 } },
            [6] = { { Stat='PhantomRoll', Value=11 } },
            [7] = { { Stat='PhantomRoll', Value=13 } },
            [8] = { { Stat='PhantomRoll', Value=15 } },
            [9] = { { Stat='PhantomRoll', Value=17 } },
            [10] = { { Stat='PhantomRoll', Value=19 } },
            [11] = { { Stat='PhantomRoll', Value=21 } },
            [12] = { { Stat='PhantomRoll', Value=23 } },
            [13] = { { Stat='PhantomRoll', Value=25 } },
            [14] = { { Stat='PhantomRoll', Value=27 } },
            [15] = { { Stat='PhantomRoll', Value=30 } },
        },
    },

    --Lanun Knife
    [21580] = {
        [2] = {
            [1] = { { Stat='PhantomRoll', Value=1 } },
            [2] = { { Stat='PhantomRoll', Value=3 } },
            [3] = { { Stat='PhantomRoll', Value=5 } },
            [4] = { { Stat='PhantomRoll', Value=7 } },
            [5] = { { Stat='PhantomRoll', Value=9 } },
            [6] = { { Stat='PhantomRoll', Value=11 } },
            [7] = { { Stat='PhantomRoll', Value=13 } },
            [8] = { { Stat='PhantomRoll', Value=15 } },
            [9] = { { Stat='PhantomRoll', Value=17 } },
            [10] = { { Stat='PhantomRoll', Value=19 } },
            [11] = { { Stat='PhantomRoll', Value=21 } },
            [12] = { { Stat='PhantomRoll', Value=23 } },
            [13] = { { Stat='PhantomRoll', Value=25 } },
            [14] = { { Stat='PhantomRoll', Value=27 } },
            [15] = { { Stat='PhantomRoll', Value=30 } },
            [16] = { { Stat='PhantomRoll', Value=33 } },
            [17] = { { Stat='PhantomRoll', Value=36 } },
            [18] = { { Stat='PhantomRoll', Value=39 } },
            [19] = { { Stat='PhantomRoll', Value=42 } },
            [20] = { { Stat='PhantomRoll', Value=45 } },
        },
    },

    --Rostam
    [21581] = {
        [2] = {
            [1] = { { Stat='PhantomRoll', Value=1 } },
            [2] = { { Stat='PhantomRoll', Value=3 } },
            [3] = { { Stat='PhantomRoll', Value=5 } },
            [4] = { { Stat='PhantomRoll', Value=7 } },
            [5] = { { Stat='PhantomRoll', Value=9 } },
            [6] = { { Stat='PhantomRoll', Value=11 } },
            [7] = { { Stat='PhantomRoll', Value=13 } },
            [8] = { { Stat='PhantomRoll', Value=15 } },
            [9] = { { Stat='PhantomRoll', Value=17 } },
            [10] = { { Stat='PhantomRoll', Value=19 } },
            [11] = { { Stat='PhantomRoll', Value=21 } },
            [12] = { { Stat='PhantomRoll', Value=23 } },
            [13] = { { Stat='PhantomRoll', Value=25 } },
            [14] = { { Stat='PhantomRoll', Value=27 } },
            [15] = { { Stat='PhantomRoll', Value=30 } },
            [16] = { { Stat='PhantomRoll', Value=33 } },
            [17] = { { Stat='PhantomRoll', Value=36 } },
            [18] = { { Stat='PhantomRoll', Value=39 } },
            [19] = { { Stat='PhantomRoll', Value=42 } },
            [20] = { { Stat='PhantomRoll', Value=45 } },
            [21] = { { Stat='PhantomRoll', Value=48 } },
            [22] = { { Stat='PhantomRoll', Value=51 } },
            [23] = { { Stat='PhantomRoll', Value=53 } },
            [24] = { { Stat='PhantomRoll', Value=57 } },
            [25] = { { Stat='PhantomRoll', Value=60 } },
        },
    },

    --Etoile Knife
    [21582] = {
        [2] = {
            [1] = { { Stat='StepDuration', Value=1 } },
            [2] = { { Stat='StepDuration', Value=3 } },
            [3] = { { Stat='StepDuration', Value=5 } },
            [4] = { { Stat='StepDuration', Value=7 } },
            [5] = { { Stat='StepDuration', Value=9 } },
            [6] = { { Stat='StepDuration', Value=11 } },
            [7] = { { Stat='StepDuration', Value=13 } },
            [8] = { { Stat='StepDuration', Value=15 } },
            [9] = { { Stat='StepDuration', Value=17 } },
            [10] = { { Stat='StepDuration', Value=19 } },
            [11] = { { Stat='StepDuration', Value=21 } },
            [12] = { { Stat='StepDuration', Value=23 } },
            [13] = { { Stat='StepDuration', Value=25 } },
            [14] = { { Stat='StepDuration', Value=27 } },
            [15] = { { Stat='StepDuration', Value=30 } },
        },
    },
    
    --Horos Knife
    [21583] = {
        [2] = {
            [1] = { { Stat='StepDuration', Value=1 } },
            [2] = { { Stat='StepDuration', Value=3 } },
            [3] = { { Stat='StepDuration', Value=5 } },
            [4] = { { Stat='StepDuration', Value=7 } },
            [5] = { { Stat='StepDuration', Value=9 } },
            [6] = { { Stat='StepDuration', Value=11 } },
            [7] = { { Stat='StepDuration', Value=13 } },
            [8] = { { Stat='StepDuration', Value=15 } },
            [9] = { { Stat='StepDuration', Value=17 } },
            [10] = { { Stat='StepDuration', Value=19 } },
            [11] = { { Stat='StepDuration', Value=21 } },
            [12] = { { Stat='StepDuration', Value=23 } },
            [13] = { { Stat='StepDuration', Value=25 } },
            [14] = { { Stat='StepDuration', Value=27 } },
            [15] = { { Stat='StepDuration', Value=30 } },
            [16] = { { Stat='StepDuration', Value=33 } },
            [17] = { { Stat='StepDuration', Value=36 } },
            [18] = { { Stat='StepDuration', Value=39 } },
            [19] = { { Stat='StepDuration', Value=42 } },
            [20] = { { Stat='StepDuration', Value=45 } },
        },
    },
    
    --Setan Kober
    [21584] = {
        [2] = {
            [1] = { { Stat='StepDuration', Value=1 } },
            [2] = { { Stat='StepDuration', Value=3 } },
            [3] = { { Stat='StepDuration', Value=5 } },
            [4] = { { Stat='StepDuration', Value=7 } },
            [5] = { { Stat='StepDuration', Value=9 } },
            [6] = { { Stat='StepDuration', Value=11 } },
            [7] = { { Stat='StepDuration', Value=13 } },
            [8] = { { Stat='StepDuration', Value=15 } },
            [9] = { { Stat='StepDuration', Value=17 } },
            [10] = { { Stat='StepDuration', Value=19 } },
            [11] = { { Stat='StepDuration', Value=21 } },
            [12] = { { Stat='StepDuration', Value=23 } },
            [13] = { { Stat='StepDuration', Value=25 } },
            [14] = { { Stat='StepDuration', Value=27 } },
            [15] = { { Stat='StepDuration', Value=30 } },
            [16] = { { Stat='StepDuration', Value=33 } },
            [17] = { { Stat='StepDuration', Value=36 } },
            [18] = { { Stat='StepDuration', Value=39 } },
            [19] = { { Stat='StepDuration', Value=42 } },
            [20] = { { Stat='StepDuration', Value=45 } },
            [21] = { { Stat='StepDuration', Value=48 } },
            [22] = { { Stat='StepDuration', Value=51 } },
            [23] = { { Stat='StepDuration', Value=53 } },
            [24] = { { Stat='StepDuration', Value=57 } },
            [25] = { { Stat='StepDuration', Value=60 } },
        },
    },
};

local generalAugments = {
    [0x4E0] = function(buffer, value)
        if buffer.EnhancingDuration == nil then buffer.EnhancingDuration = 0; end
        buffer.EnhancingDuration = buffer.EnhancingDuration + ((value + 1) / 100);
    end,
    [0x4E1] = function(buffer, value)
        if buffer.HelixDuration == nil then buffer.HelixDuration = 0; end
        buffer.HelixDuration = buffer.HelixDuration + ((value + 1) / 100);
    end,
    [0x4E2] = function(buffer, value)
        if buffer.IndiDuration == nil then buffer.IndiDuration = 0; end
        buffer.IndiDuration = buffer.IndiDuration + ((value + 1) / 100);
    end,
    [0x4E3] = function(buffer, value)
        if buffer.EnfeeblingDuration == nil then buffer.EnfeeblingDuration = 0; end
        buffer.EnfeeblingDuration = buffer.EnfeeblingDuration + ((value + 1) / 100);
    end,
};


local function AddRankAugments(buffer, augData, item)
    local itemTable = item.Extra:totable();
    local path = ashita.bits.unpack_be(itemTable, 32, 2);
    local pathValues = augData[path];
    if pathValues then
        local rank = ashita.bits.unpack_be(itemTable, 50, 5);
        local rankValue = pathValues[rank];
        if rankValue then
            for _,augment in ipairs(rankValue) do
                if (buffer[augment.Stat] == nil) then buffer[augment.Stat] = 0; end
                buffer[augment.Stat] = buffer[augment.Stat] + augment.Value;
            end
        end
    end
end

local function ApplyRankAugments(buffer, item)
    local augData = rankItems[item.Id];
    if augData then
        AddRankAugments(buffer, augData, item);
    end
    
    if (item.Slot == 0) then
        augData = mhRankItems[item.Id];
        if augData then
            AddRankAugments(buffer, augData, item);
        end
    end
end

local function ApplyVariableAugments(buffer, item)
    local augFlag = struct.unpack('B', item.Extra, 2);
    local maxAugments = 5;
    if (augFlag % 128) >= 64 then --Magian
        maxAugments = 4;
    end
    for i = 1,maxAugments,1 do
        local augmentBytes = struct.unpack('H', item.Extra, 1 + (2 * i));
        local augmentId = augmentBytes % 0x800;
        local augmentValue = (augmentBytes - augmentId) / 0x800;
        local augFunc = generalAugments[augmentId];
        if augFunc then
            augFunc(buffer, augmentValue);
        elseif buffer.Generic[augmentId] == nil then
            buffer.Generic[augmentId] = { augmentValue };
        else
            local augTable = buffer.Generic[augmentId];
            augTable[#augTable + 1] = augmentValue;
        end
    end
end

local augments = {};

function augments:Parse(playerLevel, equipSet)
    local result = {};
    result.Generic = {};
    
    for slot,equipPiece in pairs(equipSet) do
        --Skip augments on anything we're wearing under a lower level sync
        if equipPiece ~= nil and (playerLevel >= equipPiece.Resource.Level) and equipPiece.Extra ~= nil then
            local extData = equipPiece.Extra;
            local augType = struct.unpack('B', extData, 1);
            if (augType == 2) or (augType == 3) then
                local augFlag = struct.unpack('B', extData, 2);
                if (augFlag % 64) >= 32 then
                    --Delve (no duration effecting augments exist afaik?)
                elseif (augFlag == 131) then
                    ApplyRankAugments(result, equipPiece);
                elseif (augFlag % 16) >= 8 then
                    --Shield
                elseif (augFlag % 256) >= 128 then
                    --Evolith
                else
                    ApplyVariableAugments(result, equipPiece);
                end
            end
        end
    end

    return result;
end

return augments;
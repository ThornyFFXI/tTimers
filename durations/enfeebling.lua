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

local enfeeblingDuration = {
    [25827] = 0.20, --Regal Cuffs
    [26109] = 0.10, --Snotra Earring
    [26188] = 0.10, --Kishar Ring
    [26363] = 0.05 --Obstin. Sash
};
local saboteurModifiers = {
    [11208] = 0.05, --Estq. Ganthrt. +1
    [11108] = 0.10, --Estq. Ganthrt. +2
    [27060] = 0.11, --Leth. Gantherots
    [27061] = 0.12, --Leth. Gantherots +1
    [23223] = 0.13, --Leth. Ganth. +2
    [23558] = 0.14, --Leth. Ganth. +3
};

local rdmEmpyrean = T{ 11068, 11088, 11108, 11128, 11148, 23089, 23156, 23223, 23290, 23357, 23424, 23491, 23558, 23625, 23692, 26748, 26749, 26906, 26907, 27060, 27061, 27245, 27246, 27419, 27420 };
do
    local buffer = {};
    for _,id in ipairs(rdmEmpyrean) do
        buffer[id] = 1;
    end
    rdmEmpyrean = buffer;
end

local function ApplyEnfeeblingAdditions(duration, augments)
    local job = dataTracker:GetJobData();
    if job.Main ~= 5 then
        return duration;
    end

    if job.MainLevel >= 75 then
        local merits = dataTracker:GetMeritCount(0x90C);
        if merits > 0 then
            local multiplier = 6;
            if (augments.Generic[0x548]) then
                multiplier = 9;
            end
            duration = duration + (merits * multiplier);
        end
    end

    if job.MainLevel == 99 then
        --General enfeebling duration job points
        local jobPoints = dataTracker:GetJobPointCount(5, 7);
        duration = duration + jobPoints;

        --Stymie
        if dataTracker:GetBuffActive(494) then
            jobPoints = dataTracker:GetJobPointCount(5, 1);
            duration = duration + jobPoints;
        end
    end

    return duration;
end

local function ApplyEnfeeblingMultipliers(duration, augments)
    local enfeeblingGear = 1.0 + dataTracker:EquipSum(enfeeblingDuration);
    local enfeeblingAugments = 1.0 + (augments.EnfeeblingDuration or 0);
    return duration * enfeeblingGear * enfeeblingAugments;
end

local function ApplySaboteurMultipliers(duration, targetId)
    if not dataTracker:GetBuffActive(454) then
        return duration;
    end

    local saboteur = 2.0;
    if dataTracker:IsNotoriousMonster(targetId) then
        saboteur = 1.25;
    end

    saboteur = saboteur + dataTracker:EquipSum(saboteurModifiers);
    return duration * saboteur;
end

local composureValues = T{ [0]=1, [1]=1, [2]=1.1, [3]=1.2, [4]=1.35, [5]=1.5 };
local function GetComposureMod()
    local equipCount = dataTracker:EquipSum(rdmEmpyrean);
    return composureValues[equipCount];
end

local function ApplyComposureModifiers(duration, targetId)
	--Not verified whether durations over 1800 sec are truncated the same way as buffs.. can any debuff even reach 30 min?
    if not dataTracker:GetBuffActive(419) or (duration >= 1800) then
        return duration;
    end
	
	return duration * GetComposureMod();
end

local function CalculateEnfeeblingDuration(base, targetId)
    local duration = base;
    local augments = dataTracker:ParseAugments();
    duration = ApplySaboteurMultipliers(duration, targetId);
    duration = ApplyEnfeeblingAdditions(duration, augments);
    duration = ApplyEnfeeblingMultipliers(duration, augments);
	duration = ApplyComposureModifiers(duration);
    return duration;
end

local function CalculateHelixDuration(base)
    local job = dataTracker:GetJobData();
    local duration = 30;

    local schLevel = 0;
    if job.Main == 20 then
        schLevel = job.MainLevel;
    else
        schLevel = job.SubLevel;
    end
    
    if schLevel > 59 then
        duration = 90;
    elseif schLevel > 39 then
        duration = 60;
    end
    
    --Dark Arts
    if dataTracker:GetBuffActive(359) or dataTracker:GetBuffActive(402) then
        --No idea here... various suggestions online.  Using rough estimation, accurate at 99.
        if schLevel > 25 then
            local seconds = math.floor(78 * (schLevel / 99));
            if dataTracker:GetBuffActive(377) then
                seconds = seconds * 2;
            end
            duration = duration + seconds;
        end

        if schLevel == 99 then
            duration = duration + (3 * dataTracker:GetJobPointCount(20, 3));
        end
    end

    
    local augments = dataTracker:ParseAugments();
    duration = duration + (augments.HelixDuration or 0);
    
    return duration;
end

local function Initialize(tracker, buffer)
    dataTracker = tracker;
    
	--Dia
	buffer[23] = function(targetId)
		return CalculateEnfeeblingDuration(60, targetId), 134;
	end

	--Dia II
	buffer[24] = function(targetId)
		return CalculateEnfeeblingDuration(120, targetId), 134;
	end

	--Dia III
	buffer[25] = function(targetId)
		return CalculateEnfeeblingDuration(180, targetId), 134;
	end

	--Diaga
	buffer[33] = function(targetId)
		return CalculateEnfeeblingDuration(60, targetId), 134;
	end

	--Slow
	buffer[56] = function(targetId)
		return CalculateEnfeeblingDuration(180, targetId), 13;
	end

	--Paralyze
	buffer[58] = function(targetId)
		return CalculateEnfeeblingDuration(120, targetId), 4;
	end

	--Silence
	buffer[59] = function(targetId)
		return CalculateEnfeeblingDuration(120, targetId), 6;
	end

	--Slow II
	buffer[79] = function(targetId)
		return CalculateEnfeeblingDuration(180, targetId), 13;
	end

	--Paralyze II
	buffer[80] = function(targetId)
		return CalculateEnfeeblingDuration(120, targetId), 4;
	end

	--Repose
	buffer[98] = function(targetId)
        --TODO: Verify.
		return 90, 2;
	end

	--Gravity
	buffer[216] = function(targetId)
		return CalculateEnfeeblingDuration(120, targetId), 12;
	end

	--Gravity II
	buffer[217] = function(targetId)
		return CalculateEnfeeblingDuration(120, targetId), 12;
	end

	--Poison
	buffer[220] = function(targetId)
		return CalculateEnfeeblingDuration(90, targetId), 3;
	end

	--Poison II
	buffer[221] = function(targetId)
		return CalculateEnfeeblingDuration(120, targetId), 3;
	end

	--Poisonga
	buffer[225] = function(targetId)
		return CalculateEnfeeblingDuration(30, targetId), 3;
	end

	--Bio
	buffer[230] = function(targetId)
		return 60, 135;
	end

	--Bio II
	buffer[231] = function(targetId)
		return 120, 135;
	end

	--Bio III
	buffer[232] = function(targetId)
		return 180, 135;
	end

	--Burn
	buffer[235] = function(targetId)
		return 90, 128;
	end

	--Frost
	buffer[236] = function(targetId)
		return 90, 129;
	end

	--Choke
	buffer[237] = function(targetId)
		return 90, 130;
	end

	--Rasp
	buffer[238] = function(targetId)
		return 90, 131;
	end

	--Shock
	buffer[239] = function(targetId)
		return 90, 132;
	end

	--Drown
	buffer[240] = function(targetId)
		return 90, 133;
	end

	--Sleep
	buffer[253] = function(targetId)
		return CalculateEnfeeblingDuration(60, targetId), 2;
	end

	--Blind
	buffer[254] = function(targetId)
		return CalculateEnfeeblingDuration(180, targetId), 5;
	end

	--Break
	buffer[255] = function(targetId)
		return CalculateEnfeeblingDuration(30, targetId), 7;
	end

	--[[UNKNOWN
    --Bind
	buffer[258] = function(targetId)
		return CalculateEnfeeblingDuration(40, targetId);
	end
    ]]--

	--Sleep II
	buffer[259] = function(targetId)
		return CalculateEnfeeblingDuration(90, targetId), 2;
	end

	--Sleepga
	buffer[273] = function(targetId)
		return CalculateEnfeeblingDuration(60, targetId), 2;
	end

	--Sleepga II
	buffer[274] = function(targetId)
		return CalculateEnfeeblingDuration(90, targetId), 2;
	end
    
	--Blind II
	buffer[276] = function(targetId)
		return CalculateEnfeeblingDuration(180, targetId), 5;
	end    

    --UNKNOWN
	--Addle
	buffer[286] = function(targetId)
    -- Stubbed with base duration
		return CalculateEnfeeblingDuration(180, targetId), 21;
	end

	--Geohelix
	buffer[278] = function(targetId)
		return CalculateHelixDuration(), 186;
	end

	--Hydrohelix
	buffer[279] = function(targetId)
		return CalculateHelixDuration(), 186;
	end

	--Anemohelix
	buffer[280] = function(targetId)
		return CalculateHelixDuration(), 186;
	end

	--Pyrohelix
	buffer[281] = function(targetId)
		return CalculateHelixDuration(), 186;
	end

	--Cryohelix
	buffer[282] = function(targetId)
		return CalculateHelixDuration(), 186;
	end

	--Ionohelix
	buffer[283] = function(targetId)
		return CalculateHelixDuration(), 186;
	end

	--Noctohelix
	buffer[284] = function(targetId)
		return CalculateHelixDuration(), 186;
	end

	--Luminohelix
	buffer[285] = function(targetId)
		return CalculateHelixDuration(), 186;
	end

	--Sleepga
	buffer[363] = function(targetId)
		return CalculateEnfeeblingDuration(60, targetId), 2;
	end

	--Sleepga II
	buffer[364] = function(targetId)
		return CalculateEnfeeblingDuration(90, targetId), 2;
	end

	--Breakga
	buffer[365] = function(targetId)
		return CalculateEnfeeblingDuration(30, targetId), 7;
	end
    
	--Kaustra
	buffer[502] = function(targetId)
        local darkSkill = AshitaCore:GetMemoryManager():GetPlayer():GetCombatSkill(37):GetSkill();
        local ticks = 1 + math.floor(darkSkill / 11);
		return ticks * 3, 23;
	end

	--Impact
	buffer[503] = function(targetId)
		return 180, { 136, 137, 138, 139, 140, 141, 142 };
	end

	--Distract
	buffer[841] = function(targetId)
		return CalculateEnfeeblingDuration(300, targetId), 148;
	end

	--Distract II
	buffer[842] = function(targetId)
		return CalculateEnfeeblingDuration(300, targetId), 148;
	end

	--Frazzle
	buffer[843] = function(targetId)
		return CalculateEnfeeblingDuration(300, targetId), 404;
	end

	--Frazzle II
	buffer[844] = function(targetId)
		return CalculateEnfeeblingDuration(300, targetId), 404;
	end

    --[[UNKNOWN
	--Addle II
	buffer[884] = function(targetId)
		return 0;
	end
    ]]--    

	--Inundation
	buffer[879] = function(targetId)
		return CalculateEnfeeblingDuration(300, targetId), 597;
	end

    --Distract III
	buffer[882] = function(targetId)
		return CalculateEnfeeblingDuration(300, targetId), 148;
	end

	--Frazzle III
	buffer[883] = function(targetId)
		return CalculateEnfeeblingDuration(300, targetId), 404;
	end

	--Geohelix II
	buffer[885] = function(targetId)
		return CalculateHelixDuration(), 186;
	end

	--Hydrohelix II
	buffer[886] = function(targetId)
		return CalculateHelixDuration(), 186;
	end

	--Anemohelix II
	buffer[887] = function(targetId)
		return CalculateHelixDuration(), 186;
	end

	--Pyrohelix II
	buffer[888] = function(targetId)
		return CalculateHelixDuration(), 186;
	end

	--Cryohelix II
	buffer[889] = function(targetId)
		return CalculateHelixDuration(), 186;
	end

	--Ionohelix II
	buffer[890] = function(targetId)
		return CalculateHelixDuration(), 186;
	end

	--Noctohelix II
	buffer[891] = function(targetId)
		return CalculateHelixDuration(), 186;
	end

	--Luminohelix II
	buffer[892] = function(targetId)
		return CalculateHelixDuration(), 186;
	end
end

return Initialize;

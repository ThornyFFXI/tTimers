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

local function ApplyEnfeeblingAdditions(duration, augments)
    local job = dataTracker:GetJobData();
    if job.MainJob ~= 5 then
        return duration;
    end

    if job.MainJobLevel >= 75 then
        local merits = dataTracker:GetMeritCount(0x90C);
        if merits > 0 then
            local multiplier = 6;
            if (augments.Generic[0x548]) then
                multiplier = 9;
            end
            duration = duration + (merits * multiplier);
        end
    end

    if job.MainJobLevel == 99 then
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

local function CalculateEnfeeblingDuration(base, targetId)
    local duration = base;
    local augments = dataTracker:ParseAugments();
    duration = ApplySaboteurMultipliers(duration, targetId);
    duration = ApplyEnfeeblingAdditions(duration, augments);
    duration = ApplyEnfeeblingMultipliers(duration, augments);
    return duration;
end

local function CalculateHelixDuration(base)
    local job = dataTracker:GetJobData();
    local duration = 30;

    local schLevel = 0;
    if job.MainJob == 20 then
        schLevel = job.MainJobLevel;
    else
        schLevel = job.SubJobLevel;
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
		return CalculateEnfeeblingDuration(60, targetId);
	end

	--Dia II
	buffer[24] = function(targetId)
		return CalculateEnfeeblingDuration(120, targetId);
	end

	--Dia III
	buffer[25] = function(targetId)
		return CalculateEnfeeblingDuration(180, targetId);
	end

	--Diaga
	buffer[33] = function(targetId)
		return CalculateEnfeeblingDuration(60, targetId);
	end

	--Slow
	buffer[56] = function(targetId)
		return CalculateEnfeeblingDuration(180, targetId);
	end

	--Paralyze
	buffer[58] = function(targetId)
		return CalculateEnfeeblingDuration(120, targetId);
	end

	--Silence
	buffer[59] = function(targetId)
		return CalculateEnfeeblingDuration(120, targetId);
	end

	--Slow II
	buffer[79] = function(targetId)
		return CalculateEnfeeblingDuration(180, targetId);
	end

	--Paralyze II
	buffer[80] = function(targetId)
		return CalculateEnfeeblingDuration(120, targetId);
	end

	--Repose
	buffer[98] = function(targetId)
		return 90;
	end

	--Gravity
	buffer[216] = function(targetId)
		return CalculateEnfeeblingDuration(120, targetId);
	end

	--Gravity II
	buffer[217] = function(targetId)
		return CalculateEnfeeblingDuration(120, targetId);
	end

	--Poison
	buffer[220] = function(targetId)
		return CalculateEnfeeblingDuration(90, targetId);
	end

	--Poison II
	buffer[221] = function(targetId)
		return CalculateEnfeeblingDuration(120, targetId);
	end

	--Poisonga
	buffer[225] = function(targetId)
		return CalculateEnfeeblingDuration(30, targetId);
	end

	--Bio
	buffer[230] = function(targetId)
		return 60;
	end

	--Bio II
	buffer[231] = function(targetId)
		return 120;
	end

	--Bio III
	buffer[232] = function(targetId)
		return 180;
	end

	--Burn
	buffer[235] = function(targetId)
		return 90;
	end

	--Frost
	buffer[236] = function(targetId)
		return 90;
	end

	--Choke
	buffer[237] = function(targetId)
		return 90;
	end

	--Rasp
	buffer[238] = function(targetId)
		return 90;
	end

	--Shock
	buffer[239] = function(targetId)
		return 90;
	end

	--Drown
	buffer[240] = function(targetId)
		return 90;
	end
	--Sleep
	buffer[253] = function(targetId)
		return CalculateEnfeeblingDuration(60, targetId);
	end

	--Blind
	buffer[254] = function(targetId)
		return CalculateEnfeeblingDuration(180, targetId);
	end

	--Break
	buffer[255] = function(targetId)
		return CalculateEnfeeblingDuration(30, targetId);
	end

	--[[UNKNOWN
    --Bind
	buffer[258] = function(targetId)
		return CalculateEnfeeblingDuration(40, targetId);
	end
    ]]--

	--Sleep II
	buffer[259] = function(targetId)
		return CalculateEnfeeblingDuration(90, targetId);
	end

	--Sleepga
	buffer[273] = function(targetId)
		return CalculateEnfeeblingDuration(60, targetId);
	end

	--Sleepga II
	buffer[274] = function(targetId)
		return CalculateEnfeeblingDuration(90, targetId);
	end
    
	--Blind II
	buffer[276] = function(targetId)
		return CalculateEnfeeblingDuration(180, targetId);
	end    

    --UNKNOWN
	--Addle
	buffer[286] = function(targetId)
    -- Stubbed with base duration
		return CalculateEnfeeblingDuration(180, targetId);
	end

	--Geohelix
	buffer[278] = function(targetId)
		return CalculateHelixDuration();
	end

	--Hydrohelix
	buffer[279] = function(targetId)
		return CalculateHelixDuration();
	end

	--Anemohelix
	buffer[280] = function(targetId)
		return CalculateHelixDuration();
	end

	--Pyrohelix
	buffer[281] = function(targetId)
		return CalculateHelixDuration();
	end

	--Cryohelix
	buffer[282] = function(targetId)
		return CalculateHelixDuration();
	end

	--Ionohelix
	buffer[283] = function(targetId)
		return CalculateHelixDuration();
	end

	--Noctohelix
	buffer[284] = function(targetId)
		return CalculateHelixDuration();
	end

	--Luminohelix
	buffer[285] = function(targetId)
		return CalculateHelixDuration();
	end

	--Sleepga
	buffer[363] = function(targetId)
		return CalculateEnfeeblingDuration(60, targetId);
	end

	--Sleepga II
	buffer[364] = function(targetId)
		return CalculateEnfeeblingDuration(90, targetId);
	end

	--Breakga
	buffer[365] = function(targetId)
		return CalculateEnfeeblingDuration(30, targetId);
	end
    
	--Kaustra
	buffer[502] = function(targetId)
        local ticks = 1 + math.floor(dataTracker:GetCombatSkill(37) / 11);
		return ticks * 3;
	end

	--Impact
	buffer[503] = function(targetId)
		return 180;
	end

	--Distract
	buffer[841] = function(targetId)
		return CalculateEnfeeblingDuration(300, targetId);
	end

	--Distract II
	buffer[842] = function(targetId)
		return CalculateEnfeeblingDuration(300, targetId);
	end

	--Frazzle
	buffer[843] = function(targetId)
		return CalculateEnfeeblingDuration(300, targetId);
	end

	--Frazzle II
	buffer[844] = function(targetId)
		return CalculateEnfeeblingDuration(300, targetId);
	end

    --[[UNKNOWN
	--Addle II
	buffer[884] = function(targetId)
		return 0;
	end
    ]]--    

	--Inundation
	buffer[879] = function(targetId)
		return CalculateEnfeeblingDuration(300, targetId);
	end

    --Distract III
	buffer[882] = function(targetId)
		return CalculateEnfeeblingDuration(300, targetId);
	end

	--Frazzle III
	buffer[883] = function(targetId)
		return CalculateEnfeeblingDuration(300, targetId);
	end

	--Geohelix II
	buffer[885] = function(targetId)
		return CalculateHelixDuration();
	end

	--Hydrohelix II
	buffer[886] = function(targetId)
		return CalculateHelixDuration();
	end

	--Anemohelix II
	buffer[887] = function(targetId)
		return CalculateHelixDuration();
	end

	--Pyrohelix II
	buffer[888] = function(targetId)
		return CalculateHelixDuration();
	end

	--Cryohelix II
	buffer[889] = function(targetId)
		return CalculateHelixDuration();
	end

	--Ionohelix II
	buffer[890] = function(targetId)
		return CalculateHelixDuration();
	end

	--Noctohelix II
	buffer[891] = function(targetId)
		return CalculateHelixDuration();
	end

	--Luminohelix II
	buffer[892] = function(targetId)
		return CalculateHelixDuration();
	end
end

return Initialize;

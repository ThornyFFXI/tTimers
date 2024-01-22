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

local function Initialize(tracker, buffer)
    dataTracker = tracker;

    --Wasp Sting
	buffer[16] = function(targetId)
		local tp = dataTracker:GetWeaponskillCost();
        if (tp < 2000) then
            return 90 + ((tp - 1000) * .015);
        else
            return 105 + ((tp - 2000) * .02);
        end
	end

	--Viper Bite
	buffer[17] = function(targetId)
		local tp = dataTracker:GetWeaponskillCost();
        if (tp < 2000) then
            return 90 + ((tp - 1000) * .03);
        else
            return 120 + ((tp - 2000) * .06);
        end
	end

	--Mordant Rime
	buffer[28] = function(targetId)
		return 60;
	end

	--Pyrrhic Kleos
	buffer[29] = function(targetId)
		local tp = dataTracker:GetWeaponskillCost();
        if (tp < 2000) then
            return 90 + ((tp - 1000) * .03);
        else
            return 120 + ((tp - 2000) * .06);
        end
	end
    
	--Rudra's Storm
	buffer[31] = function(targetId)
		return 60;
	end

	--Death Blossom
	buffer[44] = function(targetId)
		return 60;
	end

	--Shockwave
	buffer[52] = function(targetId)        
		local tp = dataTracker:GetWeaponskillCost();
        if (tp < 2000) then
            return 60 + ((tp - 1000) * .06);
        else
            return 120 + ((tp - 2000) * .24);
        end
	end

	--Herculean Slash
	buffer[58] = function(targetId)
		local tp = dataTracker:GetWeaponskillCost();
        if (tp < 2000) then
            return 60 + ((tp - 1000) * .06);
        else
            return 120 + ((tp - 2000) * .06);
        end
	end

	--Shield Break
	buffer[80] = function(targetId)
		local tp = dataTracker:GetWeaponskillCost();
        if (tp < 2000) then
            return 180 + ((tp - 1000) * .06);
        else
            return 240 + ((tp - 2000) * .06);
        end
	end

	--Armor Break
	buffer[83] = function(targetId)
		local tp = dataTracker:GetWeaponskillCost();
        if (tp < 2000) then
            return 180 + ((tp - 1000) * .18);
        else
            return 360 + ((tp - 2000) * .18);
        end
	end

	--Weapon Break
	buffer[85] = function(targetId)
		local tp = dataTracker:GetWeaponskillCost();
        if (tp < 2000) then
            return 180 + ((tp - 1000) * .06);
        else
            return 240 + ((tp - 2000) * .06);
        end
	end

	--Full Break
	buffer[87] = function(targetId)
		local tp = dataTracker:GetWeaponskillCost();
        if (tp < 2000) then
            return 180 + ((tp - 1000) * .18);
        else
            return 360 + ((tp - 2000) * .36);
        end
	end

	--Metatron Torment
	buffer[89] = function(targetId)
		return 120;
	end

	--Nightmare Scythe
	buffer[99] = function(targetId)
		local tp = dataTracker:GetWeaponskillCost();
        if (tp < 2000) then
            return 60 + ((tp - 1000) * .06);
        else
            return 120 + ((tp - 2000) * .06);
        end
	end

	--Guillotine
	buffer[102] = function(targetId)
		local tp = dataTracker:GetWeaponskillCost();
        if (tp < 2000) then
            return 60 + ((tp - 1000) * .03);
        else
            return 90 + ((tp - 2000) * .03);
        end
	end

	--Infernal Scythe
	buffer[107] = function(targetId)
		local tp = dataTracker:GetWeaponskillCost();
        if (tp < 2000) then
            return 180 + ((tp - 1000) * .18);
        else
            return 360 + ((tp - 2000) * .18);
        end
	end

	--Stardiver
	buffer[125] = function(targetId)
		return 60;
	end

	--Blade: Retsu
	buffer[129] = function(targetId)
		local tp = dataTracker:GetWeaponskillCost();
        if (tp < 2000) then
            return 30 + ((tp - 1000) * .03);
        else
            return 60 + ((tp - 2000) * .06);
        end
	end

	--Blade: Kamu
	buffer[138] = function(targetId)
		local tp = dataTracker:GetWeaponskillCost();
        if (tp < 2000) then
            return 60 + ((tp - 1000) * .06);
        else
            return 120 + ((tp - 2000) * .06);
        end
	end

	--Blade: Yu
	buffer[139] = function(targetId)
		local tp = dataTracker:GetWeaponskillCost();
        if (tp < 2000) then
            return 90 + ((tp - 1000) * .09);
        else
            return 180 + ((tp - 2000) * .09);
        end
	end

    --Tachi: Yukikaze
	buffer[150] = function(targetId)
		return 60;
	end

	--Tachi: Gekko
	buffer[151] = function(targetId)
		return 45;
	end

	--Tachi: Kasha
	buffer[152] = function(targetId)
		return 60;
	end

	--Tachi: Ageha
	buffer[155] = function(targetId)
		return 180;
	end

	--Skullbreaker
	buffer[165] = function(targetId)
		return 140;
	end

	--Shell Crusher
	buffer[181] = function(targetId)
		local tp = dataTracker:GetWeaponskillCost();
        if (tp < 2000) then
            return 180 + ((tp - 1000) * .18);
        else
            return 360 + ((tp - 2000) * .18);
        end
	end

	--Vidohunir
	buffer[186] = function(targetId)
		return 60;
	end

	--Garland of Bliss
	buffer[187] = function(targetId)
		local tp = dataTracker:GetWeaponskillCost();
        if (tp < 2000) then
            return 60 + ((tp - 1000) * .06);
        else
            return 120 + ((tp - 2000) * .06);
        end
	end

	--Shattersoul
	buffer[191] = function(targetId)
		return 120;
	end

	--Numbing Shot
	buffer[219] = function(targetId)
		local tp = dataTracker:GetWeaponskillCost();
        if (tp < 2000) then
            return 60 + ((tp - 1000) * .06);
        else
            return 120 + ((tp - 2000) * .06);
        end
	end

	--Exenterator
	buffer[224] = function(targetId)
		local tp = dataTracker:GetWeaponskillCost();
        if (tp < 2000) then
            return 90 + ((tp - 1000) * .045);
        else
            return 135 + ((tp - 2000) * .045);
        end
	end
end

return Initialize;
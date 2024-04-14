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


--BLU can only wear a small subset of these but I copied the full tables for simplicity's sake, maybe eventually BLU sub will get high enough.
local regenDuration = {
    [28092] = 18, --Theo. Pantaloons
    [28113] = 18, --Theo. Pant. +1
    [23243] = 21, --Th. Pantaloons +2
    [23578] = 24, --Th. Pant. +3
    [11206] = 10, --Orison Mitts +1
    [11106] = 18, --Orison Mitts +2
    [27056] = 20, --Ebers Mitts
    [27057] = 22, --Ebers Mitts +1
    [27787] = 20, --Runeist Bandeau
    [27706] = 21, --Rune. Bandeau +1
    [23062] = 24, --Rune. Bandeau +2
    [23397] = 27, --Rune. Bandeau +3
    [26894] = 12, --Telchine Chas.
    [26265] = 15, --Lugh's Cape
    [21175] = 12 --Coeus
};

local refreshReceived = {
    [26323] = 20, --Gishdubar Sash
    [27464] = 15, --Inspirited Boots
    [28316] = 15, --Shabti Sabatons
    [28317] = 21, --Shab. Sabatons +1
    [11575] = 30 --Grapevine Cape
};

local function ApplyDiffusion(duration)
    if (dataTracker:GetBuffActive(356)) then
        local augments = dataTracker:ParseAugments();
        local merits = dataTracker:GetMeritCount(0x0BC2);
        local multiplier = 1 + ((merits - 1) * 0.05);
        if (augments.Generic[0x58D]) then --Mirage Charuqs variants
            multiplier = multiplier + (merits * 0.05);
        end
        duration = duration * multiplier;
    end
    return duration;
end

local function CalculateBlueMagicDuration(duration, diffusion, unbridled)
    if (diffusion) then
        duration = ApplyDiffusion(duration);
    end
    if unbridled and dataTracker:GetJobData().Main == 16 and dataTracker:GetJobData().MainLevel == 99 then
        duration = duration * (1 + (dataTracker:GetJobPointCount(16, 7) / 100));
    end
    return duration;
end

local function Initialize(tracker, buffer)
    dataTracker = tracker;

    --Metallic Body
    buffer[517] = function(targetId)
        return CalculateBlueMagicDuration(300, true, false), 37;
    end

     --Refueling
    buffer[530] = function(targetId)
        return CalculateBlueMagicDuration(300, true, false), 33;
    end

     --Memento Mori
    buffer[538] = function(targetId)
        return CalculateBlueMagicDuration(60, true, false), 190;
    end

     --Cocoon
    buffer[547] = function(targetId)
        return CalculateBlueMagicDuration(90, true, false), 93;
    end

     --Feather Barrier
    buffer[574] = function(targetId)
        return CalculateBlueMagicDuration(30, true, false), 92;
    end

     --Reactor Cool
    buffer[613] = function(targetId)
        return CalculateBlueMagicDuration(180, true, false), 35;
    end

     --Saline Coat
    buffer[614] = function(targetId)
        return CalculateBlueMagicDuration(180, true, false), 191;
    end

     --Plasma Charge
    buffer[615] = function(targetId)
        return CalculateBlueMagicDuration(600, true, false), 38; --Seems to be random between 10 and 15 minutes?
    end

     --Diamondhide
    buffer[632] = function(targetId)
        return CalculateBlueMagicDuration(900, false, false), 37;
    end

     --Warm-Up
    buffer[636] = function(targetId)
        return CalculateBlueMagicDuration(180, true, false), 90;
    end

     --Amplification
    buffer[642] = function(targetId)
        return CalculateBlueMagicDuration(90, true, false), 190;
    end

     --Zephyr Mantle
    buffer[647] = function(targetId)
        return CalculateBlueMagicDuration(300, true, false), 36;
    end

     --Triumphant Roar
    buffer[655] = function(targetId)
        return CalculateBlueMagicDuration(60, true, false), 91;
    end

     --Plenilune Embrace
    buffer[658] = function(targetId)
        return CalculateBlueMagicDuration(90, false, false), 91;
    end

     --Animating Wail
    buffer[661] = function(targetId)
        return CalculateBlueMagicDuration(300, true, false), 33;
    end

     --Battery Charge
    buffer[662] = function(targetId)
        local duration = 300;
        if dataTracker:GetPlayerId() == targetId then
            duration = duration + dataTracker:EquipSum(refreshReceived);
        end
        return CalculateBlueMagicDuration(duration, true, false), 43;
    end

     --Regeneration
    buffer[664] = function(targetId)
        local duration = 90 + dataTracker:EquipSum(regenDuration);
        return CalculateBlueMagicDuration(duration, true, false), 42;
    end

     --Magic Barrier
    buffer[668] = function(targetId)
        return CalculateBlueMagicDuration(300, true, false), 152;
    end

     --Fantod
    buffer[674] = function(targetId)
        return CalculateBlueMagicDuration(180, true, false), 45;
    end

     --Occultation
    buffer[679] = function(targetId)
        return CalculateBlueMagicDuration(300, true, false), 36;
    end

     --Barrier Tusk
    buffer[685] = function(targetId)
        return CalculateBlueMagicDuration(180, true, false), 116;
    end

     --O. Counterstance
    buffer[696] = function(targetId)
        return CalculateBlueMagicDuration(180, true, false), 486;        
    end

     --Nat. Meditation
    buffer[700] = function(targetId)
        return CalculateBlueMagicDuration(180, true, false), 91;
    end

     --Erratic Flutter
    buffer[710] = function(targetId)
        return CalculateBlueMagicDuration(300, true, false), 33;
    end

     --Harden Shell
    buffer[737] = function(targetId)
        return CalculateBlueMagicDuration(180, true, true), 93;
    end

     --Pyric Bulwark
    buffer[741] = function(targetId)
        return CalculateBlueMagicDuration(300, true, true), 150;
    end

     --Carcharian Verve
    buffer[745] = function(targetId)
        return CalculateBlueMagicDuration(60, true, true), 91; --This also has a 15 minute aquaveil, assuming that is less important than the attack bonus..?
    end

     --Mighty Guard
    buffer[750] = function(targetId)
        return CalculateBlueMagicDuration(180, true, true), 604;        
    end

    --[[DEBUFFS : Many are not clear on land or not from packet, others lack data.  Filled in the ones wiki knew.
    Left this commented by default.

    --Venom Shell
	buffer[513] = function(targetId)
		return 0;
	end

	--Maelstrom
	buffer[515] = function(targetId)
		return 0;
	end

	--Sandspin
	buffer[524] = function(targetId)
		return 0;
	end

	--Ice Break
	buffer[531] = function(targetId)
		return 0;
	end

	--Blitzstrahl
	buffer[532] = function(targetId)
		return 0;
	end

	--Mysterious Light
	buffer[534] = function(targetId)
		return 0;
	end

	--Cold Wave
	buffer[535] = function(targetId)
		return 0;
	end

	--Poison Breath
	buffer[536] = function(targetId)
		return 30;
	end

	--Stinking Gas
	buffer[537] = function(targetId)
		return 60;
	end

	--Terror Touch
	buffer[539] = function(targetId)
		return 60;
	end

	--Filamented Hold
	buffer[548] = function(targetId)
		return 90;
	end

	--Magnetite Cloud
	buffer[555] = function(targetId)
		return 0;
	end

	--Frightful Roar
	buffer[561] = function(targetId)
		return 180;
	end

	--Hecatomb Wave
	buffer[563] = function(targetId)
		return 0;
	end

	--Radiant Breath
	buffer[565] = function(targetId)
		return 90;
	end

	--Sound Blast
	buffer[572] = function(targetId)
		return 30;
	end

	--Feather Tickle
	buffer[573] = function(targetId)
		return 0;
	end

	--Jettatura
	buffer[575] = function(targetId)
		return 0;
	end

	--Yawn
	buffer[576] = function(targetId)
		return 0;
	end

	--Chaotic Eye
	buffer[582] = function(targetId)
		return 0;
	end

	--Sheep Song
	buffer[584] = function(targetId)
		return 0;
	end

	--Lowing
	buffer[588] = function(targetId)
		return 0;
	end

	--Pinecone Bomb
	buffer[596] = function(targetId)
		return 0;
	end

	--Sprout Smack
	buffer[597] = function(targetId)
		return 0;
	end

	--Soporific
	buffer[598] = function(targetId)
		return 90;
	end

	--Queasyshroom
	buffer[599] = function(targetId)
		return 0;
	end

	--Wild Oats
	buffer[603] = function(targetId)
		return 0;
	end

	--Bad Breath
	buffer[604] = function(targetId)
		return 0;
	end

	--Awful Eye
	buffer[606] = function(targetId)
		return 30;
	end

	--Frost Breath
	buffer[608] = function(targetId)
		return 180;
	end

	--Infrasonics
	buffer[610] = function(targetId)
		return 60;
	end

	--Disseverment
	buffer[611] = function(targetId)
		return 180;
	end

	--Actinic Burst
	buffer[612] = function(targetId)
		return 0;
	end

	--Temporal Shift
	buffer[616] = function(targetId)
		return 0;
	end

	--Blastbomb
	buffer[618] = function(targetId)
		return 0;
	end

	--Battle Dance
	buffer[620] = function(targetId)
		return 0;
	end

	--Sandspray
	buffer[621] = function(targetId)
		return 0;
	end

	--Head Butt
	buffer[623] = function(targetId)
		return 0;
	end

	--Frypan
	buffer[628] = function(targetId)
		return 0;
	end

	--Hydro Shot
	buffer[631] = function(targetId)
		return 0;
	end

	--Enervation
	buffer[633] = function(targetId)
		return 30;
	end

	--Light of Penance
	buffer[634] = function(targetId)
		return 30;
	end

	--Feather Storm
	buffer[638] = function(targetId)
		return 0;
	end

	--Tail Slap
	buffer[640] = function(targetId)
		return 0;
	end

	--Mind Blast
	buffer[644] = function(targetId)
		return 90;
	end

	--Regurgitation
	buffer[648] = function(targetId)
		return 0;
	end

	--Seedspray
	buffer[650] = function(targetId)
		return 0;
	end

	--Corrosive Ooze
	buffer[651] = function(targetId)
		return 0;
	end

	--Spiral Spin
	buffer[652] = function(targetId)
		return 0;
	end

	--Sub-zero Smash
	buffer[654] = function(targetId)
		return 180;
	end

	--Acrid Stream
	buffer[656] = function(targetId)
		return 120;
	end

	--Demoralizing Roar
	buffer[659] = function(targetId)
		return 30;
	end

	--Cimicine Discharge
	buffer[660] = function(targetId)
		return 90;
	end

	--Whirl of Rage
	buffer[669] = function(targetId)
		return 0;
	end

	--Benthic Typhoon
	buffer[670] = function(targetId)
		return 60;
	end

	--Auroral Drape
	buffer[671] = function(targetId)
		return 0;
	end

	--Thermal Pulse
	buffer[675] = function(targetId)
		return 0;
	end
    
	--Dream Flower
	buffer[678] = function(targetId)
		return 0;
	end

	--Delta Thrust
	buffer[682] = function(targetId)
		return 0;
	end

	--Mortal Ray
	buffer[686] = function(targetId)
		return 63;
	end

	--Water Bomb
	buffer[687] = function(targetId)
		return 0;
	end

	--Sudden Lunge
	buffer[692] = function(targetId)
		return 0;
	end

	--Barbed Crescent
	buffer[699] = function(targetId)
		return 120;
	end

	--Embalming Earth
	buffer[703] = function(targetId)
		return 180;
	end

	--Paralyzing Triad
	buffer[704] = function(targetId)
		return 60;
	end

	--Foul Waters
	buffer[705] = function(targetId)
		return 180;
	end

	--Retinal Glare
	buffer[707] = function(targetId)
		return 15;
	end

	--Subduction
	buffer[708] = function(targetId)
		return 90;
	end

	--Nectarous Deluge
	buffer[716] = function(targetId)
		return 0;
	end

	--Sweeping Gouge
	buffer[717] = function(targetId)
		return 90;
	end

	--Searing Tempest
	buffer[719] = function(targetId)
		return 0;
	end

	--Spectral Floe
	buffer[720] = function(targetId)
		return 0;
	end

	--Anvil Lightning
	buffer[721] = function(targetId)
		return 0;
	end

	--Entomb
	buffer[722] = function(targetId)
		return 0;
	end

	--Saurian Slide
	buffer[723] = function(targetId)
		return 0;
	end

	--Palling Salvo
	buffer[724] = function(targetId)
		return 0;
	end

	--Blinding Fulgor
	buffer[725] = function(targetId)
		return 0;
	end

	--Scouring Spate
	buffer[726] = function(targetId)
		return 0;
	end

	--Silent Storm
	buffer[727] = function(targetId)
		return 0;
	end

	--Tenebral Crush
	buffer[728] = function(targetId)
		return 180;
	end

	--Thunderbolt
	buffer[736] = function(targetId)
		return 0;
	end

	--Absolute Terror
	buffer[738] = function(targetId)
		return 0;
	end

	--Gates of Hades
	buffer[739] = function(targetId)
		return 90;
	end

	--Tourbillion
	buffer[740] = function(targetId)
		return 0;
	end

	--Bilgestorm
	buffer[742] = function(targetId)
		return 0;
	end

	--Bloodrake
	buffer[743] = function(targetId)
		return 0;
	end

	--Blistering Roar
	buffer[746] = function(targetId)
		return 0;
	end

	--Polar Roar
	buffer[749] = function(targetId)
		return 0;
	end

	--Cruel Joke
	buffer[751] = function(targetId)
		return 60;
	end

	--Cesspool
	buffer[752] = function(targetId)
		return 60;
	end

	--Tearing Gust
	buffer[753] = function(targetId)
		return 60;
	end
    ]]--
end

return Initialize;
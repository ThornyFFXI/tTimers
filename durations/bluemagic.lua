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
        local augments = gData.ParseAugments();
        local merits = gData.GetMeritCount(0x0BC2);
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

local function FillSpellTable(spellTable)
    --Metallic Body
    spellTable[517] = function(targetId)
        return CalculateBlueMagicDuration(300, true, false);
    end

     --Refueling
    spellTable[530] = function(targetId)
        return CalculateBlueMagicDuration(300, true, false);
    end

     --Memento Mori
    spellTable[538] = function(targetId)
        return CalculateBlueMagicDuration(60, true, false);
    end

     --Cocoon
    spellTable[547] = function(targetId)
        return CalculateBlueMagicDuration(90, true, false);
    end

     --Feather Barrier
    spellTable[574] = function(targetId)
        return CalculateBlueMagicDuration(30, true, false);
    end

     --Reactor Cool
    spellTable[613] = function(targetId)
        return CalculateBlueMagicDuration(180, true, false);
    end

     --Saline Coat
    spellTable[614] = function(targetId)
        return CalculateBlueMagicDuration(180, true, false);
    end

     --Plasma Charge
    spellTable[615] = function(targetId)
        return CalculateBlueMagicDuration(600, true, false); --Seems to be random between 10 and 15 minutes?
    end

     --Diamondhide
    spellTable[632] = function(targetId)
        return CalculateBlueMagicDuration(900, false, false);
    end

     --Warm-Up
    spellTable[636] = function(targetId)
        return CalculateBlueMagicDuration(180, true, false);
    end

     --Amplification
    spellTable[642] = function(targetId)
        return CalculateBlueMagicDuration(90, true, false);
    end

     --Zephyr Mantle
    spellTable[647] = function(targetId)
        return CalculateBlueMagicDuration(300, true, false);
    end

     --Triumphant Roar
    spellTable[655] = function(targetId)
        return CalculateBlueMagicDuration(60, true, false);
    end

     --Plenilune Embrace
    spellTable[658] = function(targetId)
        return CalculateBlueMagicDuration(90, false, false);
    end

     --Animating Wail
    spellTable[661] = function(targetId)
        return CalculateBlueMagicDuration(300, true, false);
    end

     --Battery Charge
    spellTable[662] = function(targetId)
        local duration = 300;
        if gData.GetPlayerId() == targetId then
            duration = duration + gData.EquipSum(refreshReceived);
        end
        return CalculateBlueMagicDuration(duration, true, false);
    end

     --Regeneration
    spellTable[664] = function(targetId)
        local duration = 180 + gData.EquipSum(regenDuration);
        return CalculateBlueMagicDuration(duration, true, false);        
    end

     --Magic Barrier
    spellTable[668] = function(targetId)
        return CalculateBlueMagicDuration(300, true, false);
    end

     --Fantod
    spellTable[674] = function(targetId)
        return CalculateBlueMagicDuration(180, true, false);
    end

     --Occultation
    spellTable[679] = function(targetId)
        return CalculateBlueMagicDuration(300, true, false);        
    end

     --Barrier Tusk
    spellTable[685] = function(targetId)
        return CalculateBlueMagicDuration(180, true, false);
    end

     --O. Counterstance
    spellTable[696] = function(targetId)
        return CalculateBlueMagicDuration(180, true, false);        
    end

     --Nat. Meditation
    spellTable[700] = function(targetId)
        return CalculateBlueMagicDuration(180, true, false);
    end

     --Erratic Flutter
    spellTable[710] = function(targetId)
        return CalculateBlueMagicDuration(300, true, false);        
    end

     --Harden Shell
    spellTable[737] = function(targetId)
        return CalculateBlueMagicDuration(180, true, true);
    end

     --Pyric Bulwark
    spellTable[741] = function(targetId)
        return CalculateBlueMagicDuration(300, true, true);
    end

     --Carcharian Verve
    spellTable[745] = function(targetId)
        return CalculateBlueMagicDuration(60, true, true); --This also has a 15 minute aquaveil, assuming that is less important than the attack bonus..?
    end

     --Mighty Guard
    spellTable[750] = function(targetId)
        return CalculateBlueMagicDuration(180, true, true);        
    end

    --[[DEBUFFS : Many are not clear on land or not from packet, others lack data.  Filled in the ones wiki knew.
    Left this commented by default.

    --Venom Shell
	spellTable[513] = function(targetId)
		return 0;
	end

	--Maelstrom
	spellTable[515] = function(targetId)
		return 0;
	end

	--Sandspin
	spellTable[524] = function(targetId)
		return 0;
	end

	--Ice Break
	spellTable[531] = function(targetId)
		return 0;
	end

	--Blitzstrahl
	spellTable[532] = function(targetId)
		return 0;
	end

	--Mysterious Light
	spellTable[534] = function(targetId)
		return 0;
	end

	--Cold Wave
	spellTable[535] = function(targetId)
		return 0;
	end

	--Poison Breath
	spellTable[536] = function(targetId)
		return 30;
	end

	--Stinking Gas
	spellTable[537] = function(targetId)
		return 60;
	end

	--Terror Touch
	spellTable[539] = function(targetId)
		return 60;
	end

	--Filamented Hold
	spellTable[548] = function(targetId)
		return 90;
	end

	--Magnetite Cloud
	spellTable[555] = function(targetId)
		return 0;
	end

	--Frightful Roar
	spellTable[561] = function(targetId)
		return 180;
	end

	--Hecatomb Wave
	spellTable[563] = function(targetId)
		return 0;
	end

	--Radiant Breath
	spellTable[565] = function(targetId)
		return 90;
	end

	--Sound Blast
	spellTable[572] = function(targetId)
		return 30;
	end

	--Feather Tickle
	spellTable[573] = function(targetId)
		return 0;
	end

	--Jettatura
	spellTable[575] = function(targetId)
		return 0;
	end

	--Yawn
	spellTable[576] = function(targetId)
		return 0;
	end

	--Chaotic Eye
	spellTable[582] = function(targetId)
		return 0;
	end

	--Sheep Song
	spellTable[584] = function(targetId)
		return 0;
	end

	--Lowing
	spellTable[588] = function(targetId)
		return 0;
	end

	--Pinecone Bomb
	spellTable[596] = function(targetId)
		return 0;
	end

	--Sprout Smack
	spellTable[597] = function(targetId)
		return 0;
	end

	--Soporific
	spellTable[598] = function(targetId)
		return 90;
	end

	--Queasyshroom
	spellTable[599] = function(targetId)
		return 0;
	end

	--Wild Oats
	spellTable[603] = function(targetId)
		return 0;
	end

	--Bad Breath
	spellTable[604] = function(targetId)
		return 0;
	end

	--Awful Eye
	spellTable[606] = function(targetId)
		return 30;
	end

	--Frost Breath
	spellTable[608] = function(targetId)
		return 180;
	end

	--Infrasonics
	spellTable[610] = function(targetId)
		return 60;
	end

	--Disseverment
	spellTable[611] = function(targetId)
		return 180;
	end

	--Actinic Burst
	spellTable[612] = function(targetId)
		return 0;
	end

	--Temporal Shift
	spellTable[616] = function(targetId)
		return 0;
	end

	--Blastbomb
	spellTable[618] = function(targetId)
		return 0;
	end

	--Battle Dance
	spellTable[620] = function(targetId)
		return 0;
	end

	--Sandspray
	spellTable[621] = function(targetId)
		return 0;
	end

	--Head Butt
	spellTable[623] = function(targetId)
		return 0;
	end

	--Frypan
	spellTable[628] = function(targetId)
		return 0;
	end

	--Hydro Shot
	spellTable[631] = function(targetId)
		return 0;
	end

	--Enervation
	spellTable[633] = function(targetId)
		return 30;
	end

	--Light of Penance
	spellTable[634] = function(targetId)
		return 30;
	end

	--Feather Storm
	spellTable[638] = function(targetId)
		return 0;
	end

	--Tail Slap
	spellTable[640] = function(targetId)
		return 0;
	end

	--Mind Blast
	spellTable[644] = function(targetId)
		return 90;
	end

	--Regurgitation
	spellTable[648] = function(targetId)
		return 0;
	end

	--Seedspray
	spellTable[650] = function(targetId)
		return 0;
	end

	--Corrosive Ooze
	spellTable[651] = function(targetId)
		return 0;
	end

	--Spiral Spin
	spellTable[652] = function(targetId)
		return 0;
	end

	--Sub-zero Smash
	spellTable[654] = function(targetId)
		return 180;
	end

	--Acrid Stream
	spellTable[656] = function(targetId)
		return 120;
	end

	--Demoralizing Roar
	spellTable[659] = function(targetId)
		return 30;
	end

	--Cimicine Discharge
	spellTable[660] = function(targetId)
		return 90;
	end

	--Whirl of Rage
	spellTable[669] = function(targetId)
		return 0;
	end

	--Benthic Typhoon
	spellTable[670] = function(targetId)
		return 60;
	end

	--Auroral Drape
	spellTable[671] = function(targetId)
		return 0;
	end

	--Thermal Pulse
	spellTable[675] = function(targetId)
		return 0;
	end
    
	--Dream Flower
	spellTable[678] = function(targetId)
		return 0;
	end

	--Delta Thrust
	spellTable[682] = function(targetId)
		return 0;
	end

	--Mortal Ray
	spellTable[686] = function(targetId)
		return 63;
	end

	--Water Bomb
	spellTable[687] = function(targetId)
		return 0;
	end

	--Sudden Lunge
	spellTable[692] = function(targetId)
		return 0;
	end

	--Barbed Crescent
	spellTable[699] = function(targetId)
		return 120;
	end

	--Embalming Earth
	spellTable[703] = function(targetId)
		return 180;
	end

	--Paralyzing Triad
	spellTable[704] = function(targetId)
		return 60;
	end

	--Foul Waters
	spellTable[705] = function(targetId)
		return 180;
	end

	--Retinal Glare
	spellTable[707] = function(targetId)
		return 15;
	end

	--Subduction
	spellTable[708] = function(targetId)
		return 90;
	end

	--Nectarous Deluge
	spellTable[716] = function(targetId)
		return 0;
	end

	--Sweeping Gouge
	spellTable[717] = function(targetId)
		return 90;
	end

	--Searing Tempest
	spellTable[719] = function(targetId)
		return 0;
	end

	--Spectral Floe
	spellTable[720] = function(targetId)
		return 0;
	end

	--Anvil Lightning
	spellTable[721] = function(targetId)
		return 0;
	end

	--Entomb
	spellTable[722] = function(targetId)
		return 0;
	end

	--Saurian Slide
	spellTable[723] = function(targetId)
		return 0;
	end

	--Palling Salvo
	spellTable[724] = function(targetId)
		return 0;
	end

	--Blinding Fulgor
	spellTable[725] = function(targetId)
		return 0;
	end

	--Scouring Spate
	spellTable[726] = function(targetId)
		return 0;
	end

	--Silent Storm
	spellTable[727] = function(targetId)
		return 0;
	end

	--Tenebral Crush
	spellTable[728] = function(targetId)
		return 180;
	end

	--Thunderbolt
	spellTable[736] = function(targetId)
		return 0;
	end

	--Absolute Terror
	spellTable[738] = function(targetId)
		return 0;
	end

	--Gates of Hades
	spellTable[739] = function(targetId)
		return 90;
	end

	--Tourbillion
	spellTable[740] = function(targetId)
		return 0;
	end

	--Bilgestorm
	spellTable[742] = function(targetId)
		return 0;
	end

	--Bloodrake
	spellTable[743] = function(targetId)
		return 0;
	end

	--Blistering Roar
	spellTable[746] = function(targetId)
		return 0;
	end

	--Polar Roar
	spellTable[749] = function(targetId)
		return 0;
	end

	--Cruel Joke
	spellTable[751] = function(targetId)
		return 60;
	end

	--Cesspool
	spellTable[752] = function(targetId)
		return 60;
	end

	--Tearing Gust
	spellTable[753] = function(targetId)
		return 60;
	end
    ]]--
end

return FillSpellTable;
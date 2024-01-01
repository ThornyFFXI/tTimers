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

local assaultZones = {
    55, --Ilrusi Atoll
    56, --Periqia
    60, --The Ashu Talif
    63, --Lebros Cavern
    66, --Mamool Ja Training Grounds
    69, --Leujaoam Sanctum
    73, --Zhayolm Remnants
    74, --Arrapago Remnants
    75, --Bhaflau Remnants
    76, --Silver Sea Remnants
    77 --Nyzul Isle
};
local dynamisZones = {
    39, --Dynamis - Valkurm
    40, --Dynamis - Buburimu
    41, --Dynamis - Qufim
    42, --Dynamis - Tavnazia,
    134, --Dynamis - Beaucedine
    135, --Dynamis - Xarcabard
    185, --Dynamis - San d'Oria
    186, --Dynamis - Bastok
    187, --Dynamis - Windurst
    188 --Dynamis - Jeuno
    --[[
    TODO: Verify if millenium horn works in dynamis[D]..
    294, --Dynamis - San d'Oria [D]
    295, --Dynamis - Bastok [D]
    296, --Dynamis - Windurst [D]
    297 --Dynamis - Jeuno [D]
    ]]--
};
local minneEquipment = {
    [17373] = 0.1, --Maple Harp +1
    [17354] = 0.1, --Harp
    [17374] = 0.2, --Harp +1
    [17856] = 0.3, --Syrinx
    [25901] = 0.1, --Mousai Seraweels
    [25902] = 0.2 --Mousai Seraweels +1
};
local minuetEquipment = {
    [17344] = 0.1, --Cornette
    [17369] = 0.2, --Cornette +1
    [17846] = 0.2, --Cornette +2
    [18832] = 0.3, --Apollo's Flute
    [11093] = 0.1, --Aoidos' Hngrln. +2
    [26916] = 0.1, --Fili Hongreline
    [26917] = 0.1 --Fili Hongreline +1
};
local paeonEquipment = {
    [17357] = 0.1, --Ebony Harp
    [17833] = 0.2, --Ebony Harp +1
    [17848] = 0.2, --Ebony Harp +2
    [17358] = 0.3, --Oneiros Harp
    [27672] = 0.1, --Brioso Roundlet
    [27693] = 0.1, --Brioso Roundlet +1
    [23049] = 0.1, --Brioso Roundlet +2
    [23384] = 0.1 --Brioso Roundlet +3
};
local madrigalEquipment = {
    [17348] = 0.1, --Traversiere
    [17375] = 0.2, --Traversiere +1
    [17845] = 0.2, --Traversiere +2
    [18833] = 0.3, --Cantabank's Horn
    [11073] = 0.1, --Aoidos' Calot +1
    [26758] = 0.1, --Fili Calot
    [26759] = 0.1, --Fili Calot +1
    [26255] = 0.1 --Intarabus's Cape
};
local mamboEquipment = {
    [17351] = 0.1, --Gemshorn
    [17370] = 0.2, --Gemshorn +1
    [17849] = 0.1, --Hellish Bugle
    [18950] = 0.2, --Hellish Bugle +1
    [18834] = 0.3, --Vihuela
    [25968] = 0.1, --Mousai Crackows
    [25969] = 0.2 --Mousai Crackows +1
};
local etudeEquipment = {
    [17359] = 0.1, --Mythic Harp
    [17834] = 0.2, --Mythic Harp +1
    [17355] = 0.1, --Rose Harp
    [17376] = 0.2, --Rose Harp +1
    [17360] = 0.3, --Langeleik
    [25561] = 0.1, --Mousai Turban
    [25562] = 0.2 --Mousai Turban +1
};
local balladEquipment = {
    [18831] = 0.1, --Crooner's Cithara
    [11133] = 0.1, --Aoidos' Rhing. +2
    [27255] = 0.1, --Fili Rhingrave
    [27256] = 0.1, --Fili Rhingrave +1
    [21401] = 0.2 --Blurred Harp +1
    --[17851] = 0.1 --Storm Fife (Code later for assault/salvage zones only..)
};
local marchEquipment = {
    [17367] = 0.1, --Ryl.Spr. Horn
    [17835] = 0.1, --San D'Orian Horn
    [17836] = 0.1, --Kingdom Horn
    [17349] = 0.2, --Faerie Piccolo
    [17853] = 0.2, --Iron Ram Horn
    [17360] = 0.3, --Langeleik
    [11113] = 0.1, --Ad. Mnchtte. +2
    [27070] = 0.1, --Fili Manchettes
    [27071] = 0.1 --Fili Manchettes +1
};
local preludeEquipment = {
    [17350] = 0.1, --Angel's Flute
    [17378] = 0.2, --Angel's Flute +1
    [18833] = 0.3, --Cantabank's Horn
    [26255] = 0.1 --Intarabus's Cape
};
local mazurkaEquipment = {
    [17838] = 0.2, --Harlequin's Horn
    [18834] = 0.3 --Vihuela
};
local carolEquipment = {
    [17361] = 0.1, --Crumhorn
    [17377] = 0.2, --Crumhorn +1
    [17847] = 0.2, --Crumhorn +2
    [21399] = 0.2, --Nibiru Harp
    [25988] = 0.1, --Mousai Gages
    [25989] = 0.2 --Mousai Gages +1
};
local hymnusEquipment = {
    [17840] = 0.2, --Angel Lyre
    [17363] = 0.3 --Mass Chalemie
};
local scherzoEquipment = {
    [17363] = 0.1, --Mass Chalemie
    [11153] = 0.1, --Aoidos' Cothrn. +2
    [27429] = 0.1, --Fili Cothurnes
    [27430] = 0.1 --Fili Cothurnes +1
};
local requiemEquipment = {
    [17372] = 0.1, --Flute +1
    [17844] = 0.1, --Flute +2
    [17346] = 0.2, --Siren Flute
    [17379] = 0.2, --Hamelin Flute
    [17362] = 0.2, --Shofar
    [17832] = 0.3, --Shofar +1
    [17852] = 0.4  --Requiem Flute
};
local lullabyEquipment = {
    [17366] = 0.1, --Mary's Horn
    [17841] = 0.2, --Nursemaid's Harp
    [17854] = 0.2, --Cradle Horn
    [18343] = 0.3, --Pan's Horn
    [21400] = 0.2, --Blurred Harp
    [21401] = 0.2, --Blurred Harp +1
    [21402] = 0.2, --Damani Horn
    [21403] = 0.3, --Damani Horn +1
    [27952] = 0.1, --Brioso Cuffs
    [27973] = 0.1, --Brioso Cuffs +1
    [23183] = 0.1, --Brioso Cuffs +2
    [23518] = 0.2  --Brioso Cuffs +3
};
local elegyEquipment = {
    [17352] = 0.1, --Horn
    [17371] = 0.2, --Horn +1
    [17856] = 0.3  --Syrinx
};
local threnodyEquipment = {
    [17347] = 0.1, --Piccolo
    [17368] = 0.2, --Piccolo +1
    [17842] = 0.3, --Sorrowful Harp
    [26537] = 0.1, --Mousai Manteel
    [26538] = 0.2  --Mou. Manteel +1
};
local virelaiEquipment = {
    [17364] = 0.1, --Cythara Anglica
    [17837] = 0.2  --Cyt. Anglica +1
}
local allSongsEquipment = {
    --Weapons
    [19000] = 0.10, --Carnwenhan(75)
    [19069] = 0.25, --Carnwenhan(80)
    [19089] = 0.30, --Carnwenhan(85)
    [19621] = 0.40, --Carnwenhan(90)
    [19719] = 0.40, --Carnwenhan(95)
    [19828] = 0.50, --Carnwenhan(99)
    [19957] = 0.50, --Carnwenhan(99, Afterglow)
    [20561] = 0.50, --Carnwenhan(119)
    [20562] = 0.50, --Carnwenhan(119, Afterglow)
    [20586] = 0.50, --Carnwenhan(119+)
    [20629] = 0.05, --Legato Dagger
    [20599] = 0.10, --Kali

    --Horns
    --[21409] = 0.20 --Forefront Flute, reive only
    --[21406] = 0.40 --Homestead Flute, reive only
    [21404] = 0.10, --Linos
    [21405] = 0.20, --Eminent Flute
    [18342] = 0.20, --Gjallarhorn(75)
    [18577] = 0.20, --Gjallarhorn(80)
    [18578] = 0.20, --Gjallarhorn(85)
    [18579] = 0.30, --Gjallarhorn(90)
    [18580] = 0.30, --Gjallarhorn(95)
    [18572] = 0.40, --Gjallarhorn(99)
    [18840] = 0.40, --Gjallarhorn(99, Afterglow)
    [21398] = 0.50, --Marsyas

    --Harps
    [21400] = 0.10, --Blurred Harp
    [21401] = 0.20, --Blurred Harp +1
    [18575] = 0.25, --Daurdabla(90)
    [18576] = 0.30, --Daurdabla(95)
    [18571] = 0.30, --Daurdabla(99)
    [18839] = 0.30, --Daurdabla(99, Afterglow)

    [11618] = 0.10, --Aoidos' Matinee
    [26031] = 0.10, --Brioso Whistle
    [26032] = 0.20, --Moonbow Whistle
    [26033] = 0.30, --Mnbw. Whistle +1

    [11193] = 0.05, --Aoidos' Hngrln. +1
    [11093] = 0.10, --Aoidos' Hngrln. +2
    [26916] = 0.11, --Fili Hongreline
    [26917] = 0.12, --Fili Hongreline +1

    [28074] = 0.10, --Mdk. Shalwar +1
    [25865] = 0.12, --Inyanga Shalwar
    [25866] = 0.15, --Inyanga Shalwar +1
    [25882] = 0.17, --Inyanga Shalwar +2

    [28232] = 0.10, --Brioso Slippers
    [28253] = 0.11, --Brioso Slippers +1
    [23317] = 0.13, --Brioso Slippers +2
    [23652] = 0.15, --Brioso Slippers +3
};

local function SongSum()
    local total = 1.0;
    local equipment = gData.GetEquipmentTable();
    for _,equipPiece in pairs(equipment) do
        local value = allSongsEquipment[equipPiece.Id];
        if value ~= nil then
            total = total + value;
        end
    end
    local augments = gData.ParseAugments().Generic[0x043];
    if augments then
        for _,v in pairs(augments) do
            total = total + (v + 1);
        end
    end
    return total;
end

local function AddConditionalInstruments(multiplier)
    local instrument = gData.GetEquipmentTable()[3].Id;
    if (instrument == 18341) then
        local zone = gData.GetZone();
        for _,match in pairs(dynamisZones) do
            if zone == match then
                multiplier = multiplier + 0.2;
            end
        end
    elseif (instrument == 21406) then
        if (gData.GetBuffActive(511)) then
            multiplier = multiplier + 0.4;
        end
    elseif (instrument == 21409) then
        if (gData.GetBuffActive(511)) then
            multiplier = multiplier + 0.2;
        end
    end
    return multiplier;
end

local function CalculateBuffSongDuration(multiplier, targetId)
    multiplier = AddConditionalInstruments(multiplier);
    if (gData.GetMainJob() == 10) and (gData.GetMainJobLevel() == 99) then
        local total = gData.GetJobPointTotal(10);
        if (gData.GetJobPointTotal(10) >= 1200) then
            multiplier = multiplier + 0.05;
        end
    end
    local duration = 120 * multiplier;

    if (gData.GetBuffActive(348)) then
        duration = duration * 2;
    end

    if (gData.GetMainJob() == 10) and (gData.GetMainJobLevel() == 99) then
        if (gData.GetBuffActive(455)) then
            duration = duration + (2 * gData.GetJobPoints(10, 6));
        end
        if (gData.GetBuffActive(499)) then
            duration = duration + (2 * gData.GetJobPoints(10, 1));
        end
        if (gData.GetBuffActive(231)) then
            duration = duration + gData.GetJobPoints(10, 8);
        end
    end

    return duration;    
end

local function CalculateMinneDuration(targetId)
    return CalculateBuffSongDuration(SongSum() + gData.EquipSum(minneEquipment), targetId);
end

local function CalculateMinuetDuration(targetId)
    return CalculateBuffSongDuration(SongSum() + gData.EquipSum(minuetEquipment), targetId);
end

local function CalculatePaeonDuration(targetId)
    return CalculateBuffSongDuration(SongSum() + gData.EquipSum(paeonEquipment), targetId);
end

local function CalculateMadrigalDuration(targetId)
    return CalculateBuffSongDuration(SongSum() + gData.EquipSum(madrigalEquipment), targetId);
end

local function CalculateMamboDuration(targetId)
    return CalculateBuffSongDuration(SongSum() + gData.EquipSum(mamboEquipment), targetId);
end

local function CalculateEtudeDuration(targetId)
    return CalculateBuffSongDuration(SongSum() + gData.EquipSum(etudeEquipment), targetId);
end

local function CalculateBalladDuration(targetId)
    local multiplier = SongSum() + gData.EquipSum(balladEquipment);
    if (gData.GetEquipmentTable()[3].Id == 17851) then
        local zone = gData.GetZone();
        for _,match in pairs(assaultZones) do
            if zone == match then
                multiplier = multiplier + 0.1;
            end
        end
    end
    return CalculateBuffSongDuration(multiplier, targetId);
end

local function CalculateMarchDuration(targetId)
    return CalculateBuffSongDuration(SongSum() + gData.EquipSum(marchEquipment), targetId);
end

local function CalculatePreludeDuration(targetId)
    return CalculateBuffSongDuration(SongSum() + gData.EquipSum(preludeEquipment), targetId);
end

local function CalculateMazurkaDuration(targetId)
    return CalculateBuffSongDuration(SongSum() + gData.EquipSum(mazurkaEquipment), targetId);
end

local function CalculateCarolDuration(targetId)
    return CalculateBuffSongDuration(SongSum() + gData.EquipSum(carolEquipment), targetId);
end

local function CalculateHymnusDuration(targetId)
    return CalculateBuffSongDuration(SongSum() + gData.EquipSum(hymnusEquipment), targetId);
end

local function CalculateScherzoDuration(targetId)
    return CalculateBuffSongDuration(SongSum() + gData.EquipSum(scherzoEquipment), targetId);
end

local function CalculateDebuffSongDuration(base, multiplier, lullaby)
    multiplier = AddConditionalInstruments(multiplier);
    if (gData.GetMainJob() == 10) and (gData.GetMainJobLevel() == 99) then
        if (gData.GetJobPointTotal(10) >= 1200) then
            multiplier = multiplier + 0.05;
        end
    end
    
    local duration = base * multiplier;

    if (gData.GetMainJob() == 10) and (gData.GetMainJobLevel() == 99) then
        if lullaby then
            duration = duration + gData.GetJobPoints(10, 7);
        end
        if (gData.GetBuffActive(499)) then
            duration = duration + (2 * gData.GetJobPoints(10, 1));
        end
    end
    
    if (gData.GetBuffActive(348)) then
        duration = duration * 2;
    end
    
    if (gData.GetMainJob() == 10) and (gData.GetMainJobLevel() == 99) then
        if (gData.GetBuffActive(231)) then
            duration = duration + gData.GetJobPoints(10, 8);
        end
    end
    
    return duration;
end

local function CalculateElegyDuration(base)
    return CalculateDebuffSongDuration(base, SongSum() + gData.EquipSum(elegyEquipment), false);
end

local function CalculateLullabyDuration(base)
    return CalculateDebuffSongDuration(base, SongSum() + gData.EquipSum(lullabyEquipment), true);
end

local function CalculateThrenodyDuration(base)
    return CalculateDebuffSongDuration(base, SongSum() + gData.EquipSum(threnodyEquipment), false);
end

local function FillSpellTable(spellTable)
    --[[UNKNOWN
    --Foe Requiem
	spellTable[368] = function(targetId)
		return 0;
	end
    ]]--
    
    --[[UNKNOWN
	--Foe Requiem II
	spellTable[369] = function(targetId)
		return 0;
	end
    ]]--
    
    --[[UNKNOWN
	--Foe Requiem III
	spellTable[370] = function(targetId)
		return 0;
	end
    ]]--

    --[[UNKNOWN
	--Foe Requiem IV
	spellTable[371] = function(targetId)
		return 0;
	end
    ]]--

    --[[UNKNOWN
	--Foe Requiem V
	spellTable[372] = function(targetId)
		return 0;
	end
    ]]--

    --[[UNKNOWN
	--Foe Requiem VI
	spellTable[373] = function(targetId)
		return 0;
	end
    ]]--

    --[[UNKNOWN
	--Foe Requiem VII
	spellTable[374] = function(targetId)
		return 0;
	end
    ]]--

	--Horde Lullaby
	spellTable[376] = function(targetId)
		return CalculateLullabyDuration(30);
	end

	--Horde Lullaby II
	spellTable[377] = function(targetId)
		return CalculateLullabyDuration(60);
	end

    --Army's Paeon
    spellTable[378] = function(targetId)
        return CalculatePaeonDuration(targetId);
    end

     --Army's Paeon II
    spellTable[379] = function(targetId)
        return CalculatePaeonDuration(targetId);
    end

     --Army's Paeon III
    spellTable[380] = function(targetId)
        return CalculatePaeonDuration(targetId);
    end

     --Army's Paeon IV
    spellTable[381] = function(targetId)
        return CalculatePaeonDuration(targetId);
    end

     --Army's Paeon V
    spellTable[382] = function(targetId)
        return CalculatePaeonDuration(targetId);
    end

     --Army's Paeon VI
    spellTable[383] = function(targetId)
        return CalculatePaeonDuration(targetId);
    end

     --Army's Paeon VII
    spellTable[384] = function(targetId)
        return CalculatePaeonDuration(targetId);
    end

     --Army's Paeon VIII
    spellTable[385] = function(targetId)
        return CalculatePaeonDuration(targetId);
    end

     --Mage's Ballad
    spellTable[386] = function(targetId)
        return CalculateBalladDuration(targetId);
    end

     --Mage's Ballad II
    spellTable[387] = function(targetId)
        return CalculateBalladDuration(targetId);
    end

     --Mage's Ballad III
    spellTable[388] = function(targetId)
        return CalculateBalladDuration(targetId);
    end

     --Knight's Minne
    spellTable[389] = function(targetId)
        return CalculateMinneDuration(targetId);
    end

     --Knight's Minne II
    spellTable[390] = function(targetId)
        return CalculateMinneDuration(targetId);
    end

     --Knight's Minne III
    spellTable[391] = function(targetId)
        return CalculateMinneDuration(targetId);
    end

     --Knight's Minne IV
    spellTable[392] = function(targetId)
        return CalculateMinneDuration(targetId);
    end

     --Knight's Minne V
    spellTable[393] = function(targetId)
        return CalculateMinneDuration(targetId);
    end

     --Valor Minuet
    spellTable[394] = function(targetId)
        return CalculateMinuetDuration(targetId);
    end

     --Valor Minuet II
    spellTable[395] = function(targetId)
        return CalculateMinuetDuration(targetId);
    end

     --Valor Minuet III
    spellTable[396] = function(targetId)
        return CalculateMinuetDuration(targetId);
    end

     --Valor Minuet IV
    spellTable[397] = function(targetId)
        return CalculateMinuetDuration(targetId);
    end

     --Valor Minuet V
    spellTable[398] = function(targetId)
        return CalculateMinuetDuration(targetId);
    end

     --Sword Madrigal
    spellTable[399] = function(targetId)
        return CalculateMadrigalDuration(targetId);
    end

     --Blade Madrigal
    spellTable[400] = function(targetId)
        return CalculateMadrigalDuration(targetId);
    end

     --Hunter's Prelude
    spellTable[401] = function(targetId)
        return CalculatePreludeDuration(targetId);
    end

     --Archer's Prelude
    spellTable[402] = function(targetId)
        return CalculatePreludeDuration(targetId);
    end

     --Sheepfoe Mambo
    spellTable[403] = function(targetId)
        return CalculateMamboDuration(targetId);
    end

     --Dragonfoe Mambo
    spellTable[404] = function(targetId)
        return CalculateMamboDuration(targetId);
    end

     --Fowl Aubade
    spellTable[405] = function(targetId)
        return CalculateBuffSongDuration(SongSum(), targetId);
    end

     --Herb Pastoral
    spellTable[406] = function(targetId)
        return CalculateBuffSongDuration(SongSum(), targetId);
    end

     --Chocobo Hum
    spellTable[407] = function(targetId)
        return CalculateBuffSongDuration(SongSum(), targetId);
    end

     --Shining Fantasia
    spellTable[408] = function(targetId)
        return CalculateBuffSongDuration(SongSum(), targetId);
    end

     --Scop's Operetta
    spellTable[409] = function(targetId)
        return CalculateBuffSongDuration(SongSum(), targetId);
    end

     --Puppet's Operetta
    spellTable[410] = function(targetId)
        return CalculateBuffSongDuration(SongSum(), targetId);
    end

     --Jester's Operetta
    spellTable[411] = function(targetId)
        return CalculateBuffSongDuration(SongSum(), targetId);
    end

     --Gold Capriccio
    spellTable[412] = function(targetId)
        return CalculateBuffSongDuration(SongSum(), targetId);
    end

     --Devotee Serenade
    spellTable[413] = function(targetId)
        return CalculateBuffSongDuration(SongSum(), targetId);
    end

     --Warding Round
    spellTable[414] = function(targetId)
        return CalculateBuffSongDuration(SongSum(), targetId);
    end

     --Goblin Gavotte
    spellTable[415] = function(targetId)
        return CalculateBuffSongDuration(SongSum(), targetId);
    end

     --Cactuar Fugue
    spellTable[416] = function(targetId)
        return CalculateBuffSongDuration(SongSum(), targetId);
    end

     --Honor March
    spellTable[417] = function(targetId)
        return CalculateMarchDuration(targetId);
    end

     --Protected Aria
    spellTable[418] = function(targetId)
        return CalculateBuffSongDuration(SongSum(), targetId);
    end

     --Advancing March
    spellTable[419] = function(targetId)
        return CalculateMarchDuration(targetId);
    end

     --Victory March
    spellTable[420] = function(targetId)
        return CalculateMarchDuration(targetId);
    end
    
	--Battlefield Elegy
	spellTable[421] = function(targetId)
		return CalculateElegyDuration(120);
	end

	--Carnage Elegy
	spellTable[422] = function(targetId)
		return CalculateElegyDuration(180);
	end

     --Sinewy Etude
    spellTable[424] = function(targetId)
        return CalculateEtudeDuration(targetId);
    end

     --Dextrous Etude
    spellTable[425] = function(targetId)
        return CalculateEtudeDuration(targetId);
    end

     --Vivacious Etude
    spellTable[426] = function(targetId)
        return CalculateEtudeDuration(targetId);
    end

     --Quick Etude
    spellTable[427] = function(targetId)
        return CalculateEtudeDuration(targetId);
    end

     --Learned Etude
    spellTable[428] = function(targetId)
        return CalculateEtudeDuration(targetId);
    end

     --Spirited Etude
    spellTable[429] = function(targetId)
        return CalculateEtudeDuration(targetId);
    end

     --Enchanting Etude
    spellTable[430] = function(targetId)
        return CalculateEtudeDuration(targetId);
    end

     --Herculean Etude
    spellTable[431] = function(targetId)
        return CalculateEtudeDuration(targetId);
    end

     --Uncanny Etude
    spellTable[432] = function(targetId)
        return CalculateEtudeDuration(targetId);
    end

     --Vital Etude
    spellTable[433] = function(targetId)
        return CalculateEtudeDuration(targetId);
    end

     --Swift Etude
    spellTable[434] = function(targetId)
        return CalculateEtudeDuration(targetId);
    end

     --Sage Etude
    spellTable[435] = function(targetId)
        return CalculateEtudeDuration(targetId);
    end

     --Logical Etude
    spellTable[436] = function(targetId)
        return CalculateEtudeDuration(targetId);
    end

     --Bewitching Etude
    spellTable[437] = function(targetId)
        return CalculateEtudeDuration(targetId);
    end

     --Fire Carol
    spellTable[438] = function(targetId)
        return CalculateCarolDuration(targetId);
    end

     --Ice Carol
    spellTable[439] = function(targetId)
        return CalculateCarolDuration(targetId);
    end

     --Wind Carol
    spellTable[440] = function(targetId)
        return CalculateCarolDuration(targetId);
    end

     --Earth Carol
    spellTable[441] = function(targetId)
        return CalculateCarolDuration(targetId);
    end

     --Lightning Carol
    spellTable[442] = function(targetId)
        return CalculateCarolDuration(targetId);
    end

     --Water Carol
    spellTable[443] = function(targetId)
        return CalculateCarolDuration(targetId);
    end

     --Light Carol
    spellTable[444] = function(targetId)
        return CalculateCarolDuration(targetId);
    end

     --Dark Carol
    spellTable[445] = function(targetId)
        return CalculateCarolDuration(targetId);
    end

     --Fire Carol II
    spellTable[446] = function(targetId)
        return CalculateCarolDuration(targetId);
    end

     --Ice Carol II
    spellTable[447] = function(targetId)
        return CalculateCarolDuration(targetId);
    end

     --Wind Carol II
    spellTable[448] = function(targetId)
        return CalculateCarolDuration(targetId);
    end

     --Earth Carol II
    spellTable[449] = function(targetId)
        return CalculateCarolDuration(targetId);
    end

     --Lightning Carol II
    spellTable[450] = function(targetId)
        return CalculateCarolDuration(targetId);
    end

     --Water Carol II
    spellTable[451] = function(targetId)
        return CalculateCarolDuration(targetId);
    end

     --Light Carol II
    spellTable[452] = function(targetId)
        return CalculateCarolDuration(targetId);
    end

     --Dark Carol II
    spellTable[453] = function(targetId)
        return CalculateCarolDuration(targetId);
    end

	--Fire Threnody
	spellTable[454] = function(targetId)
		return CalculateThrenodyDuration(60);
	end

	--Ice Threnody
	spellTable[455] = function(targetId)
		return CalculateThrenodyDuration(60);
	end

	--Wind Threnody
	spellTable[456] = function(targetId)
		return CalculateThrenodyDuration(60);
	end

	--Earth Threnody
	spellTable[457] = function(targetId)
		return CalculateThrenodyDuration(60);
	end

	--Ltng. Threnody
	spellTable[458] = function(targetId)
		return CalculateThrenodyDuration(60);
	end

	--Water Threnody
	spellTable[459] = function(targetId)
		return CalculateThrenodyDuration(60);
	end

	--Light Threnody
	spellTable[460] = function(targetId)
		return CalculateThrenodyDuration(60);
	end

	--Dark Threnody
	spellTable[461] = function(targetId)
		return CalculateThrenodyDuration(60);
	end

	--Foe Lullaby
	spellTable[463] = function(targetId)
		return CalculateLullabyDuration(30);
	end

     --Goddess's Hymnus
    spellTable[464] = function(targetId)
        return CalculateHymnusDuration(targetId);
    end

     --Chocobo Mazurka
    spellTable[465] = function(targetId)
        return CalculateMazurkaDuration(targetId);
    end

	--Maiden's Virelai
	spellTable[466] = function(targetId)
		return CalculateDebuffSongDuration(30, SongSum(), false);
	end

     --Raptor Mazurka
    spellTable[467] = function(targetId)
        return CalculateMazurkaDuration(targetId);
    end

     --Foe Sirvente
    spellTable[468] = function(targetId)
        return CalculateBuffSongDuration(SongSum(), targetId);
    end

     --Adventurer's Dirge
    spellTable[469] = function(targetId)
        return CalculateBuffSongDuration(SongSum(), targetId);
    end

     --Sentinel's Scherzo
    spellTable[470] = function(targetId)
        return CalculateScherzoDuration(targetId);
    end
    
	--Foe Lullaby II
	spellTable[471] = function(targetId)
		return CalculateLullabyDuration(60);
	end

	--Pining Nocturne
	spellTable[472] = function(targetId)
		return CalculateDebuffSongDuration(120, SongSum(), false);
	end
    
    --Fire Threnody II
	spellTable[871] = function(targetId)
		return CalculateThrenodyDuration(90);
	end

	--Ice Threnody II
	spellTable[872] = function(targetId)
		return CalculateThrenodyDuration(90);
	end

	--Wind Threnody II
	spellTable[873] = function(targetId)
		return CalculateThrenodyDuration(90);
	end

	--Earth Threnody II
	spellTable[874] = function(targetId)
		return CalculateThrenodyDuration(90);
	end

	--Ltng. Threnody II
	spellTable[875] = function(targetId)
		return CalculateThrenodyDuration(90);
	end

	--Water Threnody II
	spellTable[876] = function(targetId)
		return CalculateThrenodyDuration(90);
	end

	--Light Threnody II
	spellTable[877] = function(targetId)
		return CalculateThrenodyDuration(90);
	end

	--Dark Threnody II
	spellTable[878] = function(targetId)
		return CalculateThrenodyDuration(90);
	end
end

return FillSpellTable;
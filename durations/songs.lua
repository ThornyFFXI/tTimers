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

local function GetInstrumentId();
    local equipment = dataTracker:GetEquippedSet();
    for _,entry in ipairs(equipment) do
        if (entry.Slot == 3) then
            return entry.Id;
        end
    end
    return 0;
end

local function SongSum()
    local total = 1.0;
    local equipment = dataTracker:GetEquippedSet();
    for _,equipPiece in pairs(equipment) do
        local value = allSongsEquipment[equipPiece.Id];
        if value ~= nil then
            total = total + value;
        end
    end
    local augments = dataTracker:ParseAugments().Generic[0x043];
    if augments then
        for _,v in pairs(augments) do
            total = total + (v + 1);
        end
    end
    return total;
end

local function AddConditionalInstruments(multiplier)
    local instrument = GetInstrumentId();
    if (instrument == 18341) then
        local zone = AshitaCore:GetMemoryManager():GetParty():GetMemberZone(0);
        for _,match in pairs(dynamisZones) do
            if zone == match then
                multiplier = multiplier + 0.2;
            end
        end
    elseif (instrument == 21406) then
        if (dataTracker:GetBuffActive(511)) then
            multiplier = multiplier + 0.4;
        end
    elseif (instrument == 21409) then
        if (dataTracker:GetBuffActive(511)) then
            multiplier = multiplier + 0.2;
        end
    end
    return multiplier;
end

local function CalculateBuffSongDuration(multiplier, targetId)
    multiplier = AddConditionalInstruments(multiplier);
    if (dataTracker:GetJobData().Main == 10) and (dataTracker:GetJobData().MainLevel == 99) then
        local total = dataTracker:GetJobPointTotal(10);
        if (dataTracker:GetJobPointTotal(10) >= 1200) then
            multiplier = multiplier + 0.05;
        end
    end
    local duration = 120 * multiplier;

    if (dataTracker:GetBuffActive(348)) then
        duration = duration * 2;
    end

    if (dataTracker:GetJobData().Main == 10) and (dataTracker:GetJobData().MainLevel == 99) then
        if (dataTracker:GetBuffActive(455)) then
            duration = duration + (2 * dataTracker:GetJobPointCount(10, 6));
        end
        if (dataTracker:GetBuffActive(499)) then
            duration = duration + (2 * dataTracker:GetJobPointCount(10, 1));
        end
        if (dataTracker:GetBuffActive(231)) then
            duration = duration + dataTracker:GetJobPointCount(10, 8);
        end
    end

    return duration;    
end

local function CalculateMinneDuration(targetId)
    return CalculateBuffSongDuration(SongSum() + dataTracker:EquipSum(minneEquipment), targetId);
end

local function CalculateMinuetDuration(targetId)
    return CalculateBuffSongDuration(SongSum() + dataTracker:EquipSum(minuetEquipment), targetId);
end

local function CalculatePaeonDuration(targetId)
    return CalculateBuffSongDuration(SongSum() + dataTracker:EquipSum(paeonEquipment), targetId);
end

local function CalculateMadrigalDuration(targetId)
    return CalculateBuffSongDuration(SongSum() + dataTracker:EquipSum(madrigalEquipment), targetId);
end

local function CalculateMamboDuration(targetId)
    return CalculateBuffSongDuration(SongSum() + dataTracker:EquipSum(mamboEquipment), targetId);
end

local function CalculateEtudeDuration(targetId)
    return CalculateBuffSongDuration(SongSum() + dataTracker:EquipSum(etudeEquipment), targetId);
end

local function CalculateBalladDuration(targetId)
    local multiplier = SongSum() + dataTracker:EquipSum(balladEquipment);
    if (GetInstrumentId() == 17851) then
        local zone = AshitaCore:GetMemoryManager():GetParty():GetMemberZone(0);
        for _,match in pairs(assaultZones) do
            if zone == match then
                multiplier = multiplier + 0.1;
            end
        end
    end
    return CalculateBuffSongDuration(multiplier, targetId);
end

local function CalculateMarchDuration(targetId)
    return CalculateBuffSongDuration(SongSum() + dataTracker:EquipSum(marchEquipment), targetId);
end

local function CalculatePreludeDuration(targetId)
    return CalculateBuffSongDuration(SongSum() + dataTracker:EquipSum(preludeEquipment), targetId);
end

local function CalculateMazurkaDuration(targetId)
    return CalculateBuffSongDuration(SongSum() + dataTracker:EquipSum(mazurkaEquipment), targetId);
end

local function CalculateCarolDuration(targetId)
    return CalculateBuffSongDuration(SongSum() + dataTracker:EquipSum(carolEquipment), targetId);
end

local function CalculateHymnusDuration(targetId)
    return CalculateBuffSongDuration(SongSum() + dataTracker:EquipSum(hymnusEquipment), targetId);
end

local function CalculateScherzoDuration(targetId)
    return CalculateBuffSongDuration(SongSum() + dataTracker:EquipSum(scherzoEquipment), targetId);
end

local function CalculateDebuffSongDuration(base, multiplier, lullaby)
    multiplier = AddConditionalInstruments(multiplier);
    if (dataTracker:GetJobData().Main == 10) and (dataTracker:GetJobData().MainLevel == 99) then
        if (dataTracker:GetJobPointTotal(10) >= 1200) then
            multiplier = multiplier + 0.05;
        end
    end
    
    local duration = base * multiplier;

    if (dataTracker:GetJobData().Main == 10) and (dataTracker:GetJobData().MainLevel == 99) then
        if lullaby then
            duration = duration + dataTracker:GetJobPointCount(10, 7);
        end
        if (dataTracker:GetBuffActive(499)) then
            duration = duration + (2 * dataTracker:GetJobPointCount(10, 1));
        end
    end
    
    if (dataTracker:GetBuffActive(348)) then
        duration = duration * 2;
    end
    
    if (dataTracker:GetJobData().Main == 10) and (dataTracker:GetJobData().MainLevel == 99) then
        if (dataTracker:GetBuffActive(231)) then
            duration = duration + dataTracker:GetJobPointCount(10, 8);
        end
    end
    
    return duration;
end

local function CalculateElegyDuration(base)
    return CalculateDebuffSongDuration(base, SongSum() + dataTracker:EquipSum(elegyEquipment), false);
end

local function CalculateLullabyDuration(base)
    return CalculateDebuffSongDuration(base, SongSum() + dataTracker:EquipSum(lullabyEquipment), true);
end

local function CalculateRequiemDuration(base)
    return CalculateDebuffSongDuration(base, SongSum() + dataTracker:EquipSum(requiemEquipment), false);
end

local function CalculateThrenodyDuration(base)
    return CalculateDebuffSongDuration(base, SongSum() + dataTracker:EquipSum(threnodyEquipment), false);
end

local function Initialize(tracker, buffer)
    dataTracker = tracker;


    --Requiem base duration is 48 + 16 * tier
    --https://wiki.ffo.jp/html/4264.html

    --Foe Requiem
	buffer[368] = function(targetId)
        return CalculateRequiemDuration(48 + 16), 192;
	end
    
	--Foe Requiem II
	buffer[369] = function(targetId)
        return CalculateRequiemDuration(48 + 16 * 2), 192;
	end
    
	--Foe Requiem III
	buffer[370] = function(targetId)
        return CalculateRequiemDuration(48 + 16 * 3), 192;
	end

	--Foe Requiem IV
	buffer[371] = function(targetId)
        return CalculateRequiemDuration(48 + 16 * 4), 192;
	end

	--Foe Requiem V
	buffer[372] = function(targetId)
        return CalculateRequiemDuration(48 + 16 * 5), 192;
	end

	--Foe Requiem VI
	buffer[373] = function(targetId)
        return CalculateRequiemDuration(48 + 16 * 6), 192;
	end

	--Foe Requiem VII
	buffer[374] = function(targetId)
        return CalculateRequiemDuration(48 + 16 * 7), 192;
	end

	--Horde Lullaby
	buffer[376] = function(targetId)
		return CalculateLullabyDuration(30), 2;
	end

	--Horde Lullaby II
	buffer[377] = function(targetId)
		return CalculateLullabyDuration(60), 2;
	end

    --Army's Paeon
    buffer[378] = function(targetId)
        return CalculatePaeonDuration(targetId), 195;
    end

     --Army's Paeon II
    buffer[379] = function(targetId)
        return CalculatePaeonDuration(targetId), 195;
    end

     --Army's Paeon III
    buffer[380] = function(targetId)
        return CalculatePaeonDuration(targetId), 195;
    end

     --Army's Paeon IV
    buffer[381] = function(targetId)
        return CalculatePaeonDuration(targetId), 195;
    end

     --Army's Paeon V
    buffer[382] = function(targetId)
        return CalculatePaeonDuration(targetId), 195;
    end

     --Army's Paeon VI
    buffer[383] = function(targetId)
        return CalculatePaeonDuration(targetId), 195;
    end

     --Army's Paeon VII
    buffer[384] = function(targetId)
        return CalculatePaeonDuration(targetId), 195;
    end

     --Army's Paeon VIII
    buffer[385] = function(targetId)
        return CalculatePaeonDuration(targetId), 195;
    end

     --Mage's Ballad
    buffer[386] = function(targetId)
        return CalculateBalladDuration(targetId), 196;
    end

     --Mage's Ballad II
    buffer[387] = function(targetId)
        return CalculateBalladDuration(targetId), 196;
    end

     --Mage's Ballad III
    buffer[388] = function(targetId)
        return CalculateBalladDuration(targetId), 196;
    end

     --Knight's Minne
    buffer[389] = function(targetId)
        return CalculateMinneDuration(targetId), 197;
    end

     --Knight's Minne II
    buffer[390] = function(targetId)
        return CalculateMinneDuration(targetId), 197;
    end

     --Knight's Minne III
    buffer[391] = function(targetId)
        return CalculateMinneDuration(targetId), 197;
    end

     --Knight's Minne IV
    buffer[392] = function(targetId)
        return CalculateMinneDuration(targetId), 197;
    end

     --Knight's Minne V
    buffer[393] = function(targetId)
        return CalculateMinneDuration(targetId), 197;
    end

     --Valor Minuet
    buffer[394] = function(targetId)
        return CalculateMinuetDuration(targetId), 198;
    end

     --Valor Minuet II
    buffer[395] = function(targetId)
        return CalculateMinuetDuration(targetId), 198;
    end

     --Valor Minuet III
    buffer[396] = function(targetId)
        return CalculateMinuetDuration(targetId), 198;
    end

     --Valor Minuet IV
    buffer[397] = function(targetId)
        return CalculateMinuetDuration(targetId), 198;
    end

     --Valor Minuet V
    buffer[398] = function(targetId)
        return CalculateMinuetDuration(targetId), 198;
    end

     --Sword Madrigal
    buffer[399] = function(targetId)
        return CalculateMadrigalDuration(targetId), 199;
    end

     --Blade Madrigal
    buffer[400] = function(targetId)
        return CalculateMadrigalDuration(targetId), 199;
    end

     --Hunter's Prelude
    buffer[401] = function(targetId)
        return CalculatePreludeDuration(targetId), 200;
    end

     --Archer's Prelude
    buffer[402] = function(targetId)
        return CalculatePreludeDuration(targetId), 200;
    end

     --Sheepfoe Mambo
    buffer[403] = function(targetId)
        return CalculateMamboDuration(targetId), 201;
    end

     --Dragonfoe Mambo
    buffer[404] = function(targetId)
        return CalculateMamboDuration(targetId), 201;
    end

     --Fowl Aubade
    buffer[405] = function(targetId)
        return CalculateBuffSongDuration(SongSum(), targetId), 202;
    end

     --Herb Pastoral
    buffer[406] = function(targetId)
        return CalculateBuffSongDuration(SongSum(), targetId), 203;
    end

     --Chocobo Hum
    buffer[407] = function(targetId)
        return CalculateBuffSongDuration(SongSum(), targetId), 204;
    end

     --Shining Fantasia
    buffer[408] = function(targetId)
        return CalculateBuffSongDuration(SongSum(), targetId), 205;
    end

     --Scop's Operetta
    buffer[409] = function(targetId)
        return CalculateBuffSongDuration(SongSum(), targetId), 206;
    end

     --Puppet's Operetta
    buffer[410] = function(targetId)
        return CalculateBuffSongDuration(SongSum(), targetId), 206;
    end

     --Jester's Operetta
    buffer[411] = function(targetId)
        return CalculateBuffSongDuration(SongSum(), targetId), 206;
    end

     --Gold Capriccio
    buffer[412] = function(targetId)
        return CalculateBuffSongDuration(SongSum(), targetId), 207;
    end

     --Devotee Serenade
    buffer[413] = function(targetId)
        return CalculateBuffSongDuration(SongSum(), targetId), 208;
    end

     --Warding Round
    buffer[414] = function(targetId)
        return CalculateBuffSongDuration(SongSum(), targetId), 209;
    end

     --Goblin Gavotte
    buffer[415] = function(targetId)
        return CalculateBuffSongDuration(SongSum(), targetId), 210;
    end

     --Cactuar Fugue
    buffer[416] = function(targetId)
        return CalculateBuffSongDuration(SongSum(), targetId), 211;
    end

     --Honor March
    buffer[417] = function(targetId)
        return CalculateMarchDuration(targetId), 214;
    end

     --Protected Aria
    buffer[418] = function(targetId)
        return CalculateBuffSongDuration(SongSum(), targetId), 213;
    end

     --Advancing March
    buffer[419] = function(targetId)
        return CalculateMarchDuration(targetId), 214;
    end

     --Victory March
    buffer[420] = function(targetId)
        return CalculateMarchDuration(targetId), 214;
    end
    
	--Battlefield Elegy
	buffer[421] = function(targetId)
		return CalculateElegyDuration(120), 194;
	end

	--Carnage Elegy
	buffer[422] = function(targetId)
		return CalculateElegyDuration(180), 194;
	end

     --Sinewy Etude
    buffer[424] = function(targetId)
        return CalculateEtudeDuration(targetId), 215;
    end

     --Dextrous Etude
    buffer[425] = function(targetId)
        return CalculateEtudeDuration(targetId), 215;
    end

     --Vivacious Etude
    buffer[426] = function(targetId)
        return CalculateEtudeDuration(targetId), 215;
    end

     --Quick Etude
    buffer[427] = function(targetId)
        return CalculateEtudeDuration(targetId), 215;
    end

     --Learned Etude
    buffer[428] = function(targetId)
        return CalculateEtudeDuration(targetId), 215;
    end

     --Spirited Etude
    buffer[429] = function(targetId)
        return CalculateEtudeDuration(targetId), 215;
    end

     --Enchanting Etude
    buffer[430] = function(targetId)
        return CalculateEtudeDuration(targetId), 215;
    end

     --Herculean Etude
    buffer[431] = function(targetId)
        return CalculateEtudeDuration(targetId), 215;
    end

     --Uncanny Etude
    buffer[432] = function(targetId)
        return CalculateEtudeDuration(targetId), 215;
    end

     --Vital Etude
    buffer[433] = function(targetId)
        return CalculateEtudeDuration(targetId), 215;
    end

     --Swift Etude
    buffer[434] = function(targetId)
        return CalculateEtudeDuration(targetId), 215;
    end

     --Sage Etude
    buffer[435] = function(targetId)
        return CalculateEtudeDuration(targetId), 215;
    end

     --Logical Etude
    buffer[436] = function(targetId)
        return CalculateEtudeDuration(targetId), 215;
    end

     --Bewitching Etude
    buffer[437] = function(targetId)
        return CalculateEtudeDuration(targetId), 215;
    end

     --Fire Carol
    buffer[438] = function(targetId)
        return CalculateCarolDuration(targetId), 216;
    end

     --Ice Carol
    buffer[439] = function(targetId)
        return CalculateCarolDuration(targetId), 216;
    end

     --Wind Carol
    buffer[440] = function(targetId)
        return CalculateCarolDuration(targetId), 216;
    end

     --Earth Carol
    buffer[441] = function(targetId)
        return CalculateCarolDuration(targetId), 216;
    end

     --Lightning Carol
    buffer[442] = function(targetId)
        return CalculateCarolDuration(targetId), 216;
    end

     --Water Carol
    buffer[443] = function(targetId)
        return CalculateCarolDuration(targetId), 216;
    end

     --Light Carol
    buffer[444] = function(targetId)
        return CalculateCarolDuration(targetId), 216;
    end

     --Dark Carol
    buffer[445] = function(targetId)
        return CalculateCarolDuration(targetId), 216;
    end

     --Fire Carol II
    buffer[446] = function(targetId)
        return CalculateCarolDuration(targetId), 216;
    end

     --Ice Carol II
    buffer[447] = function(targetId)
        return CalculateCarolDuration(targetId), 216;
    end

     --Wind Carol II
    buffer[448] = function(targetId)
        return CalculateCarolDuration(targetId), 216;
    end

     --Earth Carol II
    buffer[449] = function(targetId)
        return CalculateCarolDuration(targetId), 216;
    end

     --Lightning Carol II
    buffer[450] = function(targetId)
        return CalculateCarolDuration(targetId), 216;
    end

     --Water Carol II
    buffer[451] = function(targetId)
        return CalculateCarolDuration(targetId), 216;
    end

     --Light Carol II
    buffer[452] = function(targetId)
        return CalculateCarolDuration(targetId), 216;
    end

     --Dark Carol II
    buffer[453] = function(targetId)
        return CalculateCarolDuration(targetId), 216;
    end

	--Fire Threnody
	buffer[454] = function(targetId)
		return CalculateThrenodyDuration(60), 217;
	end

	--Ice Threnody
	buffer[455] = function(targetId)
		return CalculateThrenodyDuration(60), 217;
	end

	--Wind Threnody
	buffer[456] = function(targetId)
		return CalculateThrenodyDuration(60), 217;
	end

	--Earth Threnody
	buffer[457] = function(targetId)
		return CalculateThrenodyDuration(60), 217;
	end

	--Ltng. Threnody
	buffer[458] = function(targetId)
		return CalculateThrenodyDuration(60), 217;
	end

	--Water Threnody
	buffer[459] = function(targetId)
		return CalculateThrenodyDuration(60), 217;
	end

	--Light Threnody
	buffer[460] = function(targetId)
		return CalculateThrenodyDuration(60), 217;
	end

	--Dark Threnody
	buffer[461] = function(targetId)
		return CalculateThrenodyDuration(60), 217;
	end

	--Foe Lullaby
	buffer[463] = function(targetId)
		return CalculateLullabyDuration(30), 2;
	end

     --Goddess's Hymnus
    buffer[464] = function(targetId)
        return CalculateHymnusDuration(targetId), 218;
    end

     --Chocobo Mazurka
    buffer[465] = function(targetId)
        return CalculateMazurkaDuration(targetId), 219;
    end

	--Maiden's Virelai
	buffer[466] = function(targetId)
		return CalculateDebuffSongDuration(30, SongSum(), false), 17;
	end

     --Raptor Mazurka
    buffer[467] = function(targetId)
        return CalculateMazurkaDuration(targetId), 219;
    end

     --Foe Sirvente
    buffer[468] = function(targetId)
        return CalculateBuffSongDuration(SongSum(), targetId), 220;
    end

     --Adventurer's Dirge
    buffer[469] = function(targetId)
        return CalculateBuffSongDuration(SongSum(), targetId), 221;
    end

     --Sentinel's Scherzo
    buffer[470] = function(targetId)
        return CalculateScherzoDuration(targetId), 222;
    end
    
	--Foe Lullaby II
	buffer[471] = function(targetId)
		return CalculateLullabyDuration(60), 2;
	end

	--Pining Nocturne
	buffer[472] = function(targetId)
		return CalculateDebuffSongDuration(120, SongSum(), false), 223;
	end
    
    --Fire Threnody II
	buffer[871] = function(targetId)
		return CalculateThrenodyDuration(90), 217;
	end

	--Ice Threnody II
	buffer[872] = function(targetId)
		return CalculateThrenodyDuration(90), 217;
	end

	--Wind Threnody II
	buffer[873] = function(targetId)
		return CalculateThrenodyDuration(90), 217;
	end

	--Earth Threnody II
	buffer[874] = function(targetId)
		return CalculateThrenodyDuration(90), 217;
	end

	--Ltng. Threnody II
	buffer[875] = function(targetId)
		return CalculateThrenodyDuration(90), 217;
	end

	--Water Threnody II
	buffer[876] = function(targetId)
		return CalculateThrenodyDuration(90), 217;
	end

	--Light Threnody II
	buffer[877] = function(targetId)
		return CalculateThrenodyDuration(90), 217;
	end

	--Dark Threnody II
	buffer[878] = function(targetId)
		return CalculateThrenodyDuration(90), 217;
	end
end

return Initialize;
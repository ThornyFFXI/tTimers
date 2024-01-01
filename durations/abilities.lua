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

local rollDuration = {
    [11220] = 20, --Nvrch. Gants +1
    [11120] = 40, --Nvrch. Gants +2
    [27084] = 45, --Chasseur's Gants
    [27085] = 50, --Chasseur's Gants +1
    [26038] = 20, --Regal Necklace
    [26262] = 30, --Camulus's Mantle
    [21482] = 20, --Compensator
};

local function CalculateBloodPactDuration(base)
    local skill = gData.GetCombatSkill(38);
    if skill > 300 then
        return base + (skill - 300);
    end
    return base;
end

local function CalculateManeuverDuration()
    --This can be calculated but not necessarily straightforward.
    return 60;
end

local function CalculateCorsairRollDuration()
    local duration = 300;
    local augments = gData.ParseAugments();
    duration = duration + gData.EquipSum(rollDuration);
    duration = duration + augments.PhantomRoll;
    if (gData.GetMainJob() == 17) and (gData.GetMainJobLevel() >= 75) then
        local merits = gData.GetMeritCount(0xC04);
        local multiplier = 20;
        if augments.Generic[0x590] then
            multiplier = 26;
        end
        duration = duration + (merits * multiplier);
        if (gData.GetMainJobLevel() == 99) then
            duration = duration + (gData.GetJobPoints(17, 2) * 2);
        end
    end
    return duration;
end

local function CalculateStepDuration(targetId, abilityId)
    -- Stub Base Duration
    return 60
end

local function Initialize(tracker, buffer)
    dataTracker = tracker;

    --Mighty Strikes
    buffer[16] = function(targetId)
        local duration = 45;
        if gData.ParseAugments().Generic[0x500] then
            duration = duration + 15;
        end
        return duration;
    end

    --Hundred Fists
    buffer[17] = function(targetId)
        local duration = 45;
        if gData.ParseAugments().Generic[0x501] then
            duration = duration + 15;
        end
        return duration;
    end

    --Manafont
    buffer[19] = function(targetId)
        local duration = 60;
        if gData.ParseAugments().Generic[0x503] then
            duration = duration + 30;
        end
        return duration;
    end

    --Chainspell
    buffer[20] = function(targetId)
        local duration = 60;
        if gData.ParseAugments().Generic[0x504] then
            duration = duration + 20;
        end
        return duration;
    end

    --Perfect Dodge
    buffer[21] = function(targetId)
        local duration = 30;
        if gData.ParseAugments().Generic[0x505] then
            duration = duration + 10;
        end
        return duration;
    end

    --Invincible
    buffer[22] = function(targetId)
        local duration = 30;
        if gData.ParseAugments().Generic[0x506] then
            duration = duration + 10;
        end
        return duration;
    end

    --Blood Weapon
    buffer[23] = function(targetId)
        local duration = 30;
        if gData.ParseAugments().Generic[0x507] then
            duration = duration + 40;
        end
        return duration;
    end

    --Familiar
    buffer[24] = function(targetId)
        local duration = 1800;
        if gData.ParseAugments().Generic[0x508] then
            duration = duration + 600;
        end
        return duration;
    end

    --Soul Voice
    buffer[25] = function(targetId)
        local duration = 180;
        if gData.ParseAugments().Generic[0x509] then
            duration = duration + 30;
        end
        return duration;
    end

    --Meikyo Shisui
    buffer[27] = function(targetId)
        local duration = 30;
        return duration;
    end

    --Spirit Surge
    buffer[29] = function(targetId)
        local duration = 60;
        if gData.ParseAugments().Generic[0x50D] then
            duration = duration + 20;
        end
        return duration;
    end

    --Astral Flow
    buffer[30] = function(targetId)
        local duration = 180;
        if gData.ParseAugments().Generic[0x50E] then
            duration = duration + 30;
        end
        return duration;
    end

    --Berserk
    buffer[31] = function(targetId)
        local additiveModifiers = {
            [10730] = 10, --War. Calligae +2
            [27328] = 15, --Agoge Calligae
            [27329] = 20, --Agoge Calligae +1
            [23331] = 25, --Agoge Calligae +2
            [23666] = 30, --Agoge Calligae +3
            [27807] = 10, --Pummeler's Lorica
            [27828] = 14, --Pumm. Lorica +1
            [23107] = 16, --Pumm. Lorica +2
            [23442] = 18, --Pumm. Lorica +3
            [26246] = 15, --Cichol's Mantle
            [20678] = 15, --Firangi
            [20842] = 15, --Reikiono
            [20845] = 20 --Instigator
        };
        local duration = 180;
        duration = duration + gData.EquipSum(additiveModifiers);
        return duration;
    end

    --Warcry
    buffer[32] = function(targetId)
        local additiveModifiers = {
            [15072] = 10, --Warrior's Mask
            [15245] = 10, --War. Mask +1
            [10650] = 20, --War. Mask +2
            [26624] = 25, --Agoge Mask
            [26625] = 30, --Agoge Mask +1
            [23063] = 30, --Agoge Mask +2
            [23398] = 30 --Agoge Mask +3
        };
        local duration = 30;
        duration = duration + gData.EquipSum(additiveModifiers);
        return duration;
    end

    --Defender
    buffer[33] = function(targetId)
        return 180;
    end

    --Aggressor
    buffer[34] = function(targetId)
        local additiveModifiers = {
            [10670] = 10, --War. Lorica +2
            [26800] = 15, --Agoge Lorica
            [26801] = 20, --Agoge Lorica +1
            [23130] = 25, --Agoge Lorica +2
            [23465] = 30, --Agoge Lorica +3
            [27663] = 10, --Pummeler's Mask
            [27684] = 14, --Pumm. Mask +1
            [23040] = 16, --Pummeler's Mask +2
            [23375] = 18, --Pummeler's Mask +3
            [20845] = 20 --Instigator
        };
        local duration = 180;
        duration = duration + gData.EquipSum(additiveModifiers);
        return duration;
    end

    --Focus
    buffer[36] = function(targetId)
        return 30;
    end

    --Dodge
    buffer[37] = function(targetId)
        return 30;
    end

    --Boost
    buffer[39] = function(targetId)
        --NOTE: This varies with delay and could technically be calculated.  I don't think it's a priority since you can get duration from statustimers/etc.
        return nil;
    end

    --Counterstance
    buffer[40] = function(targetId)
        return 300;
    end

    --Flee
    buffer[42] = function(targetId)
        local additiveModifiers = {
            [14094] = 15, --Rogue's Poulaines
            [15357] = 15, --Rog. Poulaines +1
            [28228] = 15, --Pillager's Poulaines
            [28249] = 16, --Pill. Poulaines +1
            [23313] = 17, --Pill. Poulaines +2
            [23648] = 18 --Pill. Poulaines +3
        };
        local duration = 30;
        duration = duration + gData.EquipSum(additiveModifiers);
        return duration;
    end

    --Hide
    buffer[43] = function(targetId)
        --NOTE: No available data on how this is calculated, and it varies.
        return nil;
    end

    --Sneak Attack
    buffer[44] = function(targetId)
        return 60;
    end

    --Holy Circle
    buffer[47] = function(targetId)
        local multipliers = {
            [14095] = 0.5, --Gallant Leggings
            [15358] = 0.5, --Glt. Leggings +1
            [28229] = 0.5, --Rev. Leggings
            [28250] = 0.5, --Rev. Leggings +1
            [23314] = 0.5, --Rev. Leggings +2
            [23649] = 0.5 --Rev. Leggings +3
        };
        local duration = 180;
        duration = duration * (1.0 + gData.EquipSum(multipliers));
        return duration;
    end

    --Sentinel
    buffer[48] = function(targetId)
        local duration = 30;
        local augments = gData.ParseAugments();
        if gData.GetMainJob() == 7 and gData.GetMainJobLevel() >= 75 then
            local merits = gData.GetMeritCount(0x986);
            if merits > 0 and augments.Generic[0x557] then
                duration = duration + (2 * merits);
            end
        end
        return duration;
    end

    --Souleater
    buffer[49] = function(targetId)
        return 60;
    end

    --Arcane Circle
    buffer[50] = function(targetId)
        local multipliers = {
            [14096] = 0.5, --Chaos Sollerets
            [15359] = 0.5, --Chs. Sollerets +1
            [28230] = 0.5, --Igno. Sollerets
            [28251] = 0.5, --Igno. Sollerets +1
            [23315] = 0.5, --Ig. Sollerets +2
            [23650] = 0.5 --Ig. Sollerets +3
        };
        local duration = 180;
        duration = duration * (1.0 + gData.EquipSum(multipliers));
        return duration;
    end

    --Last Resort
    buffer[51] = function(targetId)
        local additiveModifiers = {
            [26253] = 15 --Ankou's Mantle
        };
        local duration = 180;
        duration = duration + gData.EquipSum(additiveModifiers);
        return duration;
    end

    --Shadowbind
    buffer[57] = function(targetId)
        local additiveModifiers = {
            [13971] = 10, --Hunter's Bracers
            [14900] = 10, --Htr. Bracers +1
            [27953] = 10, --Orion Bracers
            [27974] = 12, --Orion Bracers +1
            [23184] = 14, --Orion Bracers +2
            [23519] = 16 --Orion Bracers +3
        };
        local duration = 30;
        duration = duration + gData.EquipSum(additiveModifiers);
        if gData.GetMainJob() == 11 and gData.GetMainJobLevel() == 99 then
            duration = duration + gData.GetJobPoints(11, 5);
        end
        return duration;
    end

    --Camouflage
    buffer[58] = function(targetId)
        return nil;
    end

    --Sharpshot
    buffer[59] = function(targetId)
        return 60;
    end

    --Barrage
    buffer[60] = function(targetId)
        return 60;
    end

    --Third Eye
    buffer[62] = function(targetId)
        return 30;
    end

    --Meditate
    buffer[63] = function(targetId)
        local additiveModifiers = {
            [15113] = 4, --Saotome Kote
            [14920] = 4, --Saotome Kote +1
            [10701] = 8, --Sao. Kote +2
            [26998] = 8, --Sakonji Kote
            [26999] = 8, --Sakonji Kote +1
            [23208] = 8, --Sakonji Kote +2
            [23543] = 12, --Sakonji Kote +3
            [26257] = 8, --Smertrios's Mantle
            [21979] = 4 --Gekkei
        };
        local duration = 15;
        local augments = gData.ParseAugments().Generic[0x4F0];
        if augments then
            for _,v in pairs(augments) do
                duration = duration + (v + 1);
            end
        end
        duration = duration + gData.EquipSum(additiveModifiers);
        return nil;
    end

    --Warding Circle
    buffer[64] = function(targetId)
        local multipliers = {
            [13868] = 0.5, --Myochin Kabuto
            [15236] = 0.5, --Myn. Kabuto +1
            [27674] = 0.5, --Wakido Kabuto
            [27695] = 0.5, --Wakido Kabuto +1
            [23051] = 0.5, --Wakido Kabuto +2
            [23386] = 0.5 --Wakido Kabuto +3
        };
        local duration = 180;
        duration = duration * (1.0 + gData.EquipSum(multipliers));
        return duration;
    end

    --Ancient Circle
    buffer[65] = function(targetId)
        local multipliers = {
            [14227] = 0.5, --Drachen Brais
            [15574] = 0.5, --Drn. Brais +1
            [28103] = 0.5, --Vishap Brais
            [28124] = 0.5, --Vishap Brais +1
            [23254] = 0.5, --Vishap Brais +2
            [23589] = 0.5 --Vishap Brais +3
        };
        local duration = 180;
        duration = duration * (1.0 + gData.EquipSum(multipliers));
        return duration;
    end

    --Divine Seal
    buffer[74] = function(targetId)
        return 60;
    end

    --Elemental Seal
    buffer[75] = function(targetId)
        return 60;
    end

    --Trick Attack
    buffer[76] = function(targetId)
        return 60;
    end

    --Reward
    buffer[78] = function(targetId)
        return 180;
    end

    --Cover
    buffer[79] = function(targetId)
        local additiveModifiers = {
            [12515] = 5, --Gallant Coronet
            [15231] = 5, --Gallant Coronet +1
            [27669] = 7, --Rev. Coronet
            [27690] = 9, --Rev. Coronet +1
            [23046] = 9, --Rev. Coronet +2
            [23381] = 10, --Rev. Coronet +3
            [16604] = 5, --Save The Queen
            [21641] = 30, --Save The Queen III
            [20728] = 8 --Kheshig Blade
        };
        local duration = 15;
        duration = duration + gData.EquipSum(additiveModifiers);
        return duration;
    end

    --Chi Blast
    buffer[82] = function(targetId)
        if gData.GetMainJob() == 2 and gData.GetMainJobLevel() >= 75 then
            local penanceMerits = gData.GetMeritCount(0x846);
            if penanceMerits > 0 then
                return penanceMerits * 20;
            end
        end
        return nil;
    end

    --Unlimited Shot
    buffer[86] = function(targetId)
        return 60;
    end

    --Rampart
    buffer[92] = function(targetId)
        local additiveModifiers = {
            [15078] = 15, --Valor Coronet
            [15251] = 15, --Vlr. Coronet +1
            [10656] = 30, --Vlr. Coronet +2
            [26636] = 30, --Cab. Coronet
            [26637] = 30, --Cab. Coronet +1
            [23069] = 30, --Cab. Coronet +2
            [23404] = 30 --Cab. Coronet +3
        };
        local duration = 30;
        duration = duration + gData.EquipSum(additiveModifiers);
        return duration;
    end

    --Azure Lore
    buffer[93] = function(targetId)
        local duration = 30;
        if gData.ParseAugments().Generic[0x50F] then
            duration = duration + 10;
        end
        return duration;
    end

    --Chain Affinity
    buffer[94] = function(targetId)
        return 30;
    end

    --Burst Affinity
    buffer[95] = function(targetId)
        return 30;
    end

    --Fighter's Roll
    buffer[98] = function(targetId)
        return CalculateCorsairRollDuration();
    end

    --Monk's Roll
    buffer[99] = function(targetId)
        return CalculateCorsairRollDuration();
    end

    --Healer's Roll
    buffer[100] = function(targetId)
        return CalculateCorsairRollDuration();
    end

    --Wizard's Roll
    buffer[101] = function(targetId)
        return CalculateCorsairRollDuration();
    end

    --Warlock's Roll
    buffer[102] = function(targetId)
        return CalculateCorsairRollDuration();
    end

    --Rogue's Roll
    buffer[103] = function(targetId)
        return CalculateCorsairRollDuration();
    end

    --Gallant's Roll
    buffer[104] = function(targetId)
        return CalculateCorsairRollDuration();
    end

    --Chaos Roll
    buffer[105] = function(targetId)
        return CalculateCorsairRollDuration();
    end

    --Beast Roll
    buffer[106] = function(targetId)
        return CalculateCorsairRollDuration();
    end

    --Choral Roll
    buffer[107] = function(targetId)
        return CalculateCorsairRollDuration();
    end

    --Hunter's Roll
    buffer[108] = function(targetId)
        return CalculateCorsairRollDuration();
    end

    --Samurai Roll
    buffer[109] = function(targetId)
        return CalculateCorsairRollDuration();
    end

    --Ninja Roll
    buffer[110] = function(targetId)
        return CalculateCorsairRollDuration();
    end

    --Drachen Roll
    buffer[111] = function(targetId)
        return CalculateCorsairRollDuration();
    end

    --Evoker's Roll
    buffer[112] = function(targetId)
        return CalculateCorsairRollDuration();
    end

    --Magus's Roll
    buffer[113] = function(targetId)
        return CalculateCorsairRollDuration();
    end

    --Corsair's Roll
    buffer[114] = function(targetId)
        return CalculateCorsairRollDuration();
    end

    --Puppet Roll
    buffer[115] = function(targetId)
        return CalculateCorsairRollDuration();
    end

    --Dancer's Roll
    buffer[116] = function(targetId)
        return CalculateCorsairRollDuration();
    end

    --Scholar's Roll
    buffer[117] = function(targetId)
        return CalculateCorsairRollDuration();
    end

    --Bolter's Roll
    buffer[118] = function(targetId)
        return CalculateCorsairRollDuration();
    end

    --Caster's Roll
    buffer[119] = function(targetId)
        return CalculateCorsairRollDuration();
    end

    --Courser's Roll
    buffer[120] = function(targetId)
        return CalculateCorsairRollDuration();
    end

    --Blitzer's Roll
    buffer[121] = function(targetId)
        return CalculateCorsairRollDuration();
    end

    --Tactician's Roll
    buffer[122] = function(targetId)
        return CalculateCorsairRollDuration();
    end

    --Light Shot
    buffer[131] = function(targetId)
        return 60;
    end

    --Overdrive
    buffer[135] = function(targetId)
        local duration = 180;
        if gData.ParseAugments().Generic[0x511] then
            duration = duration + 20;
        end
        return duration;
    end

    --Activate
    buffer[136] = function(targetId)
        return nil;
    end

    --Repair
    buffer[137] = function(targetId)
        local oilDuration = {
            [18731] = 15, --Automaton Oil
            [18732] = 30, --Automat. Oil +1
            [18733] = 45, --Automat. Oil +2
            [19185] = 60 --Automat. Oil +3
        };
        local oil = gData.GetEquipmentTable()[4].Id;
        return oilDuration[oil]; --This is nil if no oil because we can't calculate a duration.
    end
    
    --Fire Maneuver
    buffer[141] = function(targetId)
        return CalculateManeuverDuration();
    end

    --Ice Maneuver
    buffer[142] = function(targetId)
        return CalculateManeuverDuration();
    end

    --Wind Maneuver
    buffer[143] = function(targetId)
        return CalculateManeuverDuration();
    end

    --Earth Maneuver
    buffer[144] = function(targetId)
        return CalculateManeuverDuration();
    end

    --Thunder Maneuver
    buffer[145] = function(targetId)
        return CalculateManeuverDuration();
    end

    --Water Maneuver
    buffer[146] = function(targetId)
        return CalculateManeuverDuration();
    end

    --Light Maneuver
    buffer[147] = function(targetId)
        return CalculateManeuverDuration();
    end

    --Dark Maneuver
    buffer[148] = function(targetId)
        return CalculateManeuverDuration();
    end

    --Warrior's Charge
    buffer[149] = function(targetId)
        return 60;
    end

    --Tomahawk
    buffer[150] = function(targetId)
        local duration = 15 + (15 * gData.GetMeritCount(0x802));
        return duration;
    end

    --Mantra
    buffer[151] = function(targetId)
        return 180;
    end

    --Formless Strikes
    buffer[152] = function(targetId)
        local duration = 180;
        if gData.ParseAugments().Generic[0x537] then
            duration = duration + (6 * gData.GetMeritCount(0x842));
        end
        return duration;
    end

    --Assassin's Charge
    buffer[155] = function(targetId)
        return 60;
    end

    --Feint
    buffer[156] = function(targetId)
        return 60;
    end

    --Fealty
    buffer[157] = function(targetId)
        local duration = 60;
        if gData.ParseAugments().Generic[0x555] then
            duration = duration + (4 * gData.GetMeritCount(0x980));
        end
        return duration;
    end

    --Dark Seal
    buffer[159] = function(targetId)
        return 60;
    end

    --Diabolic Eye
    buffer[160] = function(targetId)
        local duration = 180;
        if gData.ParseAugments().Generic[0x55B] then
            duration = duration + (6 * gData.GetMeritCount(0x9C2));
        end
        return duration;
    end

    --Killer Instinct
    buffer[162] = function(targetId)
        local duration = 170;
        local meritCount = gData.GetMeritCount(0xA02);
        duration = duration + (10 * meritCount);
        if gData.ParseAugments().Generic[0x560] then
            duration = duration + (4 * meritCount);
        end
        return duration;
    end

    --Nightingale
    buffer[163] = function(targetId)
        local duration = 60;
        if gData.ParseAugments().Generic[0x569] then
            duration = duration + (4 * gData.GetMeritCount(0xA40));
        end
        return duration;
    end

    --Troubadour
    buffer[164] = function(targetId)
        local duration = 60;
        if gData.ParseAugments().Generic[0x567] then
            duration = duration + (4 * gData.GetMeritCount(0xA42));
        end
        return duration;
    end

    --Stealth Shot
    buffer[165] = function(targetId)
        return 60;
    end

    --Flashy Shot
    buffer[166] = function(targetId)
        return 60;
    end

    --Deep Breathing
    buffer[169] = function(targetId)
        return 180;
    end

    --Angon
    buffer[170] = function(targetId)
        local duration = 15 + (15 * gData.GetMeritCount(0xB42));
        return duration;
    end

    --Sange
    buffer[171] = function(targetId)
        return 60;
    end

    --Hasso
    buffer[173] = function(targetId)
        return 300;
    end

    --Seigan
    buffer[174] = function(targetId)
        return 300;
    end

    --Convergence
    buffer[175] = function(targetId)
        return 60;
    end

    --Diffusion
    buffer[176] = function(targetId)
        return 60;
    end

    --Snake Eye
    buffer[177] = function(targetId)
        return 60;
    end

    --Trance
    buffer[181] = function(targetId)
        local duration = 60;
        if gData.ParseAugments().Generic[0x512] then
            duration = duration + 20;
        end
        return duration;
    end

    --Drain Samba
    buffer[184] = function(targetId)        
        local duration = 120;
        if gData.GetMainJob() == 19 and gData.GetMainJobLevel() == 99 then
            duration = duration + (2 * gData.GetJobPoints(19, 3));
        end
        return duration;
    end

    --Drain Samba II
    buffer[185] = function(targetId) 
        local duration = 90;
        if gData.GetMainJob() == 19 and gData.GetMainJobLevel() == 99 then
            duration = duration + (2 * gData.GetJobPoints(19, 3));
        end
        return duration;
    end

    --Drain Samba III
    buffer[186] = function(targetId) 
        local duration = 90;
        if gData.GetMainJob() == 19 and gData.GetMainJobLevel() == 99 then
            duration = duration + (2 * gData.GetJobPoints(19, 3));
        end
        return duration;
    end

    --Aspir Samba
    buffer[187] = function(targetId) 
        local duration = 120;
        if gData.GetMainJob() == 19 and gData.GetMainJobLevel() == 99 then
            duration = duration + (2 * gData.GetJobPoints(19, 3));
        end
        return duration;
    end

    --Aspir Samba II
    buffer[188] = function(targetId) 
        local duration = 120;
        if gData.GetMainJob() == 19 and gData.GetMainJobLevel() == 99 then
            duration = duration + (2 * gData.GetJobPoints(19, 3));
        end
        return duration;
    end

    --Haste Samba
    buffer[189] = function(targetId) 
        local duration = 90;
        if gData.GetMainJob() == 19 and gData.GetMainJobLevel() == 99 then
            duration = duration + (2 * gData.GetJobPoints(19, 3));
        end
        return duration;
    end

    --Spectral Jig
    buffer[196] = function(targetId)
        local multipliers = {
            [15747] = 0.35, --Dancer's Shoes(female)
            [11394] = 0.35, --Dancer's Shoes +1(female)
            [28242] = 0.4, --Maxixi Shoes(female)
            [28263] = 0.4, --Maxixi Shoes +1(female)
            [23327] = 0.45, --Maxixi Toe Shoes +2(female)
            [23662] = 0.5, --Maxixi Toe Shoes +3(female)            
            [15746] = 0.35, --Dancer's Shoes(male)
            [11393] = 0.35, --Dancer's Shoes +1(male)
            [28241] = 0.4, --Maxixi Shoes(male)
            [28262] = 0.4, --Maxixi Shoes +1(male)
            [23326] = 0.45, --Maxixi Toe Shoes +2(male)
            [23661] = 0.5, --Maxixi Toe Shoes +3(male)
            [16360] = 0.35, --Etoile Tights
            [16361] = 0.35, --Etoile Tights +1
            [10728] = 0.35, --Etoile Tights +2
            [27188] = 0.4, --Horos Tights
            [27189] = 0.45, --Horos Tights +1
            [23282] = 0.5, --Horos Tights +2
            [23617] = 0.5 --Horos Tights +3
        };
        local duration = 180;
        duration = duration * (1 + gData.EquipSum(multipliers));
        return duration;
    end

    --Chocobo Jig
    buffer[197] = function(targetId)
        local multipliers = {
            [15747] = 0.35, --Dancer's Shoes(female)
            [11394] = 0.35, --Dancer's Shoes +1(female)
            [28242] = 0.4, --Maxixi Shoes(female)
            [28263] = 0.4, --Maxixi Shoes +1(female)
            [23327] = 0.45, --Maxixi Toe Shoes +2(female)
            [23662] = 0.5, --Maxixi Toe Shoes +3(female)            
            [15746] = 0.35, --Dancer's Shoes(male)
            [11393] = 0.35, --Dancer's Shoes +1(male)
            [28241] = 0.4, --Maxixi Shoes(male)
            [28262] = 0.4, --Maxixi Shoes +1(male)
            [23326] = 0.45, --Maxixi Toe Shoes +2(male)
            [23661] = 0.5, --Maxixi Toe Shoes +3(male)
            [16360] = 0.35, --Etoile Tights
            [16361] = 0.35, --Etoile Tights +1
            [10728] = 0.35, --Etoile Tights +2
            [27188] = 0.4, --Horos Tights
            [27189] = 0.45, --Horos Tights +1
            [23282] = 0.5, --Horos Tights +2
            [23617] = 0.5 --Horos Tights +3
        };
        local duration = 120;
        duration = duration * (1 + gData.EquipSum(multipliers));
        return duration;
    end
    
    --Quickstep
    buffer[201] = function(targetId)
        return CalculateStepDuration(targetId, 201);
    end

    --Box Step
    buffer[202] = function(targetId)
        return CalculateStepDuration(targetId, 202);
    end

    --Stutter Step
    buffer[203] = function(targetId)
        return CalculateStepDuration(targetId, 203);
    end

    --Deperate Flourish
    buffer[205] = function(targetId)
        return 120; -- FIXME: Stub duration
    end

    --Building Flourish
    buffer[208] = function(targetId)
        return 60;
    end

    --Tabula Rasa
    buffer[210] = function(targetId)
        local duration = 180;
        if gData.ParseAugments().Generic[0x513] then
            duration = duration + 30;
        end
        return duration;
    end

    --Light Arts
    buffer[211] = function(targetId)
        return 7200;
    end

    --Dark Arts
    buffer[212] = function(targetId)
        return 7200;
    end

    --Penury
    buffer[215] = function(targetId)
        return 60;
    end

    --Celerity
    buffer[216] = function(targetId)
        return 60;
    end

    --Rapture
    buffer[217] = function(targetId)
        return 60;
    end

    --Accession
    buffer[218] = function(targetId)
        return 60;
    end

    --Parsimony
    buffer[219] = function(targetId)
        return 60;
    end

    --Alacrity
    buffer[220] = function(targetId)
        return 60;
    end

    --Ebullience
    buffer[221] = function(targetId)
        return 60;
    end

    --Manifestation
    buffer[222] = function(targetId)
        return 60;
    end

    --Velocity Shot
    buffer[224] = function(targetId)
        return 7200;
    end

    --Retaliation
    buffer[226] = function(targetId)
        return 180;
    end

    --Footwork
    buffer[227] = function(targetId)
        return 60;
    end

    --Pianissimo
    buffer[229] = function(targetId)
        return 60;
    end

    --Sekkanoki
    buffer[230] = function(targetId)
        return 60;
    end

    --Sublimation
    buffer[233] = function(targetId)
        return 7200;
    end

    --Addendum: White
    buffer[234] = function(targetId)
        return 7200;
    end

    --Addendum: Black
    buffer[235] = function(targetId)
        return 7200;
    end

    --Saber Dance
    buffer[237] = function(targetId)
        return 300;
    end

    --Fan Dance
    buffer[238] = function(targetId)
        return 300;
    end

    --No Foot Rise
    buffer[239] = function(targetId)
        return nil;
    end

    --Altruism
    buffer[240] = function(targetId)
        return 60;
    end

    --Focalization
    buffer[241] = function(targetId)
        return 60;
    end

    --Tranquility
    buffer[242] = function(targetId)
        return 60;
    end

    --Equanimity
    buffer[243] = function(targetId)
        return 60;
    end

    --Enlightenment
    buffer[244] = function(targetId)
        return 60;
    end

    --Afflatus Solace
    buffer[245] = function(targetId)
        return 7200;
    end

    --Afflatus Misery
    buffer[246] = function(targetId)
        return 7200;
    end

    --Composure
    buffer[247] = function(targetId)
        return 7200;
    end

    --Yonin
    buffer[248] = function(targetId)
        return 300;
    end

    --Innin
    buffer[249] = function(targetId)
        return 300;
    end

    --Avatar's Favor
    buffer[250] = function(targetId)
        return 7200;
    end

    --Restraint
    buffer[252] = function(targetId)
        return 300;
    end

    --Perfect Counter
    buffer[253] = function(targetId)
        return 30;
    end

    --Mana Wall
    buffer[254] = function(targetId)
        return 300;
    end

    --Divine Emblem
    buffer[255] = function(targetId)
        return 60;
    end

    --Nether Void
    buffer[256] = function(targetId)
        return 60;
    end

    --Double Shot
    buffer[257] = function(targetId)
        return 90;
    end

    --Sengikori
    buffer[258] = function(targetId)
        return 60;
    end

    --Futae
    buffer[259] = function(targetId)
        return 60;
    end

    --Presto
    buffer[261] = function(targetId)
        return 30;
    end

    --Climactic Flourish
    buffer[264] = function(targetId)
        return 60;
    end

    --Blood Rage
    buffer[267] = function(targetId)
    
        local additiveModifiers = {
            [11184] = 15, --Rvg. Lorica +1
            [11084] = 30, --Rvg. Lorica +2
            [26898] = 32, --Boii Lorica
            [26899] = 34 --Boii Lorica +1            
        };
        local duration = 30;
        duration = duration + gData.EquipSum(additiveModifiers);
        return duration;
    end

    --Impetus
    buffer[269] = function(targetId)
        return 180;
    end

    --Divine Caress
    buffer[270] = function(targetId)
        return 60;
    end

    --Sacrosanctity
    buffer[271] = function(targetId)
        return 60;
    end

    --Manawell
    buffer[273] = function(targetId)
        return 60;
    end

    --Saboteur
    buffer[274] = function(targetId)
        return 60;
    end

    --Spontaneity
    buffer[275] = function(targetId)
        return 60;
    end

    --Conspirator
    buffer[276] = function(targetId)
        return 60;
    end

    --Sepulcher
    buffer[277] = function(targetId)
        return 180;
    end

    --Palisade
    buffer[278] = function(targetId)
        return 60;
    end

    --Arcane Crest
    buffer[279] = function(targetId)
        return 180;
    end

    --Scarlet Delirium
    buffer[280] = function(targetId)
        return 90;
    end

    --Spur
    buffer[281] = function(targetId)
        return 90;
    end

    --Run Wild
    buffer[282] = function(targetId)
        local duration = 300;
        if gData.GetMainJob() == 9 and gData.GetMainJobLevel() == 99 then
            duration = duration + (2 * gData.GetJobPoints(9, 8));
        end
        return duration;
    end

    --Tenuto
    buffer[283] = function(targetId)
        return 60;
    end

    --Marcato
    buffer[284] = function(targetId)
        return 60;
    end

    --Decoy Shot
    buffer[286] = function(targetId)
        return 180;
    end

    --Hamanoha
    buffer[287] = function(targetId)
        return 180;
    end

    --Hagakure
    buffer[288] = function(targetId)
        return 60;
    end

    --Issekigan
    buffer[291] = function(targetId)
        return 60;
    end

    --Dragon Breaker
    buffer[292] = function(targetId)
        return 180;
    end

    --Soul Jump
    buffer[293] = function(targetId)
        return nil;
    end

    --Steady Wing
    buffer[295] = function(targetId)
        return 180;
    end

    --Efflux
    buffer[297] = function(targetId)
        return 60;
    end

    --Unbridled Learning
    buffer[298] = function(targetId)
        return 60;
    end

    --Triple Shot
    buffer[301] = function(targetId)
        return 90;
    end

    --Allies' Roll
    buffer[302] = function(targetId)
        return nil;
    end

    --Miser's Roll
    buffer[303] = function(targetId)
        return CalculateCorsairRollDuration();
    end

    --Companion's Roll
    buffer[304] = function(targetId)
        return CalculateCorsairRollDuration();
    end

    --Avenger's Roll
    buffer[305] = function(targetId)
        return CalculateCorsairRollDuration();
    end

    --Feather Step
    buffer[312] = function(targetId)
        return CalculateStepDuration(targetId, 312);
    end

    --Striking Flourish
    buffer[313] = function(targetId)
        return 60;
    end

    --Ternary Flourish
    buffer[314] = function(targetId)
        return 60;
    end

    --Perpetuance
    buffer[316] = function(targetId)
        return 60;
    end

    --Immanence
    buffer[317] = function(targetId)
        return 60;
    end

    --Konzen-ittai
    buffer[320] = function(targetId)
        return 60;
    end

    --Bully
    buffer[321] = function(targetId)
        return 30;
    end

    --Brazen Rush
    buffer[323] = function(targetId)
        return 30;
    end

    --Inner Strength
    buffer[324] = function(targetId)
        return 30;
    end

    --Asylum
    buffer[325] = function(targetId)
        return 30;
    end

    --Subtle Sorcery
    buffer[326] = function(targetId)
        return 60;
    end

    --Stymie
    buffer[327] = function(targetId)
        return 60;
    end

    --Intervene
    buffer[329] = function(targetId)
        return 30;
    end

    --Soul Enslavement
    buffer[330] = function(targetId)
        return 30;
    end

    --Unleash
    buffer[331] = function(targetId)
        return 60;
    end

    --Clarion Call
    buffer[332] = function(targetId)
        return 180;
    end

    --Overkill
    buffer[333] = function(targetId)
        return 60;
    end

    --Yaegasumi
    buffer[334] = function(targetId)
        return 45;
    end

    --Mikage
    buffer[335] = function(targetId)
        return 45;
    end

    --Fly High
    buffer[336] = function(targetId)
        return 30;
    end

    --Astral Conduit
    buffer[337] = function(targetId)
        return 30;
    end

    --Unbridled Wisdom
    buffer[338] = function(targetId)
        return 60;
    end

    --Cutting Cards
    buffer[339] = function(targetId)
        return nil;
    end

    --Heady Artifice
    buffer[340] = function(targetId)
        --TODO: Find automaton head to determine length... (maybe pet uses command and can do it that way?)
        return 0;
    end

    --Grand Pas
    buffer[341] = function(targetId)
        return 30;
    end

    --Bolster
    buffer[343] = function(targetId)
        local duration = 180;
        if gData.ParseAugments().Generic[0x514] then
            duration = 210;
        end
        return duration;
    end

    --Collimated Fervor
    buffer[348] = function(targetId)
        return 60;
    end

    --Blaze of Glory
    buffer[350] = function(targetId)
        return 60;
    end

    --Dematerialize
    buffer[351] = function(targetId)
        local duration = 60;
        if gData.GetMainJob() == 21 and gData.GetMainJobLevel() == 99 then
            duration = duration + gData.GetJobPoints(21, 6);
        end
        return duration;
    end

    --Theurgic Focus
    buffer[352] = function(targetId)
        return 60;
    end

    --Concentric Pulse
    buffer[353] = function(targetId)
        return nil;
    end

    --Mending Halation
    buffer[354] = function(targetId)
        return nil;
    end

    --Radial Arcana
    buffer[355] = function(targetId)
        return nil;
    end

    --Elemental Sforzo
    buffer[356] = function(targetId)
        local duration = 30;
        if gData.ParseAugments().Generic[0x515] then
            duration = 40;
        end
        return duration;
    end

    --Ignis
    buffer[358] = function(targetId)
        return 300;
    end

    --Gelus
    buffer[359] = function(targetId)
        return 300;
    end

    --Flabra
    buffer[360] = function(targetId)
        return 300;
    end

    --Tellus
    buffer[361] = function(targetId)
        return 300;
    end

    --Sulpor
    buffer[362] = function(targetId)
        return 300;
    end

    --Unda
    buffer[363] = function(targetId)
        return 300;
    end

    --Lux
    buffer[364] = function(targetId)
        return 300;
    end

    --Tenebrae
    buffer[365] = function(targetId)
        return 300;
    end

    --Vallation
    buffer[366] = function(targetId)
        local duration = 120;
        local additiveModifiers = {
            [27927] = 15, --Runeist Coat
            [27850] = 15, --Runeist Coat +1
            [23129] = 17, --Runeist's Coat +2
            [23464] = 19, --Runeist's Coat +3
            [26267] = 15 --Ogma's Cape
        };
        duration = duration + gData.EquipSum(additiveModifiers);
        if gData.GetMainJob() == 22 and gData.GetMainJobLevel() == 99 then
            duration = duration + gData.GetJobPoints(22, 3);
        end
        return duration;
    end

    --Swordplay
    buffer[367] = function(targetId)
        return 120;
    end

    --Pflug
    buffer[369] = function(targetId)
        return 120;
    end

    --Embolden
    buffer[370] = function(targetId)
        return 60;
    end

    --Valiance
    buffer[371] = function(targetId)
        local duration = 180;
        local additiveModifiers = {
            [27927] = 15, --Runeist Coat
            [27850] = 15, --Runeist Coat +1
            [23129] = 17, --Runeist's Coat +2
            [23464] = 19, --Runeist's Coat +3
            [26267] = 15 --Ogma's Cape
        };
        duration = duration + gData.EquipSum(additiveModifiers);
        if gData.GetMainJob() == 22 and gData.GetMainJobLevel() == 99 then
            duration = duration + gData.GetJobPoints(22, 3);
        end
        return duration;
    end

    --Gambit
    buffer[372] = function(targetId)
        local duration = 60;
        local additiveModifiers = {
            [28067] = 10, --Runeist Mitons
            [27986] = 12, --Runeist Mitons +1
            [23196] = 14, --Runeist's Mitons +2
            [23531] = 16 --Runeist's Mitons +3
        };
        duration = duration + gData.EquipSum(additiveModifiers);
        if gData.GetMainJob() == 22 and gData.GetMainJobLevel() == 99 then
            duration = duration + gData.GetJobPoints(22, 9);
        end
        return duration;
    end

    --Liement
    buffer[373] = function(targetId)
        local duration = 10;
        local additiveModifiers = {
            [26842] = 2, --Futhark Coat
            [26843] = 3, --Futhark Coat +1
            [23151] = 4, --Futhark Coat +2
            [23486] = 5, --Futhark Coat +3
            [21698] = 3 --Bidenhander
        };
        duration = duration + gData.EquipSum(additiveModifiers);
        return duration;
    end

    --One for All
    buffer[374] = function(targetId)
        local duration = 30;
        if gData.GetMainJob() == 22 and gData.GetMainJobLevel() == 99 then
            duration = duration + gData.GetJobPoints(22, 8);
        end
        return duration;
    end

    --Rayke
    buffer[375] = function(targetId)
        local merits = gData.GetMeritCount(0xD82);
        local duration = 27 + (merits * 3);
        if gData.ParseAugments().Generic[0x515] then
            duration = duration + merits;
        end
        return duration;
    end

    --Battuta
    buffer[376] = function(targetId)
        return 90;
    end

    --Widened Compass
    buffer[377] = function(targetId)
        return 60;
    end

    --Odyllic Subterfuge
    buffer[378] = function(targetId)
        return 30;
    end

    --Chocobo Jig II
    buffer[381] = function(targetId)
        local multipliers = {
            [15747] = 0.35, --Dancer's Shoes(female)
            [11394] = 0.35, --Dancer's Shoes +1(female)
            [28242] = 0.4, --Maxixi Shoes(female)
            [28263] = 0.4, --Maxixi Shoes +1(female)
            [23327] = 0.45, --Maxixi Toe Shoes +2(female)
            [23662] = 0.5, --Maxixi Toe Shoes +3(female)            
            [15746] = 0.35, --Dancer's Shoes(male)
            [11393] = 0.35, --Dancer's Shoes +1(male)
            [28241] = 0.4, --Maxixi Shoes(male)
            [28262] = 0.4, --Maxixi Shoes +1(male)
            [23326] = 0.45, --Maxixi Toe Shoes +2(male)
            [23661] = 0.5, --Maxixi Toe Shoes +3(male)
            [16360] = 0.35, --Etoile Tights
            [16361] = 0.35, --Etoile Tights +1
            [10728] = 0.35, --Etoile Tights +2
            [27188] = 0.4, --Horos Tights
            [27189] = 0.45, --Horos Tights +1
            [23282] = 0.5, --Horos Tights +2
            [23617] = 0.5 --Horos Tights +3
        };
        local duration = 120;
        duration = duration * (1 + gData.EquipSum(multipliers));
        return duration;
    end

    --Contradance
    buffer[384] = function(targetId)
        return 60;
    end

    --Apogee
    buffer[385] = function(targetId)
        return 60;
    end

    --Entrust
    buffer[386] = function(targetId)
        return 60;
    end

    --Cascade
    buffer[388] = function(targetId)
        return 60;
    end

    --Consume Mana
    buffer[389] = function(targetId)
        return 60;
    end

    --Naturalist's Roll
    buffer[390] = function(targetId)
        return CalculateCorsairRollDuration();
    end

    --Runeist's Roll
    buffer[391] = function(targetId)
        return CalculateCorsairRollDuration();
    end

    --Crooked Cards
    buffer[392] = function(targetId)
        return 60;
    end

    --Spirit Bond
    buffer[393] = function(targetId)
        return 180;
    end

    --Majesty
    buffer[394] = function(targetId)
        return 180;
    end

    --Hover Shot
    buffer[395] = function(targetId)
        return 3600;
    end

    --Shining Ruby
    buffer[514] = function(targetId)
        return CalculateBloodPactDuration(180);
    end

    --Glittering Ruby
    buffer[515] = function(targetId)
        return CalculateBloodPactDuration(180);
    end

    --[[UNKNOWN
    --Mewing Lullaby
    buffer[522] = function(targetId)
        return nil;
    end
    ]]--

    --[[UNKNOWN
    --Eerie Eye
    buffer[523] = function(targetId)
        return nil;
    end
    ]]--

    --Reraise II
    buffer[526] = function(targetId)
        return 3600;
    end

    --Ecliptic Growl
    buffer[532] = function(targetId)
        return CalculateBloodPactDuration(180);
    end

    --Ecliptic Howl
    buffer[533] = function(targetId)
        return CalculateBloodPactDuration(180);
    end

    --Heavenward Howl
    buffer[538] = function(targetId)
        return CalculateBloodPactDuration(60);
    end

    --Crimson Howl
    buffer[548] = function(targetId)
        return CalculateBloodPactDuration(60);
    end

    --Inferno Howl
    buffer[553] = function(targetId)
        return CalculateBloodPactDuration(60);
    end

    --Conflag Strike
    buffer[554] = function(targetId)
        return 60;
    end

    --[[UNKNOWN
    --Rock Throw
    buffer[560] = function(targetId)
        return nil;
    end
    ]]--
    
    --Rock Buster
    buffer[562] = function(targetId)
        return 30;
    end

    --[[UNKNOWN
    --Megalith Throw
    buffer[563] = function(targetId)
        return nil;
    end
    ]]--

    --Earthen Ward
    buffer[564] = function(targetId)
        return 900;
    end

    --Stone IV
    buffer[565] = function(targetId)
        return nil;
    end

    --[[UNKNOWN
    --Mountain Buster
    buffer[566] = function(targetId)
        return nil;
    end
    ]]--

    --Earthen Armor
    buffer[569] = function(targetId)
        return CalculateBloodPactDuration(60);
    end

    --Crag Throw
    buffer[570] = function(targetId)
        return 120;
    end

    --[[UNKNOWN
    --Tail Whip
    buffer[578] = function(targetId)
        return nil;
    end
    ]]--

    --[[UNKNOWN
    --Slowga
    buffer[580] = function(targetId)
        return nil;
    end
    ]]--

    --Tidal Roar
    buffer[585] = function(targetId)
        return 90;
    end

    --Soothing Current
    buffer[586] = function(targetId)
        return CalculateBloodPactDuration(180);
    end

    --Hastega
    buffer[595] = function(targetId)
        return CalculateBloodPactDuration(180);
    end

    --Aerial Armor
    buffer[596] = function(targetId)
        return 900;
    end

    --Fleet Wind
    buffer[601] = function(targetId)
        return CalculateBloodPactDuration(120);
    end

    --Hastega II
    buffer[602] = function(targetId)
        return CalculateBloodPactDuration(180);
    end

    --Frost Armor
    buffer[610] = function(targetId)
        return CalculateBloodPactDuration(180);
    end

    --Sleepga
    buffer[611] = function(targetId)
        return 90;
    end

    --Diamond Storm
    buffer[617] = function(targetId)
        return 180;
    end

    --Crystal Blessing
    buffer[618] = function(targetId)
        return CalculateBloodPactDuration(180);
    end

    --Rolling Thunder
    buffer[626] = function(targetId)
        return CalculateBloodPactDuration(120);
    end

    --Lightning Armor
    buffer[628] = function(targetId)
        return CalculateBloodPactDuration(180);
    end

    --Shock Squall
    buffer[633] = function(targetId)
        return 15;
    end

    --Volt Strike
    buffer[634] = function(targetId)
        return 15;
    end

    --Nightmare
    buffer[658] = function(targetId)
        return 90;
    end
    
    --Noctoshield
    buffer[660] = function(targetId)
        return CalculateBloodPactDuration(180);
    end

    --Dream Shroud
    buffer[661] = function(targetId)
        return CalculateBloodPactDuration(180);
    end

    --Perfect Defense
    buffer[671] = function(targetId)
        return 30 + math.floor(gData.GetCombatSkill(38) / 20);
    end

    --Secretion
    buffer[688] = function(targetId)
        return nil;
    end

    --Lamb Chop
    buffer[689] = function(targetId)
        return nil;
    end

    --Rage
    buffer[690] = function(targetId)
        return nil;
    end

    --Sheep Charge
    buffer[691] = function(targetId)
        return nil;
    end

    --Sheep Song
    buffer[692] = function(targetId)
        return nil;
    end

    --Bubble Shower
    buffer[693] = function(targetId)
        return nil;
    end

    --Bubble Curtain
    buffer[694] = function(targetId)
        return nil;
    end

    --Big Scissors
    buffer[695] = function(targetId)
        return nil;
    end

    --Scissor Guard
    buffer[696] = function(targetId)
        return nil;
    end

    --Metallic Body
    buffer[697] = function(targetId)
        return nil;
    end

    --Needleshot
    buffer[698] = function(targetId)
        return nil;
    end

    --??? Needles
    buffer[699] = function(targetId)
        return nil;
    end

    --Frogkick
    buffer[700] = function(targetId)
        return nil;
    end

    --Spore
    buffer[701] = function(targetId)
        return nil;
    end

    --Queasyshroom
    buffer[702] = function(targetId)
        return nil;
    end

    --Numbshroom
    buffer[703] = function(targetId)
        return nil;
    end

    --Shakeshroom
    buffer[704] = function(targetId)
        return nil;
    end

    --Silence Gas
    buffer[705] = function(targetId)
        return nil;
    end

    --Dark Spore
    buffer[706] = function(targetId)
        return nil;
    end

    --Power Attack
    buffer[707] = function(targetId)
        return nil;
    end

    --Hi-Freq Field
    buffer[708] = function(targetId)
        return nil;
    end

    --Rhino Attack
    buffer[709] = function(targetId)
        return nil;
    end

    --Rhino Guard
    buffer[710] = function(targetId)
        return nil;
    end

    --Spoil
    buffer[711] = function(targetId)
        return nil;
    end

    --Cursed Sphere
    buffer[712] = function(targetId)
        return nil;
    end

    --Venom
    buffer[713] = function(targetId)
        return nil;
    end

    --Sandblast
    buffer[714] = function(targetId)
        return nil;
    end

    --Sandpit
    buffer[715] = function(targetId)
        return nil;
    end

    --Venom Spray
    buffer[716] = function(targetId)
        return nil;
    end

    --Mandibular Bite
    buffer[717] = function(targetId)
        return nil;
    end

    --Soporific
    buffer[718] = function(targetId)
        return nil;
    end

    --Gloeosuccus
    buffer[719] = function(targetId)
        return nil;
    end

    --Palsy Pollen
    buffer[720] = function(targetId)
        return nil;
    end

    --Geist Wall
    buffer[721] = function(targetId)
        return nil;
    end

    --Numbing Noise
    buffer[722] = function(targetId)
        return nil;
    end

    --Nimble Snap
    buffer[723] = function(targetId)
        return nil;
    end

    --Cyclotail
    buffer[724] = function(targetId)
        return nil;
    end

    --Toxic Spit
    buffer[725] = function(targetId)
        return nil;
    end

    --Double Claw
    buffer[726] = function(targetId)
        return nil;
    end

    --Grapple
    buffer[727] = function(targetId)
        return nil;
    end

    --Spinning Top
    buffer[728] = function(targetId)
        return nil;
    end

    --Filamented Hold
    buffer[729] = function(targetId)
        return nil;
    end

    --Chaotic Eye
    buffer[730] = function(targetId)
        return nil;
    end

    --Blaster
    buffer[731] = function(targetId)
        return nil;
    end

    --Suction
    buffer[732] = function(targetId)
        return nil;
    end

    --Drainkiss
    buffer[733] = function(targetId)
        return nil;
    end

    --Snow Cloud
    buffer[734] = function(targetId)
        return nil;
    end

    --Wild Carrot
    buffer[735] = function(targetId)
        return nil;
    end

    --Sudden Lunge
    buffer[736] = function(targetId)
        return nil;
    end

    --Spiral Spin
    buffer[737] = function(targetId)
        return nil;
    end

    --Noisome Powder
    buffer[738] = function(targetId)
        return nil;
    end

    --Acid Mist
    buffer[740] = function(targetId)
        return nil;
    end

    --TP Drainkiss
    buffer[741] = function(targetId)
        return nil;
    end

    --Scythe Tail
    buffer[743] = function(targetId)
        return nil;
    end

    --Ripper Fang
    buffer[744] = function(targetId)
        return nil;
    end

    --Chomp Rush
    buffer[745] = function(targetId)
        return nil;
    end

    --Charged Whisker
    buffer[746] = function(targetId)
        return nil;
    end

    --Purulent Ooze
    buffer[747] = function(targetId)
        return nil;
    end

    --Corrosive Ooze
    buffer[748] = function(targetId)
        return nil;
    end

    --Back Heel
    buffer[749] = function(targetId)
        return nil;
    end

    --Jettatura
    buffer[750] = function(targetId)
        return nil;
    end

    --Choke Breath
    buffer[751] = function(targetId)
        return nil;
    end

    --Fantod
    buffer[752] = function(targetId)
        return nil;
    end

    --Tortoise Stomp
    buffer[753] = function(targetId)
        return nil;
    end

    --Harden Shell
    buffer[754] = function(targetId)
        return nil;
    end

    --Aqua Breath
    buffer[755] = function(targetId)
        return nil;
    end

    --Wing Slap
    buffer[756] = function(targetId)
        return nil;
    end

    --Beak Lunge
    buffer[757] = function(targetId)
        return nil;
    end

    --Intimidate
    buffer[758] = function(targetId)
        return nil;
    end

    --Recoil Dive
    buffer[759] = function(targetId)
        return nil;
    end

    --Water Wall
    buffer[760] = function(targetId)
        return nil;
    end

    --Sensilla Blades
    buffer[761] = function(targetId)
        return nil;
    end

    --Tegmina Buffet
    buffer[762] = function(targetId)
        return nil;
    end

    --Molting Plumage
    buffer[763] = function(targetId)
        return nil;
    end

    --Swooping Frenzy
    buffer[764] = function(targetId)
        return nil;
    end

    --Sweeping Gouge
    buffer[765] = function(targetId)
        return nil;
    end

    --Zealous Snort
    buffer[766] = function(targetId)
        return nil;
    end

    --Pentapeck
    buffer[767] = function(targetId)
        return nil;
    end

    --Tickling Tendrils
    buffer[768] = function(targetId)
        return nil;
    end

    --Stink Bomb
    buffer[769] = function(targetId)
        return nil;
    end

    --Nectarous Deluge
    buffer[770] = function(targetId)
        return nil;
    end

    --Nepenthic Plunge
    buffer[771] = function(targetId)
        return nil;
    end

    --Somersault
    buffer[772] = function(targetId)
        return nil;
    end

    --Pacifying Ruby
    buffer[773] = function(targetId)
        return nil;
    end

    --Foul Waters
    buffer[774] = function(targetId)
        return nil;
    end

    --Pestilent Plume
    buffer[775] = function(targetId)
        return nil;
    end

    --Pecking Flurry
    buffer[776] = function(targetId)
        return nil;
    end

    --Sickle Slash
    buffer[777] = function(targetId)
        return nil;
    end

    --Acid Spray
    buffer[778] = function(targetId)
        return nil;
    end

    --Spider Web
    buffer[779] = function(targetId)
        return nil;
    end

    --Regal Gash
    buffer[780] = function(targetId)
        return nil;
    end

    --Infected Leech
    buffer[781] = function(targetId)
        return nil;
    end

    --Gloom Spray
    buffer[782] = function(targetId)
        return nil;
    end

    --Disembowel
    buffer[786] = function(targetId)
        return nil;
    end

    --Extirpating Salvo
    buffer[787] = function(targetId)
        return nil;
    end

    --Venom Shower
    buffer[788] = function(targetId)
        return nil;
    end

    --Mega Scissors
    buffer[789] = function(targetId)
        return nil;
    end

    --Frenzied Rage
    buffer[790] = function(targetId)
        return nil;
    end

    --Rhinowrecker
    buffer[791] = function(targetId)
        return nil;
    end

    --Fluid Toss
    buffer[792] = function(targetId)
        return nil;
    end

    --Fluid Spread
    buffer[793] = function(targetId)
        return nil;
    end

    --Digest
    buffer[794] = function(targetId)
        return nil;
    end

    --Crossthrash
    buffer[795] = function(targetId)
        return nil;
    end

    --Predatory Glare
    buffer[796] = function(targetId)
        return nil;
    end

    --Hoof Volley
    buffer[797] = function(targetId)
        return nil;
    end

    --Nihility Song
    buffer[798] = function(targetId)
        return nil;
    end

    --Clarsach Call
    buffer[960] = function(targetId)
        return nil;
    end

    --Welt
    buffer[961] = function(targetId)
        return nil;
    end

    --Katabatic Blades
    buffer[962] = function(targetId)
        return nil;
    end

    --Lunatic Voice
    buffer[963] = function(targetId)
        return nil;
    end

    --Roundhouse
    buffer[964] = function(targetId)
        return nil;
    end

    --Chinook
    buffer[965] = function(targetId)
        return nil;
    end

    --Bitter Elegy
    buffer[966] = function(targetId)
        return nil;
    end

    --Sonic Buffet
    buffer[967] = function(targetId)
        return nil;
    end

    --Tornado II
    buffer[968] = function(targetId)
        return nil;
    end

    --Wind's Blessing
    buffer[969] = function(targetId)
        return nil;
    end

    --Hysteric Assault
    buffer[970] = function(targetId)
        return nil;
    end
end

return FillAbilityTable;

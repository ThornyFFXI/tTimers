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
    [23235] = 55, --Chasseur's Gants +2
    [23570] = 60, --Chasseur's Gants +3
    [26038] = 20, --Regal Necklace
    [26262] = 30, --Camulus's Mantle
    [21482] = 20, --Compensator
};

local function CalculateBloodPactDuration(base)
    local skill = AshitaCore:GetMemoryManager():GetPlayer():GetCombatSkill(38):GetSkill();
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
    local augments = dataTracker:ParseAugments();
    duration = duration + dataTracker:EquipSum(rollDuration);
    duration = duration + (augments.PhantomRoll or 0);
    if (dataTracker:GetJobData().Main == 17) and (dataTracker:GetJobData().MainLevel >= 75) then
        local merits = dataTracker:GetMeritCount(0xC04);
        local multiplier = 20;
        if augments.Generic[0x590] then
            multiplier = 26;
        end
        duration = duration + (merits * multiplier);
        if (dataTracker:GetJobData().MainLevel == 99) then
            duration = duration + (dataTracker:GetJobPointCount(17, 2) * 2);
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
        if dataTracker:ParseAugments().Generic[0x500] then
            duration = duration + 15;
        end
        return duration, 44;
    end

    --Hundred Fists
    buffer[17] = function(targetId)
        local duration = 45;
        if dataTracker:ParseAugments().Generic[0x501] then
            duration = duration + 15;
        end
        return duration, 46;
    end

    --Manafont
    buffer[19] = function(targetId)
        local duration = 60;
        if dataTracker:ParseAugments().Generic[0x503] then
            duration = duration + 30;
        end
        return duration, 47;
    end

    --Chainspell
    buffer[20] = function(targetId)
        local duration = 60;
        if dataTracker:ParseAugments().Generic[0x504] then
            duration = duration + 20;
        end
        return duration, 48;
    end

    --Perfect Dodge
    buffer[21] = function(targetId)
        local duration = 30;
        if dataTracker:ParseAugments().Generic[0x505] then
            duration = duration + 10;
        end
        return duration, 49;
    end

    --Invincible
    buffer[22] = function(targetId)
        local duration = 30;
        if dataTracker:ParseAugments().Generic[0x506] then
            duration = duration + 10;
        end
        return duration, 50;
    end

    --Blood Weapon
    buffer[23] = function(targetId)
        local duration = 30;
        if dataTracker:ParseAugments().Generic[0x507] then
            duration = duration + 40;
        end
        return duration, 51;
    end

    --Familiar
    buffer[24] = function(targetId)
        local duration = 1800;
        if dataTracker:ParseAugments().Generic[0x508] then
            duration = duration + 600;
        end
        return duration, 0;
    end

    --Soul Voice
    buffer[25] = function(targetId)
        local duration = 180;
        if dataTracker:ParseAugments().Generic[0x509] then
            duration = duration + 30;
        end
        return duration, 52;
    end

    --Meikyo Shisui
    buffer[27] = function(targetId)
        local duration = 30;
        return duration, 54;
    end

    --Spirit Surge
    buffer[29] = function(targetId)
        local duration = 60;
        if dataTracker:ParseAugments().Generic[0x50D] then
            duration = duration + 20;
        end
        return duration, 126;
    end

    --Astral Flow
    buffer[30] = function(targetId)
        local duration = 180;
        if dataTracker:ParseAugments().Generic[0x50E] then
            duration = duration + 30;
        end
        return duration, 55;
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
        duration = duration + dataTracker:EquipSum(additiveModifiers);
        return duration, 56;
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
        duration = duration + dataTracker:EquipSum(additiveModifiers);
        return duration, 68;
    end

    --Defender
    buffer[33] = function(targetId)
        return 180, 57;
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
        duration = duration + dataTracker:EquipSum(additiveModifiers);
        return duration, 58;
    end

    --Focus
    buffer[36] = function(targetId)
        return 30, 59;
    end

    --Dodge
    buffer[37] = function(targetId)
        return 30, 60;
    end

    --Boost
    buffer[39] = function(targetId)
        --NOTE: This varies with delay and could technically be calculated.  I don't think it's a priority since you can get duration from statustimers/etc.
        return 60, 45;
    end

    --Counterstance
    buffer[40] = function(targetId)
        return 300, 61;
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
        duration = duration + dataTracker:EquipSum(additiveModifiers);
        return duration, 32;
    end

    --Hide
    buffer[43] = function(targetId)
        --NOTE: No available data on how this is calculated, and it varies.
        return 500, 76;
    end

    --Sneak Attack
    buffer[44] = function(targetId)
        return 60, 65;
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
        duration = duration * (1.0 + dataTracker:EquipSum(multipliers));
        return duration, 74;
    end

    --Sentinel
    buffer[48] = function(targetId)
        local duration = 30;
        local augments = dataTracker:ParseAugments();
        if dataTracker:GetJobData().Main == 7 and dataTracker:GetJobData().MainLevel >= 75 then
            local merits = dataTracker:GetMeritCount(0x986);
            if merits > 0 and augments.Generic[0x557] then
                duration = duration + (2 * merits);
            end
        end
        return duration, 62;
    end

    --Souleater
    buffer[49] = function(targetId)
        return 60, 63;
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
        duration = duration * (1.0 + dataTracker:EquipSum(multipliers));
        return duration, 75;
    end

    --Last Resort
    buffer[51] = function(targetId)
        local additiveModifiers = {
            [26253] = 15 --Ankou's Mantle
        };
        local duration = 180;
        duration = duration + dataTracker:EquipSum(additiveModifiers);
        return duration, 64;
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
        duration = duration + dataTracker:EquipSum(additiveModifiers);
        if dataTracker:GetJobData().Main == 11 and dataTracker:GetJobData().MainLevel == 99 then
            duration = duration + dataTracker:GetJobPointCount(11, 5);
        end
        return duration, 11;
    end

    --Camouflage
    buffer[58] = function(targetId)
        --NOTE: No available data on how this is calculated, and it varies.
        return 60, 77;
    end

    --Sharpshot
    buffer[59] = function(targetId)
        return 60, 72;
    end

    --Barrage
    buffer[60] = function(targetId)
        return 60, 73;
    end

    --Third Eye
    buffer[62] = function(targetId)
        return 30, 67;
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
        local augments = dataTracker:ParseAugments().Generic[0x4F0];
        if augments then
            for _,v in pairs(augments) do
                duration = duration + (v + 1);
            end
        end
        duration = duration + dataTracker:EquipSum(additiveModifiers);
        return duration, 0;
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
        duration = duration * (1.0 + dataTracker:EquipSum(multipliers));
        return duration, 117;
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
        duration = duration * (1.0 + dataTracker:EquipSum(multipliers));
        return duration, 118;
    end

    --Divine Seal
    buffer[74] = function(targetId)
        return 60, 78;
    end

    --Elemental Seal
    buffer[75] = function(targetId)
        return 60, 79;
    end

    --Trick Attack
    buffer[76] = function(targetId)
        return 60, 87;
    end

    --Reward
    buffer[78] = function(targetId)
        return 180, 0;
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
        duration = duration + dataTracker:EquipSum(additiveModifiers);
        return duration, 114;
    end

    --Chi Blast
    buffer[82] = function(targetId)
        if dataTracker:GetJobData().Main == 2 and dataTracker:GetJobData().MainLevel >= 75 then
            local penanceMerits = dataTracker:GetMeritCount(0x846);
            if penanceMerits > 0 then
                return penanceMerits * 20, 168;
            end
        end
        return nil;
    end

    --Unlimited Shot
    buffer[86] = function(targetId)
        return 60, 115;
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
        duration = duration + dataTracker:EquipSum(additiveModifiers);
        return duration, 623;
    end

    --Azure Lore
    buffer[93] = function(targetId)
        local duration = 30;
        if dataTracker:ParseAugments().Generic[0x50F] then
            duration = duration + 10;
        end
        return duration, 163;
    end

    --Chain Affinity
    buffer[94] = function(targetId)
        return 30, 164;
    end

    --Burst Affinity
    buffer[95] = function(targetId)
        return 30, 165;
    end

    --Fighter's Roll
    buffer[98] = function(targetId)
        return CalculateCorsairRollDuration(), 310;
    end

    --Monk's Roll
    buffer[99] = function(targetId)
        return CalculateCorsairRollDuration(), 311;
    end

    --Healer's Roll
    buffer[100] = function(targetId)
        return CalculateCorsairRollDuration(), 312;
    end

    --Wizard's Roll
    buffer[101] = function(targetId)
        return CalculateCorsairRollDuration(), 313;
    end

    --Warlock's Roll
    buffer[102] = function(targetId)
        return CalculateCorsairRollDuration(), 314;
    end

    --Rogue's Roll
    buffer[103] = function(targetId)
        return CalculateCorsairRollDuration(), 315;
    end

    --Gallant's Roll
    buffer[104] = function(targetId)
        return CalculateCorsairRollDuration(), 316;
    end

    --Chaos Roll
    buffer[105] = function(targetId)
        return CalculateCorsairRollDuration(), 317;
    end

    --Beast Roll
    buffer[106] = function(targetId)
        return CalculateCorsairRollDuration(), 318;
    end

    --Choral Roll
    buffer[107] = function(targetId)
        return CalculateCorsairRollDuration(), 319;
    end

    --Hunter's Roll
    buffer[108] = function(targetId)
        return CalculateCorsairRollDuration(), 320;
    end

    --Samurai Roll
    buffer[109] = function(targetId)
        return CalculateCorsairRollDuration(), 321;
    end

    --Ninja Roll
    buffer[110] = function(targetId)
        return CalculateCorsairRollDuration(), 322;
    end

    --Drachen Roll
    buffer[111] = function(targetId)
        return CalculateCorsairRollDuration(), 323;
    end

    --Evoker's Roll
    buffer[112] = function(targetId)
        return CalculateCorsairRollDuration(), 324;
    end

    --Magus's Roll
    buffer[113] = function(targetId)
        return CalculateCorsairRollDuration(), 325;
    end

    --Corsair's Roll
    buffer[114] = function(targetId)
        return CalculateCorsairRollDuration(), 326;
    end

    --Puppet Roll
    buffer[115] = function(targetId)
        return CalculateCorsairRollDuration(), 327;
    end

    --Dancer's Roll
    buffer[116] = function(targetId)
        return CalculateCorsairRollDuration(), 328;
    end

    --Scholar's Roll
    buffer[117] = function(targetId)
        return CalculateCorsairRollDuration(), 329;
    end

    --Bolter's Roll
    buffer[118] = function(targetId)
        return CalculateCorsairRollDuration(), 330;
    end

    --Caster's Roll
    buffer[119] = function(targetId)
        return CalculateCorsairRollDuration(), 331;
    end

    --Courser's Roll
    buffer[120] = function(targetId)
        return CalculateCorsairRollDuration(), 332;
    end

    --Blitzer's Roll
    buffer[121] = function(targetId)
        return CalculateCorsairRollDuration(), 333;
    end

    --Tactician's Roll
    buffer[122] = function(targetId)
        return CalculateCorsairRollDuration(), 334;
    end

    --Light Shot
    buffer[131] = function(targetId)
        --NOTE: Sleep buff ID not verified.
        return 60, 2;
    end

    --Overdrive
    buffer[135] = function(targetId)
        local duration = 180;
        if dataTracker:ParseAugments().Generic[0x511] then
            duration = duration + 20;
        end
        return duration, 166;
    end

    --Repair
    buffer[137] = function(targetId)
        local oilDuration = {
            [18731] = 15, --Automaton Oil
            [18732] = 30, --Automat. Oil +1
            [18733] = 45, --Automat. Oil +2
            [19185] = 60 --Automat. Oil +3
        };
        local ammo = dataTracker:GetEquippedSet()[4];
        if ammo then
            local oil = ammo.Id;
            local duration = oilDuration[oil];
            if duration then
                return duration, 0;
            end
        end
    end
    
    --Fire Maneuver
    buffer[141] = function(targetId)
        return CalculateManeuverDuration(), 300;
    end

    --Ice Maneuver
    buffer[142] = function(targetId)
        return CalculateManeuverDuration(), 301;
    end

    --Wind Maneuver
    buffer[143] = function(targetId)
        return CalculateManeuverDuration(), 302;
    end

    --Earth Maneuver
    buffer[144] = function(targetId)
        return CalculateManeuverDuration(), 303;
    end

    --Thunder Maneuver
    buffer[145] = function(targetId)
        return CalculateManeuverDuration(), 304;
    end

    --Water Maneuver
    buffer[146] = function(targetId)
        return CalculateManeuverDuration(), 305;
    end

    --Light Maneuver
    buffer[147] = function(targetId)
        return CalculateManeuverDuration(), 306;
    end

    --Dark Maneuver
    buffer[148] = function(targetId)
        return CalculateManeuverDuration(), 307;
    end

    --Warrior's Charge
    buffer[149] = function(targetId)
        return 60, 340;
    end

    --Tomahawk
    buffer[150] = function(targetId)
        local duration = 15 + (15 * dataTracker:GetMeritCount(0x802));
        return duration, 0;
    end

    --Mantra
    buffer[151] = function(targetId)
        return 180, 88;
    end

    --Formless Strikes
    buffer[152] = function(targetId)
        local duration = 180;
        if dataTracker:ParseAugments().Generic[0x537] then
            duration = duration + (6 * dataTracker:GetMeritCount(0x842));
        end
        return duration, 341;
    end

    --Assassin's Charge
    buffer[155] = function(targetId)
        return 60, 342;
    end

    --Feint
    buffer[156] = function(targetId)
        return 60, 343;
    end

    --Fealty
    buffer[157] = function(targetId)
        local duration = 60;
        if dataTracker:ParseAugments().Generic[0x555] then
            duration = duration + (4 * dataTracker:GetMeritCount(0x980));
        end
        return duration, 344;
    end

    --Dark Seal
    buffer[159] = function(targetId)
        return 60, 345;
    end

    --Diabolic Eye
    buffer[160] = function(targetId)
        local duration = 180;
        if dataTracker:ParseAugments().Generic[0x55B] then
            duration = duration + (6 * dataTracker:GetMeritCount(0x9C2));
        end
        return duration, 346;
    end

    --Killer Instinct
    buffer[162] = function(targetId)
        local duration = 170;
        local meritCount = dataTracker:GetMeritCount(0xA02);
        duration = duration + (10 * meritCount);
        if dataTracker:ParseAugments().Generic[0x560] then
            duration = duration + (4 * meritCount);
        end
        return duration, 349;
    end

    --Nightingale
    buffer[163] = function(targetId)
        local duration = 60;
        if dataTracker:ParseAugments().Generic[0x569] then
            duration = duration + (4 * dataTracker:GetMeritCount(0xA40));
        end
        return duration, 347;
    end

    --Troubadour
    buffer[164] = function(targetId)
        local duration = 60;
        if dataTracker:ParseAugments().Generic[0x567] then
            duration = duration + (4 * dataTracker:GetMeritCount(0xA42));
        end
        return duration, 348;
    end

    --Stealth Shot
    buffer[165] = function(targetId)
        return 60, 350;
    end

    --Flashy Shot
    buffer[166] = function(targetId)
        return 60, 351;
    end

    --Deep Breathing
    buffer[169] = function(targetId)
        return 180, 0;
    end

    --Angon
    buffer[170] = function(targetId)
        local duration = 15 + (15 * dataTracker:GetMeritCount(0xB42));
        return duration, 149;
    end

    --Sange
    buffer[171] = function(targetId)
        return 60, 352;
    end

    --Hasso
    buffer[173] = function(targetId)
        return 300, 353;
    end

    --Seigan
    buffer[174] = function(targetId)
        return 300, 354;
    end

    --Convergence
    buffer[175] = function(targetId)
        return 60, 355;
    end

    --Diffusion
    buffer[176] = function(targetId)
        return 60, 356;
    end

    --Snake Eye
    buffer[177] = function(targetId)
        return 60, 357;
    end

    --Trance
    buffer[181] = function(targetId)
        local duration = 60;
        if dataTracker:ParseAugments().Generic[0x512] then
            duration = duration + 20;
        end
        return duration, 376;
    end

    --Drain Samba
    buffer[184] = function(targetId)        
        local duration = 120;
        if dataTracker:GetJobData().Main == 19 and dataTracker:GetJobData().MainLevel == 99 then
            duration = duration + (2 * dataTracker:GetJobPointCount(19, 3));
        end
        return duration, 368;
    end

    --Drain Samba II
    buffer[185] = function(targetId) 
        local duration = 90;
        if dataTracker:GetJobData().Main == 19 and dataTracker:GetJobData().MainLevel == 99 then
            duration = duration + (2 * dataTracker:GetJobPointCount(19, 3));
        end
        return duration, 368;
    end

    --Drain Samba III
    buffer[186] = function(targetId) 
        local duration = 90;
        if dataTracker:GetJobData().Main == 19 and dataTracker:GetJobData().MainLevel == 99 then
            duration = duration + (2 * dataTracker:GetJobPointCount(19, 3));
        end
        return duration, 368;
    end

    --Aspir Samba
    buffer[187] = function(targetId) 
        local duration = 120;
        if dataTracker:GetJobData().Main == 19 and dataTracker:GetJobData().MainLevel == 99 then
            duration = duration + (2 * dataTracker:GetJobPointCount(19, 3));
        end
        return duration, 369;
    end

    --Aspir Samba II
    buffer[188] = function(targetId) 
        local duration = 120;
        if dataTracker:GetJobData().Main == 19 and dataTracker:GetJobData().MainLevel == 99 then
            duration = duration + (2 * dataTracker:GetJobPointCount(19, 3));
        end
        return duration, 369;
    end

    --Haste Samba
    buffer[189] = function(targetId) 
        local duration = 90;
        if dataTracker:GetJobData().Main == 19 and dataTracker:GetJobData().MainLevel == 99 then
            duration = duration + (2 * dataTracker:GetJobPointCount(19, 3));
        end
        return duration, 370;
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
        duration = duration * (1 + dataTracker:EquipSum(multipliers));
        return duration, T{69, 71};
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
        duration = duration * (1 + dataTracker:EquipSum(multipliers));
        return duration, 176;
    end
    
    --Quickstep
    buffer[201] = function(targetId)
        return CalculateStepDuration(targetId, 201), T{ 386, 387, 388, 389, 390 };
    end

    --Box Step
    buffer[202] = function(targetId)
        return CalculateStepDuration(targetId, 202), T{ 391, 392, 393, 394, 395 };
    end

    --Stutter Step
    buffer[203] = function(targetId)
        return CalculateStepDuration(targetId, 203), T{ 396, 397, 398, 399, 400 };
    end

    --Deperate Flourish
    buffer[205] = function(targetId)
        return 120, 12;
    end

    --Building Flourish
    buffer[208] = function(targetId)
        return 60, 375;
    end

    --Tabula Rasa
    buffer[210] = function(targetId)
        local duration = 180;
        if dataTracker:ParseAugments().Generic[0x513] then
            duration = duration + 30;
        end
        return duration, 377;
    end

    --Light Arts
    buffer[211] = function(targetId)
        return 7200, 358;
    end

    --Dark Arts
    buffer[212] = function(targetId)
        return 7200, 359;
    end

    --Penury
    buffer[215] = function(targetId)
        return 60, 360;
    end

    --Celerity
    buffer[216] = function(targetId)
        return 60, 362;
    end

    --Rapture
    buffer[217] = function(targetId)
        return 60, 364;
    end

    --Accession
    buffer[218] = function(targetId)
        return 60, 366;
    end

    --Parsimony
    buffer[219] = function(targetId)
        return 60, 361;
    end

    --Alacrity
    buffer[220] = function(targetId)
        return 60, 363;
    end

    --Ebullience
    buffer[221] = function(targetId)
        return 60, 365;
    end

    --Manifestation
    buffer[222] = function(targetId)
        return 60, 367;
    end

    --Velocity Shot
    buffer[224] = function(targetId)
        return 7200, 371;
    end

    --Retaliation
    buffer[226] = function(targetId)
        return 180, 405;
    end

    --Footwork
    buffer[227] = function(targetId)
        return 60, 406;
    end

    --Pianissimo
    buffer[229] = function(targetId)
        return 60, 409;
    end

    --Sekkanoki
    buffer[230] = function(targetId)
        return 60, 408;
    end

    --Sublimation
    buffer[233] = function(targetId)
        return 7200, 187;
    end

    --Addendum: White
    buffer[234] = function(targetId)
        return 7200, 401;
    end

    --Addendum: Black
    buffer[235] = function(targetId)
        return 7200, 402;
    end

    --Saber Dance
    buffer[237] = function(targetId)
        return 300, 410;
    end

    --Fan Dance
    buffer[238] = function(targetId)
        return 300, 411;
    end

    --Altruism
    buffer[240] = function(targetId)
        return 60, 412;
    end

    --Focalization
    buffer[241] = function(targetId)
        return 60, 413;
    end

    --Tranquility
    buffer[242] = function(targetId)
        return 60, 414;
    end

    --Equanimity
    buffer[243] = function(targetId)
        return 60, 415;
    end

    --Enlightenment
    buffer[244] = function(targetId)
        return 60, 416;
    end

    --Afflatus Solace
    buffer[245] = function(targetId)
        return 7200, 417;
    end

    --Afflatus Misery
    buffer[246] = function(targetId)
        return 7200, 418;
    end

    --Composure
    buffer[247] = function(targetId)
        return 7200, 419;
    end

    --Yonin
    buffer[248] = function(targetId)
        return 300, 420;
    end

    --Innin
    buffer[249] = function(targetId)
        return 300, 421;
    end

    --Avatar's Favor
    buffer[250] = function(targetId)
        return 7200, 431;
    end

    --Restraint
    buffer[252] = function(targetId)
        return 300, 435;
    end

    --Perfect Counter
    buffer[253] = function(targetId)
        return 30, 436;
    end

    --Mana Wall
    buffer[254] = function(targetId)
        return 300, 437;
    end

    --Divine Emblem
    buffer[255] = function(targetId)
        return 60, 438;
    end

    --Nether Void
    buffer[256] = function(targetId)
        return 60, 439;
    end

    --Double Shot
    buffer[257] = function(targetId)
        return 90, 433;
    end

    --Sengikori
    buffer[258] = function(targetId)
        return 60, 440;
    end

    --Futae
    buffer[259] = function(targetId)
        return 60, 441;
    end

    --Presto
    buffer[261] = function(targetId)
        return 30, 442;
    end

    --Climactic Flourish
    buffer[264] = function(targetId)
        return 60, 443;
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
        duration = duration + dataTracker:EquipSum(additiveModifiers);
        return duration, 460;
    end

    --Impetus
    buffer[269] = function(targetId)
        return 180, 461;
    end

    --Divine Caress
    buffer[270] = function(targetId)
        return 60, 459;
    end

    --Sacrosanctity
    buffer[271] = function(targetId)
        return 60, 477;
    end

    --Manawell
    buffer[273] = function(targetId)
        return 60, 229;
    end

    --Saboteur
    buffer[274] = function(targetId)
        return 60, 454;
    end

    --Spontaneity
    buffer[275] = function(targetId)
        return 60, 230;
    end

    --Conspirator
    buffer[276] = function(targetId)
        return 60, 462;
    end

    --Sepulcher
    buffer[277] = function(targetId)
        return 180, 463;
    end

    --Palisade
    buffer[278] = function(targetId)
        return 60, 478;
    end

    --Arcane Crest
    buffer[279] = function(targetId)
        return 180, 464;
    end

    --Scarlet Delirium
    buffer[280] = function(targetId)
        return 90, 479;
    end

    --Spur
    buffer[281] = function(targetId)
        return 90, 0;
    end

    --Run Wild
    buffer[282] = function(targetId)
        local duration = 300;
        if dataTracker:GetJobData().Main == 9 and dataTracker:GetJobData().MainLevel == 99 then
            duration = duration + (2 * dataTracker:GetJobPointCount(9, 8));
        end
        return duration, 0;
    end

    --Tenuto
    buffer[283] = function(targetId)
        return 60, 455;
    end

    --Marcato
    buffer[284] = function(targetId)
        return 60, 231;
    end

    --Decoy Shot
    buffer[286] = function(targetId)
        return 180, 433;
    end

    --Hamanoha
    buffer[287] = function(targetId)
        return 180, 465;
    end

    --Hagakure
    buffer[288] = function(targetId)
        return 60, 483;
    end

    --Issekigan
    buffer[291] = function(targetId)
        return 60, 484;
    end

    --Dragon Breaker
    buffer[292] = function(targetId)
        return 180, 466;
    end

    --Steady Wing
    buffer[295] = function(targetId)
        return 180, 0;
    end

    --Efflux
    buffer[297] = function(targetId)
        return 60, 457;
    end

    --Unbridled Learning
    buffer[298] = function(targetId)
        return 60, 485;
    end

    --Triple Shot
    buffer[301] = function(targetId)
        return 90, 467;
    end

    --Allies' Roll
    buffer[302] = function(targetId)
        return CalculateCorsairRollDuration(), 335;
    end

    --Miser's Roll
    buffer[303] = function(targetId)
        return CalculateCorsairRollDuration(), 336;
    end

    --Companion's Roll
    buffer[304] = function(targetId)
        return CalculateCorsairRollDuration(), 337;
    end

    --Avenger's Roll
    buffer[305] = function(targetId)
        return CalculateCorsairRollDuration(), 338;
    end

    --Feather Step
    buffer[312] = function(targetId)
        return CalculateStepDuration(targetId, 312), T{ 448, 449, 450, 451, 452 };
    end

    --Striking Flourish
    buffer[313] = function(targetId)
        return 60, 468;
    end

    --Ternary Flourish
    buffer[314] = function(targetId)
        return 60, 472;
    end

    --Perpetuance
    buffer[316] = function(targetId)
        return 60, 469;
    end

    --Immanence
    buffer[317] = function(targetId)
        return 60, 470;
    end

    --Konzen-ittai
    buffer[320] = function(targetId)
        return 60, 0;
    end

    --Bully
    buffer[321] = function(targetId)
        return 30, 22;
    end

    --Brazen Rush
    buffer[323] = function(targetId)
        return 30, 490;
    end

    --Inner Strength
    buffer[324] = function(targetId)
        return 30, 491;
    end

    --Asylum
    buffer[325] = function(targetId)
        return 30, 492;
    end

    --Subtle Sorcery
    buffer[326] = function(targetId)
        return 60, 493;
    end

    --Stymie
    buffer[327] = function(targetId)
        return 60, 494;
    end

    --Intervene
    buffer[329] = function(targetId)
        return 30, 496;
    end

    --Soul Enslavement
    buffer[330] = function(targetId)
        return 30, 493;
    end

    --Unleash
    buffer[331] = function(targetId)
        return 60, 498;
    end

    --Clarion Call
    buffer[332] = function(targetId)
        return 180, 499;
    end

    --Overkill
    buffer[333] = function(targetId)
        return 60, 500;
    end

    --Yaegasumi
    buffer[334] = function(targetId)
        return 45, 501;
    end

    --Mikage
    buffer[335] = function(targetId)
        return 45, 502;
    end

    --Fly High
    buffer[336] = function(targetId)
        return 30, 503;
    end

    --Astral Conduit
    buffer[337] = function(targetId)
        return 30, 504;
    end

    --Unbridled Wisdom
    buffer[338] = function(targetId)
        return 60, 505;
    end

    --Cutting Cards
    buffer[339] = function(targetId)
        return nil;
    end

    --Heady Artifice
    buffer[340] = function(targetId)
        --TODO: Find automaton head to determine length... (maybe pet uses command and can do it that way?)
        return 60, 0;
    end

    --Grand Pas
    buffer[341] = function(targetId)
        return 30, 507;
    end

    --Bolster
    buffer[343] = function(targetId)
        local duration = 180;
        if dataTracker:ParseAugments().Generic[0x514] then
            duration = 210;
        end
        return duration, 513;
    end

    --Collimated Fervor
    buffer[348] = function(targetId)
        return 60, 517;
    end

    --Blaze of Glory
    buffer[350] = function(targetId)
        return 60, 569;
    end

    --Dematerialize
    buffer[351] = function(targetId)
        local duration = 60;
        if dataTracker:GetJobData().Main == 21 and dataTracker:GetJobData().MainLevel == 99 then
            duration = duration + dataTracker:GetJobPointCount(21, 6);
        end
        return duration, 518;
    end

    --Theurgic Focus
    buffer[352] = function(targetId)
        return 60, 519;
    end

    --Elemental Sforzo
    buffer[356] = function(targetId)
        local duration = 30;
        if dataTracker:ParseAugments().Generic[0x515] then
            duration = 40;
        end
        return duration, 522;
    end

    --Ignis
    buffer[358] = function(targetId)
        return 300, 523;
    end

    --Gelus
    buffer[359] = function(targetId)
        return 300, 524;
    end

    --Flabra
    buffer[360] = function(targetId)
        return 300, 525;
    end

    --Tellus
    buffer[361] = function(targetId)
        return 300, 526;
    end

    --Sulpor
    buffer[362] = function(targetId)
        return 300, 527;
    end

    --Unda
    buffer[363] = function(targetId)
        return 300, 528;
    end

    --Lux
    buffer[364] = function(targetId)
        return 300, 529;
    end

    --Tenebrae
    buffer[365] = function(targetId)
        return 300, 530;
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
        duration = duration + dataTracker:EquipSum(additiveModifiers);
        if dataTracker:GetJobData().Main == 22 and dataTracker:GetJobData().MainLevel == 99 then
            duration = duration + dataTracker:GetJobPointCount(22, 3);
        end
        return duration, 531;
    end

    --Swordplay
    buffer[367] = function(targetId)
        return 120, 532;
    end

    --Pflug
    buffer[369] = function(targetId)
        return 120, 533;
    end

    --Embolden
    buffer[370] = function(targetId)
        return 60, 534;
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
        duration = duration + dataTracker:EquipSum(additiveModifiers);
        if dataTracker:GetJobData().Main == 22 and dataTracker:GetJobData().MainLevel == 99 then
            duration = duration + dataTracker:GetJobPointCount(22, 3);
        end
        return duration, 535;
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
        duration = duration + dataTracker:EquipSum(additiveModifiers);
        if dataTracker:GetJobData().Main == 22 and dataTracker:GetJobData().MainLevel == 99 then
            duration = duration + dataTracker:GetJobPointCount(22, 9);
        end
        return duration, 536;
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
        duration = duration + dataTracker:EquipSum(additiveModifiers);
        return duration, 537;
    end

    --One for All
    buffer[374] = function(targetId)
        local duration = 30;
        if dataTracker:GetJobData().Main == 22 and dataTracker:GetJobData().MainLevel == 99 then
            duration = duration + dataTracker:GetJobPointCount(22, 8);
        end
        return duration, 538;
    end

    --Rayke
    buffer[375] = function(targetId)
        local merits = dataTracker:GetMeritCount(0xD82);
        local duration = 27 + (merits * 3);
        if dataTracker:ParseAugments().Generic[0x515] then
            duration = duration + merits;
        end
        return duration, 571;
    end

    --Battuta
    buffer[376] = function(targetId)
        return 90, 570;
    end

    --Widened Compass
    buffer[377] = function(targetId)
        return 60, 508;
    end

    --Odyllic Subterfuge
    buffer[378] = function(targetId)
        return 30, 509;
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
        duration = duration * (1 + dataTracker:EquipSum(multipliers));
        return duration, 176;
    end

    --Contradance
    buffer[384] = function(targetId)
        return 60, 582;
    end

    --Apogee
    buffer[385] = function(targetId)
        return 60, 583;
    end

    --Entrust
    buffer[386] = function(targetId)
        return 60, 584;
    end

    --Cascade
    buffer[388] = function(targetId)
        return 60, 598;
    end

    --Consume Mana
    buffer[389] = function(targetId)
        return 60, 599;
    end

    --Naturalist's Roll
    buffer[390] = function(targetId)
        return CalculateCorsairRollDuration(), 339;
    end

    --Runeist's Roll
    buffer[391] = function(targetId)
        return CalculateCorsairRollDuration(), 600;
    end

    --Crooked Cards
    buffer[392] = function(targetId)
        return 60, 601;
    end

    --Spirit Bond
    buffer[393] = function(targetId)
        return 180, 619;
    end

    --Majesty
    buffer[394] = function(targetId)
        return 180, 621;
    end

    --Hover Shot
    buffer[395] = function(targetId)
        return 3600, 628;
    end

    --Shining Ruby
    buffer[514] = function(targetId)
        return CalculateBloodPactDuration(180), 154;
    end

    --Glittering Ruby
    buffer[515] = function(targetId)
        return CalculateBloodPactDuration(180), 0;
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
        return 3600, 113;
    end

    --Ecliptic Growl
    buffer[532] = function(targetId)
        return CalculateBloodPactDuration(180), T{80, 81, 82, 83, 84, 85, 86 };
    end

    --Ecliptic Howl
    buffer[533] = function(targetId)
        return CalculateBloodPactDuration(180), T{ 90, 92 };
    end

    --Heavenward Howl
    buffer[538] = function(targetId)
        return CalculateBloodPactDuration(60), T{ 487, 488 };
    end

    --Crimson Howl
    buffer[548] = function(targetId)
        return CalculateBloodPactDuration(60), 68;
    end

    --Inferno Howl
    buffer[553] = function(targetId)
        return CalculateBloodPactDuration(60), 94;
    end

    --Conflag Strike
    buffer[554] = function(targetId)
        return 60, 128;
    end

    --[[UNKNOWN
    --Rock Throw
    buffer[560] = function(targetId)
        return nil;
    end
    ]]--
    
    --Rock Buster
    buffer[562] = function(targetId)
        return 30, 11;
    end

    --[[UNKNOWN
    --Megalith Throw
    buffer[563] = function(targetId)
        return nil;
    end
    ]]--

    --Earthen Ward
    buffer[564] = function(targetId)
        return 900, 37;
    end

    --[[UNKNOWN
    --Mountain Buster
    buffer[566] = function(targetId)
        return nil;
    end
    ]]--

    --Earthen Armor
    buffer[569] = function(targetId)
        return CalculateBloodPactDuration(60), 458;
    end

    --Crag Throw
    buffer[570] = function(targetId)
        return 120, 13;
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
        return 90, 147;
    end

    --Soothing Current
    buffer[586] = function(targetId)
        return CalculateBloodPactDuration(180), 586;
    end

    --Hastega
    buffer[595] = function(targetId)
        return CalculateBloodPactDuration(180), 33;
    end

    --Aerial Armor
    buffer[596] = function(targetId)
        return 900, 36;
    end

    --Fleet Wind
    buffer[601] = function(targetId)
        return CalculateBloodPactDuration(120), 176;
    end

    --Hastega II
    buffer[602] = function(targetId)
        return CalculateBloodPactDuration(180), 33;
    end

    --Frost Armor
    buffer[610] = function(targetId)
        return CalculateBloodPactDuration(180), 35;
    end

    --Sleepga
    buffer[611] = function(targetId)
        return 90, 2;
    end

    --Diamond Storm
    buffer[617] = function(targetId)
        return 180, 148;
    end

    --Crystal Blessing
    buffer[618] = function(targetId)
        return CalculateBloodPactDuration(180), 587;
    end

    --Rolling Thunder
    buffer[626] = function(targetId)
        return CalculateBloodPactDuration(120), 98;
    end

    --Lightning Armor
    buffer[628] = function(targetId)
        return CalculateBloodPactDuration(180), 38;
    end

    --Shock Squall
    buffer[633] = function(targetId)
        return 15, 10;
    end

    --Volt Strike
    buffer[634] = function(targetId)
        return 15, 10;
    end

    --Nightmare
    buffer[658] = function(targetId)
        return 90, 2;
    end
    
    --Noctoshield
    buffer[660] = function(targetId)
        return CalculateBloodPactDuration(180), 116;
    end

    --Dream Shroud
    buffer[661] = function(targetId)
        return CalculateBloodPactDuration(180), T { 190, 191 };
    end

    --Perfect Defense
    buffer[671] = function(targetId)
        local summoning = AshitaCore:GetMemoryManager():GetPlayer():GetCombatSkill(38):GetSkill();
        return 30 + math.floor(summoning / 20), 283;
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

return Initialize;

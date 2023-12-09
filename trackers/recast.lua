local AbilityRecastPointer = ashita.memory.find('FFXiMain.dll', 0, '894124E9????????8B46??6A006A00508BCEE8', 0x19, 0);
AbilityRecastPointer = ashita.memory.read_uint32(AbilityRecastPointer);

local abilityBlocks = T{
    92, --Second entry for rune enchantment..?
};
local overrides = {
    [0] = 'One-Hour Ability',
    [10] = 'Rune Enchantment',
    [254] = 'Secondary One-Hour',
};

local function update_job(job)
    local primary = {
        [1] = 'Mighty Strikes',
        [2] = 'Hundred Fists',
        [3] = 'Benediction',
        [4] = 'Manafont',
        [5] = 'Chainspell',
        [6] = 'Perfect Dodge',
        [7] = 'Invincible',
        [8] = 'Blood Weapon',
        [9] = 'Familiar',
        [10] = 'Soul Voice',
        [11] = 'Eagle Eye Shot',
        [12] = 'Meikyo Shisui',
        [13] = 'Mijin Gakure',
        [14] = 'Spirit Surge',
        [15] = 'Astral Flow',
        [16] = 'Azure Lore',
        [17] = 'Wild Card',
        [18] = 'Overdrive',
        [19] = 'Trance',
        [20] = 'Tabula Rasa',
        [21] = 'Bolster',
        [22] = 'Elemental Sforzo'
    };
    local secondary = {
        [1] = 'Brazen Rush',
        [2] = 'Inner Strength',
        [3] = 'Asylum',
        [4] = 'Subtle Sorcery',
        [5] = 'Stymie',
        [6] = 'Larceny',
        [7] = 'Intervene',
        [8] = 'Soul Enslavement',
        [9] = 'Unleash',
        [10] = 'Clarion Call',
        [11] = 'Overkill',
        [12] = 'Yaegasumi',
        [13] = 'Mikage',
        [14] = 'Fly High',
        [15] = 'Astral Conduit',
        [16] = 'Unbridled Wisdom',
        [17] = 'Cutting Cards',
        [18] = 'Heady Artifice',
        [19] = 'Grand Pas',
        [20] = 'Caper Emissarius',
        [21] = 'Widened Compass',
        [22] = 'Odyllic Subterfuge'
    };
    overrides[0] = primary[job] or 'Primary One-Hour';
    overrides[254] = secondary[job] or 'Secondary One-Hour';
end

local function get_ready_data(index)
    local modifier = ashita.memory.read_int16(AbilityRecastPointer + (index * 8) + 4);
    local baseRecast = 3 * (90 + modifier);
    local chargeValue = baseRecast / 3;
    return baseRecast, chargeValue;
end

local function get_quick_draw_data(index)
    local modifier = ashita.memory.read_int16(AbilityRecastPointer + (index * 8) + 4);
    local baseRecast = 120 + modifier;
    local chargeValue = baseRecast / 2;
    return baseRecast, chargeValue;
end

local function get_stratagem_count()
    local player = AshitaCore:GetMemoryManager():GetPlayer();
    local lvl = (player:GetMainJob() == 20) and player:GetMainJobLevel() or player:GetSubJobLevel();
    if (lvl == 0) then
        return 2;
    end
    return math.floor((lvl - 10) / 20) + 1;
end

local function get_stratagem_data(index)
    local modifier = ashita.memory.read_int16(AbilityRecastPointer + (index * 8) + 4);    
    local baseRecast = 240 + modifier;
    local chargeValue = baseRecast / get_stratagem_count();
    return baseRecast, chargeValue;
end

local function timer_to_string(timer)
    if (timer <= 0) then
        return 'Ready';
    end

    if (timer < 60) then
        return string.format('%u.%u', math.floor(timer), math.fmod(timer * 10, 10));
    else
        return string.format('%u:%02u', math.floor(timer / 60), math.floor(math.fmod(timer, 60)));
    end
end

local tracker = {};
local state = {
    AbilityTimers = T{},
    ActiveTimers = T{},
    SpellTimers = T{},
    Reset = 0,
};

function tracker:Initialize()
    state.SpellTimers = T{};
    local mmRecast    = AshitaCore:GetMemoryManager():GetRecast();
    local resMgr      = AshitaCore:GetResourceManager();
    local time        = os.clock();

    --Only initial spell update should parse all spells.
    --Remaining updates will use this list + any spell action completions to avoid extensive queries.
    for x = 0, 1024 do
        local timer = mmRecast:GetSpellTimer(x);
        if (timer > 0) then
            local res = resMgr:GetSpellById(x);
            local label = res and res.Name[1] or string.format('Unknown Spell [%u]', x);
            state.SpellTimers[x] = {
                Label = label,
            };
        end
    end
    
    state.AbilityTimers = T{};
    update_job(AshitaCore:GetMemoryManager():GetPlayer():GetMainJob());
end

local function GetAbilityLabel(id)
    local override = overrides[id];
    if override then
        return override;
    end

    local resMgr = AshitaCore:GetResourceManager();
    local res = resMgr:GetAbilityByTimerId(id);
    if res then
        return res.Name[1];
    end
    
    for x = 0x200,0x6FF do
        res = resMgr:GetAbilityById(x);
        if (res) and (res.RecastTimerId == id) then
            return res.Name[1];
        end
    end

    return string.format('Unknown Ability [%u]', id);
end

function tracker:UpdateAbilities()
    local mmRecast  = AshitaCore:GetMemoryManager():GetRecast();
    local time      = os.clock();
    local activeIds = T{};

    -- Obtain the players ability recasts..
    for x = 0, 31 do
        local id = mmRecast:GetAbilityTimerId(x);
        -- Ensure the ability is valid and has a current recast timer..
        if (id ~= 0 or x == 0) and not (abilityBlocks:contains(id)) then
            activeIds:append(id);
            local ability = state.AbilityTimers[id];
            local timer = mmRecast:GetAbilityTimer(x);
            local duration = timer / 60;
            if ability == nil then
                ability = {
                    Creation = time;
                    Duration = duration,
                    TotalDuration = duration,
                    Label = GetAbilityLabel(id),
                    Local = {},
                    Expiration = time + duration,
                }
                if (timer == 0) then
                    ability.Expired = true;
                    ability.Hide = true;
                end
                state.AbilityTimers[id] = ability;
            else
                if (timer > 0) then
                    if (ability.ExpirationTime) then
                        ability.ExpirationTime = nil;
                        ability.Delete = nil;
                        ability.Hide = nil;
                        ability.Creation = time;
                    end
                    if (duration > ability.TotalDuration) then
                        ability.TotalDuration = duration;
                    end
                    ability.Duration = duration;
                else
                    if (ability.ExpirationTime == nil) then
                        ability.ExpirationTime = os.clock();
                    end
                    ability.Duration = ability.ExpirationTime - os.clock();
                end
            end


            -- Determine the name to be displayed..
            if (x == 0) then
                ability.Label = overrides[0];
            elseif (id == 102) then
                local baseRecast, chargeValue = get_ready_data(x);
                local charges = math.floor((baseRecast - duration) / chargeValue);
                local maxCharges = baseRecast / chargeValue;
                local nextCharge = math.fmod(ability.Duration, chargeValue)
                ability.Label = string.format('Ready[%u]', charges);
                if (ability.ExpirationTime == nil) then
                    ability.Duration = nextCharge;
                    ability.Tooltip = string.format('Current Charges: %u/%u\nNext Charge: %s\nFull Charges: %s',
                        charges, baseRecast / chargeValue, timer_to_string(nextCharge), timer_to_string(duration)
                    );
                else
                    ability.Tooltip = string.format('Full Charges(%u/%u)', maxCharges, maxCharges);
                end
                ability.TotalDuration = chargeValue;
            elseif (id == 195) then
                local baseRecast, chargeValue = get_quick_draw_data(x);
                local charges = math.floor((baseRecast - duration) / chargeValue);
                local maxCharges = baseRecast / chargeValue;
                local nextCharge = math.fmod(ability.Duration, chargeValue)
                ability.Label = string.format('Quick Draw[%u]', charges);
                if (ability.ExpirationTime == nil) then
                    ability.Duration = nextCharge;
                    ability.Tooltip = string.format('Current Charges: %u/%u\nNext Charge: %s\nFull Charges: %s',
                        charges, baseRecast / chargeValue, timer_to_string(nextCharge), timer_to_string(duration)
                    );
                else
                    ability.Tooltip = string.format('Full Charges(%u/%u)', maxCharges, maxCharges);
                end
                ability.TotalDuration = chargeValue;
            elseif (id == 231) then
                local baseRecast, chargeValue = get_stratagem_data(x);
                local charges = math.floor((baseRecast - duration) / chargeValue);
                local maxCharges = baseRecast / chargeValue;
                local nextCharge = math.fmod(ability.Duration, chargeValue)
                ability.Label = string.format('Stratagems[%u]', charges);
                if (ability.ExpirationTime == nil) then
                    ability.Duration = nextCharge;
                    ability.Tooltip = string.format('Current Charges: %u/%u\nNext Charge: %s\nFull Charges: %s',
                        charges, maxCharges, timer_to_string(nextCharge), timer_to_string(duration)
                    );
                else
                    ability.Tooltip = string.format('Full Charges(%u/%u)', maxCharges, maxCharges);
                end
                ability.TotalDuration = chargeValue;
            elseif (id == 254) then
                ability.Label = overrides[254];
            end
        end
    end



    for id,ability in pairs(state.AbilityTimers) do
        if (activeIds:contains(id)) then
            if (not ability.Hide) then
                state.ActiveTimers:append(ability);
            end
        else
            ability.Expired = true;
            ability.Hide = true;
        end
    end
end

function tracker:UpdateSpells()
    local mmRecast  = AshitaCore:GetMemoryManager():GetRecast();
    local time      = os.clock();
    -- Obtain the players ability recasts..
    for id,spell in pairs(state.SpellTimers) do
        local timer = mmRecast:GetSpellTimer(id);
        local duration = timer / 60;

        if (spell.Creation == nil) then
            spell.Creation = time;
            spell.Duration = duration;
            spell.TotalDuration = duration;
            spell.Local = {};
            spell.Expiration = time + duration;
            
            if (timer == 0) then
                spell.Expired = true;
                spell.Hide = true;
            end
        else
            if (duration > 0) then
                if (spell.ExpirationTime) then
                    spell.ExpirationTime = nil;
                    spell.Delete = nil;
                    spell.Hide = nil;
                    spell.Creation = time;
                end
                if (duration > spell.TotalDuration) then
                    spell.TotalDuration = duration;
                end
                spell.Duration = duration;
            else
                if (not spell.ExpirationTime) then
                    spell.ExpirationTime = os.clock();
                end
                spell.Duration = spell.ExpirationTime - os.clock();
            end
        end
    end

    for id,spell in pairs(state.SpellTimers) do
        if (not spell.Hide) then
            state.ActiveTimers:append(spell);
        end
    end
end

function tracker:Tick()
    state.ActiveTimers = state.ActiveTimers:each(function(a)
        if (a.Delete == true) then
            a.Delete = nil;
            a.Hide = true;
        end
    end);
    state.ActiveTimers = T{};
    self:UpdateAbilities();
    self:UpdateSpells();
    return state.ActiveTimers;
end

function tracker:HandleIncomingPacket(e)
    if (e.id == 0x00A) then
        update_job(struct.unpack('B', e.data, 0xB4 + 1));
    elseif (e.id == 0x01B) then
        update_job(struct.unpack('B', e.data, 0x08 + 1));
    elseif (e.id == 0x061) then
        update_job(struct.unpack('B', e.data, 0x0C + 1));
    end
    
    if (e.id == 0x28) then
        if (struct.unpack('L', e.data, 0x05 + 1) == AshitaCore:GetMemoryManager():GetParty():GetMemberServerId(0)) then
            -- Action is spell start..
            if (ashita.bits.unpack_be(e.data_raw, 10, 2, 4) == 4) then
                local actionId = ashita.bits.unpack_be(e.data_raw, 10, 6, 10);
                local res = AshitaCore:GetResourceManager():GetSpellById(actionId);
                local label = res and res.Name[1] or string.format('Unknown Spell [%u]', actionId);
                state.SpellTimers[actionId] = {
                    Label = label,
                };
            end
        end
    end
end

tracker:Initialize();
return tracker;
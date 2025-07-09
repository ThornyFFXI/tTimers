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

--Libs
local durations = require('durations.include');
local encoding = require('gdifonts.encoding');
local actionPacket = require('actionpacket');
local buffFlags = require('buffflags');

--Constants..
local pRealTime = ashita.memory.find('FFXiMain.dll', 0, '8B0D????????8B410C8B49108D04808D04808D04808D04C1C3', 2, 0);
local abilityTypes = T{ 6, 14, 15 };

local actionMessages = T{
    Death = T{ 6, 20, 113, 406, 605, 646 },
    Expired = T{ 206 },
    Applied = T{ 100, 115, 205, 230, 266, 280, 319, 420, 421, 424, 425, 667 },
};
local rolls = T{ 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 302, 303, 304, 305, 390, 391 };
local buffOverrides = T{
};

--[[    
    timerData
    Data must contain the following members:
    Creation [os.clock()]
    Duration (number) - Time until timer expires, in seconds.
    TotalDuration (number) - Total duration of timer.
    Label [string]
    Local [table] - Table for storing items at scope of timer.  Member 'Delete' is reserved, and if set to true, removes the timer.
    Expiration [os.clock()]

    Data can optionally contain:
    Tooltip [string]
    Icon [string]
]]--

--[[
    buffData (stored in buffsByAction and buffsByTarget)
        ActionType(string) - Ability, Item, MobSkill, Spell, Weaponskill
        ActionId(number) - Action ID for resource lookups.
        Resource(ISpell/IAbility) - Resource for triggering action.
        BuffId(number) - Buff ID.
        Texture(string) - Texture.
        Targets(table) - List of effected players.
            Id(number) - Target ID.
            Creation(number) - Time the buff was created at.
            Delete(boolean) - Flag to true to clear on next render.
            Duration(number) - Initial duration.
            Expiration(number) - Time the buff expires.
            Name(string) - Name of the target.
]]
local activeTimers = T{};
local buffsByAction = {};
local buffsByTarget = {};
local pendingRoll = T { Time = -80 };
local rebuildTimers = false;


-- Clear any conflicting buffs from table.
local function ClearConflicts(targetId, buffId)
    local entry = buffsByTarget[targetId];
    if not entry then
        entry = T{};
        buffsByTarget[targetId] = entry;
        return entry;
    end

    --Clear all other instances of this buff..
    local flags = buffFlags[buffId];
    if (flags == nil) or (not flags.MultipleInstance) then
        for _,buffData in ipairs(entry) do
            if (buffData.BuffId == buffId) then
                local target = buffData.Targets[targetId];
                if target then
                    target.Delete = true;
                end
            end
        end
    end

    if (flags) then
        --Clear all conflicting buffs..
        for _,override in ipairs(flags.Override) do
            for _,buffData in ipairs(entry) do
                if (buffData.BuffId == override) then
                    local target = buffData.Targets[targetId];
                    if target then
                        target.Delete = true;
                    end
                end
            end
        end
    end

    return entry;
end


local defaultPaths = T{
    ['Ability'] = 'abilities/default.png',
    ['Item'] = 'items/default.png',
    ['Spell'] = 'spells/default.png',
    ['MobAbility'] = 'mobskills/default.png',
    ['MobSkill'] = 'mobskills/default.png',
    ['Weaponskill'] = 'weaponskills/default.png'
};
-- Determine the texture to be used for a given action.
local function GetActionIcon(actionTable)
    local override = buffOverrides[actionTable.Key];
    if (override) then
        if GetFilePath(override) then
            actionTable.Icon = override;
            return;
        end
    end

    if (actionTable.BuffId ~= nil) and (actionTable.BuffId > 0) then
        actionTable.Icon = string.format('STATUS:%u', actionTable.BuffId);
        return;
    end

    local defaultPath = defaultPaths[actionTable.ActionType];
    if defaultPath and GetFilePath(defaultPath) then
        actionTable.Icon = defaultPath;
    end
end

local function GetActionName(actionTable)
    local type = actionTable.ActionType;
    if (type == 'Ability') then
        local res = AshitaCore:GetResourceManager():GetAbilityById(actionTable.ActionId + 512);
        if (res) then
            actionTable.Name = encoding:ShiftJIS_To_UTF8(res.Name[1]);
        else
            actionTable.Name = string.format('Ability[%u]', actionTable.ActionId);
        end
        return;
    end
    
    if (type == 'Item') then
        local res = AshitaCore:GetResourceManager():GetItemById(actionTable.ActionId);
        if (res) then
            actionTable.Name = encoding:ShiftJIS_To_UTF8(res.Name[1]);
        else
            actionTable.Name = string.format('Item[%u]', actionTable.ActionId);
        end
        return;
    end
    
    if (type == 'MobAbility') then
        local res = AshitaCore:GetResourceManager():GetAbilityById(actionTable.ActionId + 512);
        if (res) then
            actionTable.Name = encoding:ShiftJIS_To_UTF8(res.Name[1]);
        else
            actionTable.Name = string.format('MobAbility[%u]', actionTable.ActionId);
        end
        return;
    end

    if (type == 'MobSkill') then
        local res = AshitaCore:GetResourceManager():GetString('monsters.abilities', actionTable.ActionId);
        if (res) then
            actionTable.Name = encoding:ShiftJIS_To_UTF8(res.Name[1]);
        else
            actionTable.Name = string.format('MobSkill[%u]', actionTable.ActionId);
        end
        return;
    end
    
    if (type == 'Spell') then
        local res = AshitaCore:GetResourceManager():GetSpellById(actionTable.ActionId);
        if (res) then
            actionTable.Name = encoding:ShiftJIS_To_UTF8(res.Name[1]);
        else
            actionTable.Name = string.format('Spell[%u]', actionTable.ActionId);
        end
        return;
    end
    
    if (type == 'Weaponskill') then
        local res = AshitaCore:GetResourceManager():GetAbilityById(actionTable.ActionId);
        if (res) then
            actionTable.Name = encoding:ShiftJIS_To_UTF8(res.Name[1]);
        else
            actionTable.Name = string.format('Weaponskill[%u]', actionTable.ActionId);
        end
        return;
    end
end

local function PlayerIdToName(id)
    local entity = AshitaCore:GetMemoryManager():GetEntity();
    for i = 0x400,0x8FF do
        if (entity:GetServerId(i) == id) then
            return entity:GetName(i);
        end
    end
    return 'Unknown';
end

local function RecordBuff(targetId, actionType, actionId, buffId, duration)
    local playerTable = ClearConflicts(targetId, buffId);
    local key = string.format('%s:%u', actionType, actionId);

    local actionTable = buffsByAction[key];
    if not actionTable then
        actionTable = {};
        actionTable.ActionType = actionType;
        actionTable.ActionId = actionId;
        actionTable.BuffId = buffId;
        actionTable.Key = key;
        actionTable.Targets = T{};
        GetActionName(actionTable);
        GetActionIcon(actionTable);
        buffsByAction[key] = actionTable;
    end

    local target = actionTable.Targets[targetId];
    if not target then
        target = {};
        target.Id = targetId;
        target.Name = PlayerIdToName(targetId);
        actionTable.Targets[targetId] = target;
    end

    target.Creation = os.clock();
    target.Delete = false;
    target.Duration = duration;
    target.Expiration = os.clock() + duration;
    rebuildTimers = true;

    for _,entry in ipairs(playerTable) do
        if (entry == actionTable) then
            return;
        end
    end
    playerTable:append(actionTable);
end

local function HandleSpellComplete(packet)
    for _,target in ipairs(packet.Targets) do
        for _,action in ipairs(target.Actions) do
            if (actionMessages.Applied:contains(action.Message)) then
                local duration, buffId = durations:GetSpellDuration(packet.Id, target.Id);
                if type(buffId) == 'table' then
                    buffId = buffId[1];
                end

                if duration then
                    RecordBuff(target.Id, 'Spell', packet.Id, buffId, duration);
                end
            end
        end
    end
end

local function HandleAbilityComplete(packet)
    for _,target in ipairs(packet.Targets) do
        for _,action in ipairs(target.Actions) do
            if (actionMessages.Applied:contains(action.Message)) then
                local duration, buffId = durations:GetAbilityDuration(packet.Id, target.Id);
                
                if (rolls:contains(packet.Id)) then
                    if (packet.Id == pendingRoll.ActionId) and (pendingRoll.Time + 48 > os.clock()) then
                        duration = pendingRoll.Duration - (os.clock() - pendingRoll.Time);
                        buffId = pendingRoll.Buff;
                        packet.Id = pendingRoll.ActionId;
                    else
                        pendingRoll.Time = os.clock();
                        pendingRoll.Duration = duration;
                        pendingRoll.Buff = buffId;
                        pendingRoll.ActionId = packet.Id;
                    end
                end

                if type(buffId) == 'table' then
                    buffId = buffId[1];
                end

                if duration then
                    RecordBuff(target.Id, 'Ability', packet.Id, buffId, duration);
                end
            end
        end
    end    
end

local function HandlePartyBuffs(packet)
    local now = os.clock();
    for i = 0,4 do
        local memberOffset = 0x04 + (0x30 * i) + 1;
        local memberId = struct.unpack('L', packet.data, memberOffset);
        
        local entry = buffsByTarget[memberId];
        if entry then
            local buffs = T{};
            for j = 0,31 do
                local highBits = bit.lshift(ashita.bits.unpack_be(packet.data_raw, memberOffset + 7, j * 2, 2), 8);
                local lowBits = struct.unpack('B', packet.data, memberOffset + 0x10 + j);
                local buff = highBits + lowBits;
                if (buff == 255) then
                    break;
                else
                    buffs[j + 1] = buff;
                end
            end

            --Clear any buff timers that have had the member's buff removed..
            for _,buffData in ipairs(entry) do
                if (buffData.BuffId ~= 0) and (not buffs:contains(buffData.BuffId)) then
                    local target = buffData.Targets[memberId];
                    if target then
                        local timeDiff = now - target.Creation;
                        if (timeDiff > 0.2) then
                            target.Creation = now - target.Duration;
                            target.Expiration = now;
                            rebuildTimers = true;
                        end
                    end
                end
            end
        end
    end
end

local function GetRealTime()
    local ptr = ashita.memory.read_uint32(pRealTime);
    ptr = ashita.memory.read_uint32(ptr);
    return ashita.memory.read_uint32(ptr + 0x0C);
end
local function CalculateBuffDuration(value)
    --Get the time since vanadiel epoch
    local offset = GetRealTime() - 0x3C307D70;

    --Multiply it by 60 to create like terms
    local comparand = offset * 60;

    --Get actual time remaining
    local real_duration = value - comparand;
    
    while (real_duration < -2147483648) do
        real_duration = real_duration + 0xFFFFFFFF;
    end
    
    if (real_duration < 0) then
        return 0;
    end
    
    --Convert to seconds
    return real_duration / 60;
end
local function UpdateDuration(buffId, expirationTime, newExpirationTime)
    local now = os.clock();
    for action,actionTable in pairs(buffsByAction) do
        if (actionTable.BuffId == buffId) then
            for targetId,target in pairs(actionTable.Targets) do
                local timeDiff = now - target.Creation;
                if (timeDiff < 2) and (math.abs(target.Expiration - expirationTime) < 2) then
                    target.Expiration = newExpirationTime;
                    target.TotalDuration = (newExpirationTime - now) + timeDiff;
                    rebuildTimers = true;
                end
            end
        end
    end
end
local oldBuffTimers = T{};
local function HandleBuffTimers(packet)
    local myId = durations:GetDataTracker():GetPlayerId();
    local entry = buffsByTarget[myId];
    if not entry then
        return;
    end

    local now = os.clock();
    
    local buffs = T{ };

    for i = 1,32 do
        local buff = struct.unpack('H', packet.data, 0x06 + (i * 2) + 1);
        if (buff == 0) and (buffs:countf(function(b) return b.ID == 0 end) > 0) then
            return;
        end
        if buff ~= 0xFF then
            buff = T { ID=buff };
            buff.Duration = CalculateBuffDuration(struct.unpack('L', packet.data, 0x44 + (i * 4) + 1));
            buff.Expiration = os.clock() + buff.Duration;
            buff.New = true;
            for key,buffEntry in pairs(oldBuffTimers) do
                if (buffEntry.ID == buff.ID) and (math.abs(buffEntry.Expiration - buff.Expiration) < 2) then
                    buff.New = false;
                    oldBuffTimers[key] = nil;
                    break;
                end
            end
            buffs:append(buff);
        end
    end

    for _,buff in ipairs(buffs) do
        if (buff.New) then
            --Look for buffs applied less than 2 seconds ago to force duration..            
            for _,buffData in ipairs(entry) do
                if buffData.BuffId == buff.ID then
                    local target = buffData.Targets[myId];
                    if target then
                        local timeDiff = now - target.Creation;
                        if (timeDiff < 2) then
                            UpdateDuration(buffData.BuffId, target.Expiration, buff.Expiration);
                            if pendingRoll.BuffId == buff.ID then
                                pendingRoll.Duration = (target.Expiration - pendingRoll.Time);
                            end
                        end
                    end
                end
            end
        end
    end

    --Clear any buff timers that have had the member's buff removed..
    for _,buffData in ipairs(entry) do
        if (buffData.BuffId ~= 0) and (buffs:countf(function(b) return b.ID == buffData.BuffId end) == 0) then
            local target = buffData.Targets[myId];
            if target then
                local timeDiff = now - target.Creation;
                if (timeDiff > 0.2) and (now < target.Expiration) then
                    target.Creation = now - target.Duration;
                    target.Expiration = now;
                    rebuildTimers = true;
                end
            end
        end
    end
    oldBuffTimers = buffs;
end
local function HandleBuffCancel(buff, targetId)
    local flags = buffFlags[buff];
    if (flags) and (flags.MultipleInstance) then
        return;
    end
    
    local entry = buffsByTarget[targetId];
    if entry then
        local now = os.clock();
        for _,buffData in ipairs(entry) do
            if buffData.BuffId == buff then
                local target = buffData.Targets[targetId];
                if target then
                    target.Creation = now - target.Duration;
                    target.Expiration = now;
                    rebuildTimers = true;
                end
            end
        end
    end
end
local function HandlePlayerDeath(targetId)
    local entry = buffsByTarget[targetId];
    if entry then
        for _,buffData in ipairs(entry) do
            local target = buffData.Targets[targetId];
            if target then
                target.Expiration = 0;
                rebuildTimers = true;
            end
        end
    end
end

local function CheckDistance(index)
    local distance = AshitaCore:GetMemoryManager():GetEntity():GetDistance(index);
    if (distance ~= 0) and (distance < 1225) then
        return true;
    end
end
ashita.events.register('packet_in', 'buff_tracker_handleincomingpacket', function (e)
    if (e.id == 0x00D) then
        local flags = struct.unpack('B', e.data, 0x0A + 1);
        if (bit.band(flags, 0x20) == 0x20) and (CheckDistance(struct.unpack('H', e.data, 0x08 + 1))) then
            HandlePlayerDeath(struct.unpack('L', e.data, 0x04 + 1));
        elseif (bit.band(flags, 0x04) == 0x04) then
            local hp = struct.unpack('B', e.data, 0x1E + 1);
            if (hp == 0) then
                HandlePlayerDeath(struct.unpack('L', e.data, 0x04 + 1));
            end
        end
    end
    if (e.id == 0x00E) then
        local index = struct.unpack('H', e.data, 0x08 + 1);
        if (index >= 0x700) then
            local flags = struct.unpack('B', e.data, 0x0A + 1);
            if (bit.band(flags, 0x20) == 0x20) and (CheckDistance(index)) then
                HandlePlayerDeath(struct.unpack('L', e.data, 0x04 + 1));
            elseif (bit.band(flags, 0x04) == 0x04) then
                local hp = struct.unpack('B', e.data, 0x1E + 1);
                if (hp == 0) then
                    HandlePlayerDeath(struct.unpack('L', e.data, 0x04 + 1));
                end
            end
        end
    end


    if (e.id == 0x028) then
        local packet = actionPacket:parse(e);
        local trackAction = (packet.UserId == durations:GetDataTracker():GetPlayerId());
        if (trackAction == false) then
            if (gSettings.Buff.TrackMode == 'All Players') then
                local ent = AshitaCore:GetMemoryManager():GetEntity();
                for i = 0x400,0x6FF do
                    if (ent:GetServerId(i) == packet.UserId) then
                        trackAction = true;
                    end
                end
            elseif (gSettings.Buff.TrackMode == 'Party Only') then
                local party = AshitaCore:GetMemoryManager():GetParty();
                for i = 1,5 do
                    if (party:GetMemberIsActive(i) == 1) and (party:GetMemberServerId(i) == packet.UserId) then
                        trackAction = true;
                    end
                end
            end
        end

        if (trackAction) then
            --Spell Completion
            if (packet.Type == 4) then
                HandleSpellComplete(packet);
            end

            if (abilityTypes:contains(packet.Type)) then
                HandleAbilityComplete(packet);
            end
        end
    end

    if (e.id == 0x29) then
        local messageId = bit.band(struct.unpack('H', e.data, 0x18 + 1), 0x7FFF);
        
        if (actionMessages.Death:contains(messageId)) then
            HandlePlayerDeath(struct.unpack('L', e.data, 0x08 + 1));
        end

        if (actionMessages.Expired:contains(messageId)) then
            HandleBuffCancel(struct.unpack('H', e.data, 0x0C + 1), struct.unpack('L', e.data, 0x08 + 1));
        end
    end

    if (e.id == 0x63) and (struct.unpack('B', e.data, 0x04 + 1) == 9) then
        HandleBuffTimers(e);
    end
    
    if (e.id == 0x076) then
        HandlePartyBuffs(e);
    end
end);

local function TimeToString(timer)
    if (timer >= 3600) then
        local h = math.floor(timer / 3600);
        local m = math.floor(math.fmod(timer, 3600) / 60);
        return string.format('%i:%02i', h, m);
    else
        local m = math.floor(timer / 60);
        local s = math.floor(math.fmod(timer, 60));
        return string.format('%02i:%02i', m, s);
    end
end

local function ClearDeletedTimers()
    for _,timer in ipairs(activeTimers) do
        --Clear timers that have been deleted via UI..
        if (timer.Local.Delete) then
            for _,targetEntry in ipairs(timer.Players) do
                targetEntry.Delete = true;
            end
            if (timer.Local.Block) then
                gSettings.Buff.Blocked[timer.Key] = true;
                settings.save();
                timer.Local.Block = nil;
                print(chat.header('tTimers') .. chat.message('Blocked Buff: ' .. timer.Key));
            end
            rebuildTimers = true;
        else
            --Flag a rebuild if timers have any expired members..
            local duration = timer.Players[1].Expiration - os.clock();
            if ((duration * -1) > gSettings.Buff.CompletionDuration) then
                for _,player in ipairs(timer.Players) do
                    duration = player.Expiration - os.clock();
                    if ((duration * -1) > gSettings.Buff.CompletionDuration) then
                        player.Delete = true;
                    end
                end
                rebuildTimers = true;
            end
        end
    end

    --Clear buffs and members..
    for key,buffData in pairs(buffsByAction) do
        local memberRemains = false;
        for id,player in pairs(buffData.Targets) do
            if (player.Delete) then
                buffData.Targets[id] = nil;
                rebuildTimers = true;
            else
                memberRemains = true;
            end
        end
        if not memberRemains then
            buffsByAction[key] = nil;
            rebuildTimers = true;
        end
    end

    --Clear entries from player table..
    for id,buffTable in pairs(buffsByTarget) do
        buffsByTarget[id] = buffTable:filteri(function(v)
            local myEntry = v.Targets[id];
            return (myEntry) and (myEntry.Delete ~= true);
        end);
    end
end

local function CreateTimer(buffData)
    local playerArray = T{};
    for playerId,data in pairs(buffData.Targets) do
        playerArray:append(data);
    end

    table.sort(playerArray, function(a,b)
        if (a.Expiration == b.Expiration) then
            return a.Name < b.Name;
        end
        return (a.Expiration < b.Expiration);
    end);


    local toolTipText;
    if (playerArray[2]) then
        toolTipText = '';
        for _,entry in ipairs(playerArray) do
            local timeRemaining = math.max(entry.Expiration - os.clock(), 0);
            local newLine = string.format('%s%-20s %s', (toolTipText == '') and '' or '\n', entry.Name, TimeToString(timeRemaining));
            toolTipText = toolTipText .. newLine;
        end
    end

    local count = #playerArray;
    local shortest = playerArray[1];
    
    local timerData = {};
    timerData.Creation = shortest.Creation;
    timerData.TotalDuration = shortest.Duration;
    timerData.Expiration = shortest.Expiration;
    timerData.Duration = math.max(timerData.Expiration - os.clock(), 0);
    timerData.Icon = buffData.Icon;
    if (count > 1) then
        timerData.Label = string.format('%s[%s+%u]', buffData.Name, shortest.Name, count-1);
    else
        timerData.Label = string.format('%s[%s]', buffData.Name, shortest.Name);
    end
    timerData.Local = {};
    timerData.Players = playerArray;
    timerData.Key = buffData.Key;
    timerData.Tooltip = toolTipText;
    activeTimers:append(timerData);
end

local function CreateSplitTimers(buffData)
    local timers = T{};
    for id,target in pairs(buffData.Targets) do
        local targetTimer;
        for _,timer in ipairs(timers) do
            if (math.abs(timer.Expiration - target.Expiration) < 2) then
                targetTimer = timer;
                break;
            end
        end
        if not targetTimer then
            targetTimer = {
                BuffId = buffData.BuffId,
                Icon = buffData.Icon,
                Expiration = target.Expiration,
                Name = buffData.Name,
                Key = buffData.Key,
                Targets = {},
            };
            timers:append(targetTimer);
        end
        targetTimer.Targets[id] = target;
    end
    for _,timer in ipairs(timers) do
        CreateTimer(timer);
    end
end

--Split out all buff timers by resource key, then sort them out into new timers.
local function RebuildTimers(splitByDuration)
    activeTimers = T{};

    for key,buffData in pairs(buffsByAction) do
        if (gSettings.Buff.Blocked[key] == nil) then
            if splitByDuration then
                CreateSplitTimers(buffData);
            else
                CreateTimer(buffData);
            end
        end
    end
end

local function UpdateTimer(timerData)
    timerData.Duration = math.max(timerData.Expiration - os.clock(), 0);
    if (timerData.Players[2]) then
        local toolTipText = '';
        for _,entry in ipairs(timerData.Players) do
            local timeRemaining = math.max(entry.Expiration - os.clock(), 0);
            local newLine = string.format('%s%-20s %s', (toolTipText == '') and '' or '\n', entry.Name, TimeToString(timeRemaining));
            toolTipText = toolTipText .. newLine;
        end
        timerData.Tooltip = toolTipText;
    else
        timerData.Tooltip = nil;
    end
end

local exports = {};

local lastSetting;
function exports:Tick()
    ClearDeletedTimers();

    if (rebuildTimers) or (gSettings.Buff.SplitByDuration ~= lastSetting) then
        lastSetting = gSettings.Buff.SplitByDuration;
        RebuildTimers(lastSetting);
        rebuildTimers = false;
    else
        for _,timerData in ipairs(activeTimers) do
            UpdateTimer(timerData);
        end
    end
    
    return activeTimers;
end

return exports;

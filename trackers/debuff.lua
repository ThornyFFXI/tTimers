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
local abilityTypes = T{ 6, 14, 15 };
local actionMessages = T{
    Death = T{ 6, 20, 113, 406, 605, 646 },
    Expired = T{ 64, 204, 206, 350, 351 },
    Damage = T{ 2, 110, 252, 317 },
    Steps = T{ 519, 520, 521, 591 },
    Applied = T{ 127, 203, 236, 237, 268, 270, 271 },
};
local dotPriority = T{
    [232] = 6,
    [25] = 5,
    [231] = 4,
    [24] = 3,
    [230] = 2,
    [23] = 1,
    [33] = 1,
};
local debuffOverrides = T{
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
    local override = debuffOverrides[actionTable.Key];
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

local function MonsterIdToName(id)
    local entity = AshitaCore:GetMemoryManager():GetEntity();
    local index = bit.band(id, 0x7FF);
    if (entity:GetServerId(index) ~= id) then
        index = 0;
        for i = 0x001,0x3FF do
            if (entity:GetServerId(i) == id) then
                index = i;
            end
        end
        for i = 0x700,0x8FF do
            if (entity:GetServerId(i) == id) then
                index = i;
            end
        end
    end

    if (index == 0) then
        return 'Unknown';
    elseif (gSettings.Debuff.ShowMobIndex) then
        return string.format('%s 0x%03X', entity:GetName(index), index);
    else
        return entity:GetName(index);
    end
end

local function RecordDebuff(targetId, actionType, actionId, buffId, duration)
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
        target.Name = MonsterIdToName(targetId);
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

local function HandleDiaBio(targetId, actionType, actionId, buffId, duration)
    local entry = buffsByTarget[targetId];
    if entry then
        local now = os.clock();
        local value = dotPriority[actionId];
        for _,buffData in pairs(entry) do
            if (buffData.ActionType == 'Spell') then
                local buffValue = dotPriority[buffData.ActionId];
                if (buffValue ~= nil) then
                    if buffData.Targets[targetId].Expiration > now then
                        if (buffValue >= value) then
                            return;
                        else
                            local target = buffData.Targets[targetId];
                            if target then
                                target.Delete = true;
                            end
                        end
                    end
                end
            end
        end
    end
    
    RecordDebuff(targetId, actionType, actionId, buffId, duration);
end

local stepBuffIds = T{
    [201] = 386,
    [202] = 391,
    [203] = 396,
    [312] = 448,
}
local function HandleStep(targetId, actionId)
    local mods = 0;
    local tracker = durations:GetDataTracker();
    if (tracker:GetJobData().Main == 19) then
        mods = tracker:GetJobPointCount(19, 1);
    end

    local entry = buffsByTarget[targetId];
    if entry then
        for _,buffData in pairs(entry) do
            if (buffData.ActionType == 'Ability') and (buffData.ActionId == actionId) then
                local target = buffData.Targets[targetId];
                if target then
                    local duration = 60;
                    local remainingDuration = target.Expiration - os.clock();
                    if remainingDuration > 0 then
                        duration = remainingDuration + 30 + mods;
                        if (duration > (120 + mods)) then
                            duration = 120 + mods; --Verify whether mods actually allow you more than 2min duration..
                        end
                    end
                    target.Creation = os.clock();
                    target.Duration = duration;
                    target.Expiration = os.clock() + duration;
                    rebuildTimers = true;
                    return;
                end
            end
        end
    end
    
    RecordDebuff(targetId, 'Ability', actionId, stepBuffIds[actionId], 60 + mods);
end

local function HandleSpellComplete(packet)
    for _,target in ipairs(packet.Targets) do
        for _,action in ipairs(target.Actions) do
            local messageId = action.Message;
            if (actionMessages.Applied:contains(messageId)) or (actionMessages.Damage:contains(messageId)) then
                local duration, buffId = durations:GetSpellDuration(packet.Id, target.Id);
                if duration then
                    if type(buffId) == 'table' then
                        buffId = buffId[1];
                    end

                    local dotPrio = dotPriority[packet.Id];
                    if dotPrio then
                        HandleDiaBio(target.Id, 'Spell', packet.Id, buffId, duration);
                    else
                        RecordDebuff(target.Id, 'Spell', packet.Id, buffId, duration);
                    end
                end
            end
        end
    end
end

local function HandleAbilityComplete(packet)
    for _,target in ipairs(packet.Targets) do
        for _,action in ipairs(target.Actions) do
            if (actionMessages.Steps:contains(action.Message)) then
                HandleStep(target.Id, packet.Id, action.Param);
            elseif (actionMessages.Applied:contains(action.Message)) then
                local duration, buffId = durations:GetAbilityDuration(packet.Id, target.Id);

                if type(buffId) == 'table' then
                    buffId = buffId[1];
                end

                if duration then
                    RecordDebuff(target.Id, 'Ability', packet.Id, buffId, duration);
                end
            end
        end
    end    
end

local function HandleDebuffExpiration(buff, targetId)
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

local function HandleEnemyDeath(targetId)
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
ashita.events.register('packet_in', 'debuff_tracker_handleincomingpacket', function (e)
    if (e.id == 0x00E) then
        local flags = struct.unpack('B', e.data, 0x0A + 1);
        if (bit.band(flags, 0x20) == 0x20) and (CheckDistance(struct.unpack('H', e.data, 0x08 + 1))) then
            HandleEnemyDeath(struct.unpack('L', e.data, 0x04 + 1));
        elseif (bit.band(flags, 0x04) == 0x04) then
            local hp = struct.unpack('B', e.data, 0x1E + 1);
            if (hp == 0) then
                HandleEnemyDeath(struct.unpack('L', e.data, 0x04 + 1));
            end
        end
    end

    if (e.id == 0x028) then
        local packet = actionPacket:parse(e);
        local trackAction = (packet.UserId == durations:GetDataTracker():GetPlayerId());
        if (trackAction == false) then
            if (gSettings.Debuff.TrackMode == 'All Players') then
                local ent = AshitaCore:GetMemoryManager():GetEntity();
                for i = 0x400,0x6FF do
                    if (ent:GetServerId(i) == packet.UserId) then
                        trackAction = true;
                    end
                end
            elseif (gSettings.Debuff.TrackMode == 'Party Only') then
                local party = AshitaCore:GetMemoryManager():GetParty();
                for i = 1,5 do
                    if (party:GetMemberIsActive(i) == 1) and (party:GetMemberServerId(i) == packet.UserId) then
                        trackAction = true;
                    end
                end
            elseif (gSettings.Debuff.TrackMode == 'Alliance Only') then
                local party = AshitaCore:GetMemoryManager():GetParty();
                for i = 1,17 do
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
            HandleEnemyDeath(struct.unpack('L', e.data, 0x08 + 1));
        end
        if (actionMessages.Expired:contains(messageId)) then
            HandleDebuffExpiration(struct.unpack('H', e.data, 0x0C + 1), struct.unpack('L', e.data, 0x08 + 1));
        end
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
            for _,targetEntry in ipairs(timer.Targets) do
                targetEntry.Delete = true;
            end
            if (timer.Local.Block) then
                gSettings.Debuff.Blocked[timer.Key] = true;
                settings.save();
                timer.Local.Block = nil;
                print(chat.header('tTimers') .. chat.message('Blocked Debuff: ' .. timer.Key));
            end
            rebuildTimers = true;
        else
            --Flag a rebuild if timers have any expired members..
            local duration = timer.Targets[1].Expiration - os.clock();
            if ((duration * -1) > gSettings.Debuff.CompletionDuration) then
                for _,player in ipairs(timer.Targets) do
                    duration = player.Expiration - os.clock();
                    if ((duration * -1) > gSettings.Debuff.CompletionDuration) then
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
    local targetArray = T{};
    for playerId,data in pairs(buffData.Targets) do
        targetArray:append(data);
    end

    table.sort(targetArray, function(a,b)
        if (a.Expiration == b.Expiration) then
            return a.Name < b.Name;
        end
        return (a.Expiration < b.Expiration);
    end);


    local toolTipText;
    if (targetArray[2]) then
        toolTipText = '';
        for _,entry in ipairs(targetArray) do
            local timeRemaining = math.max(entry.Expiration - os.clock(), 0);
            local newLine = string.format('%s%-20s %s', (toolTipText == '') and '' or '\n', entry.Name, TimeToString(timeRemaining));
            toolTipText = toolTipText .. newLine;
        end
    end

    local count = #targetArray;
    local shortest = targetArray[1];
    
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
    timerData.Targets = targetArray;
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
        if (gSettings.Debuff.Blocked[key] == nil) then
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
    if (timerData.Targets[2]) then
        local toolTipText = '';
        for _,entry in ipairs(timerData.Targets) do
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

    if (rebuildTimers) or (gSettings.Debuff.SplitByDuration ~= lastSetting) then
        lastSetting = gSettings.Debuff.SplitByDuration;
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
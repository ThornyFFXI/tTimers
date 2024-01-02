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
local action = require('actionpacket');
local buffFlags = require('buffflags');

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
    buffData
        Resource(ISpell/IAbility) - Resource for triggering action.
        BuffId(number) - Buff ID.
        Texture(string) - Texture.
        LinkedTimers(table) - List of linked timers.
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
local rebuildTimers = false;

-- Clear any conflicting buffs from table.
local function ClearConflicts(targetId, actionResource, buffId)
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

-- Determine the texture to be used for a given action.
local function GetActionIcon(actionResource, buffId)
    local target;
    if (actionResource.Index) then
        if (gSettings.Buff.SpellIconList:contains(actionResource.Index)) then
            target = string.format('spells/%u.png', actionResource.Index);
        end
    elseif (actionResource.Id < 512) then
        if (gSettings.Buff.WeaponskillIconList:contains(actionResource.Id)) then
            target = string.format('weaponskills/%u.png', actionResource.Id);
        end
    elseif (gSettings.Buff.AbilityIconList:contains(actionResource.RecastTimerId)) then
        target = string.format('abilities/%u_%u.png', actionResource.RecastTimerId, durations:GetDataTracker():GetJobData().MainJob);
        if not GetFilePath(target) then
            target = string.format('abilities/%u.png', actionResource.RecastTimerId);            
        end
    end

    if (target == nil) or (not GetFilePath(target)) then
        target = string.format('STATUS:%u', buffId);
    end
    return target;
end

local function IdToName(id)
    local entity = AshitaCore:GetMemoryManager():GetEntity();
    for i = 0,0x900 do
        if (entity:GetServerId(i) == id) then
            return entity:GetName(i);
        end
    end
    return 'Unknown';
end

local function RecordBuff(targetId, actionResource, buffId, duration)
    local playerTable = ClearConflicts(targetId, actionResource, buffId);

    local key = actionResource.Index and string.format('Spell:%u', actionResource.Index) or string.format('Ability:%u', actionResource.Id);
    local actionTable = buffsByAction[key];
    if not actionTable then
        actionTable = {};
        actionTable.Resource = actionResource;
        actionTable.BuffId = buffId;
        actionTable.LinkedTimers = T{};
        actionTable.Icon = GetActionIcon(actionResource, buffId);
        actionTable.Targets = T{};
        buffsByAction[key] = actionTable;
    end

    local target = actionTable.Targets[targetId];
    if not target then
        target = {};
        target.Id = targetId;
        target.Name = IdToName(targetId);
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


local buffAppliedMessages = T{ 205, 230, 266, 280, 319 };
local function HandleSpellComplete(packet)
    for _,target in ipairs(packet.Targets) do
        for _,action in ipairs(target.Actions) do
            if (buffAppliedMessages:contains(action.Message)) then
                local duration, buffId = durations:GetSpellDuration(packet.Id, target.Id);
                if type(buffId) == 'table' then
                    buffId = buffId[1];
                end

                if duration then
                    local res = AshitaCore:GetResourceManager():GetSpellById(packet.Id);
                    RecordBuff(target.Id, res, buffId, duration);
                end
            end
        end
    end
end

local function HandleAbilityComplete(packet)

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
                if not buffs:contains(buffData.BuffId) then
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

local pRealTime = ashita.memory.find('FFXiMain.dll', 0, '8B0D????????8B410C8B49108D04808D04808D04808D04C1C3', 2, 0);
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
local function HandleBuffTimers(packet)
    local myId = durations:GetDataTracker():GetPlayerId();
    local entry = buffsByTarget[myId];
    if not entry then
        return;
    end

    local now = os.clock();
    local buffs = T{};

    for i = 1,32 do
        local buff = struct.unpack('H', packet.data, 0x06 + (i * 2) + 1);
        if buff ~= 0xFF then
            buffs:append(buff);
        end

        --Look for buffs applied less than 2 seconds ago to force duration..
        local duration = CalculateBuffDuration(struct.unpack('L', packet.data, 0x44 + (i * 4) + 1));
        
        for _,buffData in ipairs(entry) do
            if buffData.BuffId == buff then
                local target = buffData.Targets[myId];
                if target then
                    local timeDiff = now - target.Creation;
                    if (timeDiff < 2) then
                        target.Expiration = now + duration;
                        target.TotalDuration = timeDiff + duration;
                        rebuildTimers = true;
                    end
                end
            end
        end
    end

    --Clear any buff timers that have had the member's buff removed..
    for _,buffData in ipairs(entry) do
        if not buffs:contains(buffData.BuffId) then
            local target = buffData.Targets[myId];
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


local abilityTypes = T{ 6, 14, 15 };
ashita.events.register('packet_in', 'buff_tracker_handleincomingpacket', function (e)
    --TODO: If player is dead, clear their buffs.


    if (e.id == 0x028) then
        local packet = action:parse(e);

        if (packet.UserId == durations:GetDataTracker():GetPlayerId()) then        
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
        local msg = bit.band(struct.unpack('H', e.data, 0x18 + 1), 0x7FFF);
        if (msg == 206) then
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
        timerData.Label = string.format('%s[%s+%u]', encoding:ShiftJIS_To_UTF8(buffData.Resource.Name[1]), shortest.Name, (count - 1));
    else
        timerData.Label = string.format('%s[%s]', encoding:ShiftJIS_To_UTF8(buffData.Resource.Name[1]), shortest.Name);
    end
    timerData.Local = {};
    timerData.Players = playerArray;
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
                Resource = buffData.Resource,
                BuffId = buffData.BuffId,
                Icon = buffData.Icon,
                Expiration = target.Expiration,
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
        if splitByDuration then
            CreateSplitTimers(buffData);
        else
            CreateTimer(buffData);
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

    if (rebuildTimers) or (gSettings.Buff.SplitBuffsByDuration ~= lastSetting) then
        lastSetting = gSettings.Buff.SplitBuffsByDuration;
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
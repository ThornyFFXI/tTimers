--[[
* Addons - Copyright (c) 2021 Ashita Development Team
* Contact: https://www.ashitaxi.com/
* Contact: https://discord.gg/Ashita
*
* This file is part of Ashita.
*
* Ashita is free software: you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
*
* Ashita is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with Ashita.  If not, see <https://www.gnu.org/licenses/>.
--]]

--[[
* Serializer selectively removed from settings library.
]]--
require('common');

--[[
* Returns true if the given key is considered valid based on its type.
*
* @param {any} k - The key to check.
* @return {boolean} True if valid, false otherwise.
--]]
local function is_valid_key(k)
    return switch(type(k), {
        ['boolean'] = function () return true; end,
        ['number'] = function () return true; end,
        ['string'] = function () return true; end,
        [switch.default] = function () return false; end,
    });
end

--[[
* Serializes a key to a clean value that is save-safe.
*
* @param {any} k - The key to check.
* @return {string} The prepared key for serialization.
--]]
local function serialize_key(k)
    return switch(type(k), {
        ['boolean'] = function ()
            return tostring(k);
        end,
        ['number'] = function ()
            -- Handle infinite number conditions..
            local snum = { [tostring(1/0)] = '1/0', [tostring(-1/0)] = '-1/0', [tostring(0/0)] = '0/0', };
            return snum[tostring(k)] or ("%.17g"):format(k);
        end,
        ['string'] = function ()
            return ('%q'):fmt(k):gsub('\010', 'n'):gsub('\026', '\\026');
        end,
        [switch.default] = function ()
            error('Invalid key type being serialized.');
        end,
    });
end

--[[
* Processes a settings table, converting it to a string to be written to disk. (Recursive!)
*
* @param {table} s - The settings table to process.
* @param {string} p - The parent level string to prepend to any configurations to be saved.
* @return {table, string} A table containing all found parent strings to be used to initialize sub-tables. The configuration data converted to a string.
--]]
local function process_settings(s, p)
    local parents = T{ };
    local ret = '';

    -- Process the table converting values to a valid string representation..
    for k, v in pairs(s) do
        -- Recursively handle tables..
        if (type(v) == 'table') then
            -- Prepare the key..
            local key = '[' + serialize_key(k) + ']';

            -- Store the table path as a parent..
            local parent = (p or ''):append(key);
            parents:insert(#parents + 1, parent);

            -- Process the table..
            local ip, is = process_settings(v, parent);
            if (#ip > 0) then
                ip:each(function (pv)
                    parents:insert(#parents + 1, pv);
                end);
            end

            -- Append the processed values..
            ret = ret:append(is);
        else
            if (is_valid_key(k)) then
                -- Prepare the key..
                local key = '[' + serialize_key(k) + ']';

                -- Process valid non-table values..
                switch(type(v), {
                    ['boolean'] = function ()
                        ret = ret:append(('%s = %s;\n'):fmt((p or ''):append(key), tostring(v)));
                    end,
                    ['number'] = function ()
                        -- Handle infinite number conditions..
                        local snum = { [tostring(1/0)] = '1/0', [tostring(-1/0)] = '-1/0', [tostring(0/0)] = '0/0', };
                        ret = ret:append(('%s = %s;\n'):fmt((p or ''):append(key), snum[tostring(v)] or ("%.17g"):format(v)));
                    end,
                    ['string'] = function ()
                        ret = ret:append(('%s = %s;\n'):fmt((p or ''):append(key), ('%q'):fmt(v):gsub('\010', 'n'):gsub('\026', '\\026')));
                    end,

                    -- Consider all other Lua types as non-valid settings data..
                    [switch.default] = function ()
                        error(('[%s] Unsupported data type detected while serializing file: %s -- %s'):fmt(addon.name, (p or ''):append(key), type(v)));
                    end
                });
            end
        end
    end

    return parents, ret;
end

local function Serialize(file, input, name)
    -- Process the settings table for storage on disk..
    local p, s = process_settings(input, name);

    -- Open the settings file for writing..
    local f = io.open(file, 'w+');
    if (f == nil) then
        return false;
    end

    -- Write the settings information..
    f:write('require(\'common\');\n\n');
    f:write(string.format('local %s = T{ };\n', name));
    p:each(function (v) f:write(('%s = T{ };\n'):fmt(v)); end);
    f:write(s);
    f:write(string.format('\nreturn %s;\n', name));
    f:close();
end

local exports = T{
    Serialize = Serialize,
}

return exports;
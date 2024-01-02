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

local chat = require('chat');

function Error(text)
    local stripped = string.gsub(text, '$H', ''):gsub('$R', '');
    LogManager:Log(1, addon.name, stripped);
    local color = ('\30%c'):format(68);
    local highlighted = color .. string.gsub(text, '$H', '\30\01\30\02');
    highlighted = string.gsub(highlighted, '$R', '\30\01' .. color);
    print(chat.header(addon.name) .. highlighted .. '\30\01');
end

function GetFilePath(path)
    local potentialPaths = T{
        path,
        string.format('%sconfig/addons/%s/resources/%s', AshitaCore:GetInstallPath(), addon.name, path),
        string.format('%saddons/%s/resources/%s', AshitaCore:GetInstallPath(), addon.name, path),
    };

    for _,potentialPath in ipairs(potentialPaths) do
        if (potentialPath ~= '') and (ashita.fs.exists(potentialPath)) then
            return potentialPath;
        end
    end
end

function GetImagePath(image, default)
    if (string.sub(image, 1, 5) == 'ITEM:') then
        return image;
    end
    
    if (string.sub(image, 1, 7) == 'STATUS:') then
        return image;
    end
    
    local potentialPaths = T{
        image,
        string.format('%sconfig/addons/%s/resources/%s', AshitaCore:GetInstallPath(), addon.name, image),
        string.format('%saddons/%s/resources/%s', AshitaCore:GetInstallPath(), addon.name, image),
    };

    for _,path in ipairs(potentialPaths) do
        if (path ~= '') and (ashita.fs.exists(path)) then
            return path;
        end
    end

    return nil;
end

function Message(text)
    local stripped = string.gsub(text, '$H', ''):gsub('$R', '');
    LogManager:Log(5, addon.name, stripped);
    local color = ('\30%c'):format(106);
    local highlighted = color .. string.gsub(text, '$H', '\30\01\30\02');
    highlighted = string.gsub(highlighted, '$R', '\30\01' .. color);
    print(chat.header(addon.name) .. highlighted .. '\30\01');
end

function LoadFile_s(filePath)
    if (filePath == nil) then
        return nil;
    end
    
    if not ashita.fs.exists(filePath) then
        return nil;
    end

    local success, loadError = loadfile(filePath);
    if not success then
        Error(string.format('Failed to load resource file: $H%s', filePath));
        if type(loadError) == 'string' then
            Error(loadError);
        end
        return nil;
    end

    local result, output = pcall(success);
    if not result then
        Error(string.format('Failed to execute resource file: $H%s', filePath));
        if type(output) == 'string' then
            Error(output);
        end
        return nil;
    end

    return output;
end
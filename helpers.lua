local chat = require('chat');

function Error(text)
    local stripped = string.gsub(text, '$H', ''):gsub('$R', '');
    LogManager:Log(1, addon.name, stripped);
    local color = ('\30%c'):format(68);
    local highlighted = color .. string.gsub(text, '$H', '\30\01\30\02');
    highlighted = string.gsub(highlighted, '$R', '\30\01' .. color);
    print(chat.header(addon.name) .. highlighted .. '\30\01');
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
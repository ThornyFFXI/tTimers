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

local d3d8 = require('d3d8');
local d3d8_device = d3d8.get_device();
local ffi = require('ffi');
local TextureCache = {};
TextureCache.ItemCache = {};
TextureCache.ImageCache = {};
TextureCache.StatusCache = {};

function TextureCache:Clear()
    self.ItemCache = {};
    self.ImageCache = {};
    self.StatusCache = {};
end

function TextureCache:GetTexture(file)
    if (string.sub(file, 1, 5) == 'ITEM:') then
        local itemId = tonumber(string.sub(file, 6));
        if type(itemId) ~= 'number' then
            return;
        end

        local tx = self.ItemCache[itemId]
        if tx then
            return tx;
        end

        local item = AshitaCore:GetResourceManager():GetItemById(itemId);
        if (item == nil) then
            return;
        end

        local dx_texture_ptr = ffi.new('IDirect3DTexture8*[1]');
        if (ffi.C.D3DXCreateTextureFromFileInMemoryEx(d3d8_device, item.Bitmap, item.ImageSize, 0xFFFFFFFF, 0xFFFFFFFF, 1, 0, ffi.C.D3DFMT_A8R8G8B8, ffi.C.D3DPOOL_MANAGED, ffi.C.D3DX_DEFAULT, ffi.C.D3DX_DEFAULT, 0xFF000000, nil, nil, dx_texture_ptr) == ffi.C.S_OK) then
            local texture = d3d8.gc_safe_release(ffi.cast('IDirect3DTexture8*', dx_texture_ptr[0]));
            local result, desc = texture:GetLevelDesc(0);
            if result == 0 then
                tx = {};
                tx.Texture = texture;
                tx.Width   = desc.Width;
                tx.Height  = desc.Height;
                self.ItemCache[itemId] = tx;
                return tx;
            end
            return;
        end
    end
    
    if (string.sub(file, 1, 7) == 'STATUS:') then
        local statusId = tonumber(string.sub(file, 8));
        if type(statusId) ~= 'number' then
            return;
        end

        local tx = self.StatusCache[statusId]
        if tx then
            return tx;
        end
        
        local status = AshitaCore:GetResourceManager():GetStatusIconByIndex(statusId);
        if (status == nil) then
            return;
        end


        local dx_texture_ptr = ffi.new('IDirect3DTexture8*[1]');
        if (ffi.C.D3DXCreateTextureFromFileInMemoryEx(d3d8_device, status.Bitmap, -1, 0xFFFFFFFF, 0xFFFFFFFF, 1, 0, ffi.C.D3DFMT_A8R8G8B8, ffi.C.D3DPOOL_MANAGED, ffi.C.D3DX_DEFAULT, ffi.C.D3DX_DEFAULT, 0xFF000000, nil, nil, dx_texture_ptr) == ffi.C.S_OK) then
            local texture = d3d8.gc_safe_release(ffi.cast('IDirect3DTexture8*', dx_texture_ptr[0]));
            local result, desc = texture:GetLevelDesc(0);
            if result == 0 then
                tx = {};
                tx.Texture = texture;
                tx.Width   = desc.Width;
                tx.Height  = desc.Height;
                self.StatusCache[statusId] = tx;
                return tx;
            end
            return;
        end
    end

    local tx = self.ImageCache[file];
    if tx then
        return tx;
    end

    local path = GetImagePath(file);
    if (path ~= nil) then
        local dx_texture_ptr = ffi.new('IDirect3DTexture8*[1]');
        if (ffi.C.D3DXCreateTextureFromFileA(d3d8_device, path, dx_texture_ptr) == ffi.C.S_OK) then
            local texture = d3d8.gc_safe_release(ffi.cast('IDirect3DTexture8*', dx_texture_ptr[0]));
            local result, desc = texture:GetLevelDesc(0);
            if result == 0 then
                tx = {};
                tx.Texture = texture;
                tx.Width   = desc.Width;
                tx.Height  = desc.Height;
                self.ImageCache[file] = tx;
                return tx;
            end
            return;
        end
    end
end

return TextureCache;
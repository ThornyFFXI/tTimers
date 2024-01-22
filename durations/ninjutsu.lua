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

local function Initialize(tracker, buffer)
    dataTracker = tracker;

    --Monomi: Ichi
    buffer[318] = function(targetId)
        return 120;
    end

    --Utsusemi: Ichi
    buffer[338] = function(targetId)
        return 900;
    end

    --Utsusemi: Ni
    buffer[339] = function(targetId)
        return 900;
    end

    --Utsusemi: San
    buffer[340] = function(targetId)
        return 900;
    end

	--Aisha: Ichi
	buffer[319] = function(targetId)
		return 120;
	end

    --[[UNKNOWN
	--Jubaku: Ichi
	buffer[341] = function(targetId)
		return 0;
	end
    ]]--

    --[[UNKNOWN
	--Hojo: Ichi
	buffer[344] = function(targetId)
		return 0;
	end
    ]]--

    --[[UNKNOWN
	--Hojo: Ni
	buffer[345] = function(targetId)
		return 0;
	end
    ]]--

    --[[UNKNOWN
	--Kurayami: Ichi
	buffer[347] = function(targetId)
		return 0;
	end
    ]]--

    --[[UNKNOWN
	--Kurayami: Ni
	buffer[348] = function(targetId)
		return 0;
	end
    ]]--

    --[[UNKNOWN
	--Dokumori: Ichi
	buffer[350] = function(targetId)
		return 60;
	end
    ]]--

    --Tonko: Ichi
    buffer[353] = function(targetId)
        return 180;
    end

    --Tonko: Ni
    buffer[354] = function(targetId)
        return 300;
    end
    
    --Gekka: Ichi
    buffer[505] = function(targetId)
        return 180;
    end
    
    --Yain: Ichi
    buffer[506] = function(targetId)
        return 300;
    end
    
    --Myoshu: Ichi
    buffer[507] = function(targetId)
        return 300;
    end
    
    --[[UNKNOWN
    --Yurin: Ichi
	buffer[508] = function(targetId)
		return 0;
	end
    ]]--

    --Kakka: Ichi
    buffer[509] = function(targetId)
        return 300;
    end    
    
    --Migawari: Ichi
    buffer[510] = function(targetId)
        return 60;
    end
end

return Initialize;
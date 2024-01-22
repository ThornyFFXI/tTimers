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

	--Banish
	buffer[28] = function(targetId)
		return 15;
	end

	--Banish II
	buffer[29] = function(targetId)
		return 30;
	end

	--Banish III
	buffer[30] = function(targetId)
		return 45;
	end

	--Banishga
	buffer[38] = function(targetId)
		return 15;
	end

	--Banishga II
	buffer[39] = function(targetId)
		return 30;
	end

	--Flare
	buffer[204] = function(targetId)
		return 10;
	end

	--Flare II
	buffer[205] = function(targetId)
		return 10;
	end

	--Freeze
	buffer[206] = function(targetId)
		return 10;
	end

	--Freeze II
	buffer[207] = function(targetId)
		return 10;
	end

	--Tornado
	buffer[208] = function(targetId)
		return 10;
	end

	--Tornado II
	buffer[209] = function(targetId)
		return 10;
	end

	--Quake
	buffer[210] = function(targetId)
		return 10;
	end

	--Quake II
	buffer[211] = function(targetId)
		return 10;
	end

	--Burst
	buffer[212] = function(targetId)
		return 10;
	end

	--Burst II
	buffer[213] = function(targetId)
		return 10;
	end

	--Flood
	buffer[214] = function(targetId)
		return 10;
	end

	--Flood II
	buffer[215] = function(targetId)
		return 10;
	end
    
	--Katon: Ichi
	buffer[320] = function(targetId)
		return 10;
	end

	--Katon: Ni
	buffer[321] = function(targetId)
		return 10;
	end

	--Katon: San
	buffer[322] = function(targetId)
		return 10;
	end

	--Hyoton: Ichi
	buffer[323] = function(targetId)
		return 10;
	end

	--Hyoton: Ni
	buffer[324] = function(targetId)
		return 10;
	end

	--Hyoton: San
	buffer[325] = function(targetId)
		return 10;
	end

	--Huton: Ichi
	buffer[326] = function(targetId)
		return 10;
	end

	--Huton: Ni
	buffer[327] = function(targetId)
		return 10;
	end

	--Huton: San
	buffer[328] = function(targetId)
		return 10;
	end

	--Doton: Ichi
	buffer[329] = function(targetId)
		return 10;
	end

	--Doton: Ni
	buffer[330] = function(targetId)
		return 10;
	end

	--Doton: San
	buffer[331] = function(targetId)
		return 10;
	end

	--Raiton: Ichi
	buffer[332] = function(targetId)
		return 10;
	end

	--Raiton: Ni
	buffer[333] = function(targetId)
		return 10;
	end

	--Raiton: San
	buffer[334] = function(targetId)
		return 10;
	end

	--Suiton: Ichi
	buffer[335] = function(targetId)
		return 10;
	end

	--Suiton: Ni
	buffer[336] = function(targetId)
		return 10;
	end

	--Suiton: San
	buffer[337] = function(targetId)
		return 10;
	end
end

return Initialize;
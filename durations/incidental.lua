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

local function FillSpellTable(spellTable)
	--Banish
	spellTable[28] = function(targetId)
		return 15;
	end

	--Banish II
	spellTable[29] = function(targetId)
		return 30;
	end

	--Banish III
	spellTable[30] = function(targetId)
		return 45;
	end

	--Banishga
	spellTable[38] = function(targetId)
		return 15;
	end

	--Banishga II
	spellTable[39] = function(targetId)
		return 30;
	end

	--Flare
	spellTable[204] = function(targetId)
		return 10;
	end

	--Flare II
	spellTable[205] = function(targetId)
		return 10;
	end

	--Freeze
	spellTable[206] = function(targetId)
		return 10;
	end

	--Freeze II
	spellTable[207] = function(targetId)
		return 10;
	end

	--Tornado
	spellTable[208] = function(targetId)
		return 10;
	end

	--Tornado II
	spellTable[209] = function(targetId)
		return 10;
	end

	--Quake
	spellTable[210] = function(targetId)
		return 10;
	end

	--Quake II
	spellTable[211] = function(targetId)
		return 10;
	end

	--Burst
	spellTable[212] = function(targetId)
		return 10;
	end

	--Burst II
	spellTable[213] = function(targetId)
		return 10;
	end

	--Flood
	spellTable[214] = function(targetId)
		return 10;
	end

	--Flood II
	spellTable[215] = function(targetId)
		return 10;
	end
    
	--Katon: Ichi
	spellTable[320] = function(targetId)
		return 10;
	end

	--Katon: Ni
	spellTable[321] = function(targetId)
		return 10;
	end

	--Katon: San
	spellTable[322] = function(targetId)
		return 10;
	end

	--Hyoton: Ichi
	spellTable[323] = function(targetId)
		return 10;
	end

	--Hyoton: Ni
	spellTable[324] = function(targetId)
		return 10;
	end

	--Hyoton: San
	spellTable[325] = function(targetId)
		return 10;
	end

	--Huton: Ichi
	spellTable[326] = function(targetId)
		return 10;
	end

	--Huton: Ni
	spellTable[327] = function(targetId)
		return 10;
	end

	--Huton: San
	spellTable[328] = function(targetId)
		return 10;
	end

	--Doton: Ichi
	spellTable[329] = function(targetId)
		return 10;
	end

	--Doton: Ni
	spellTable[330] = function(targetId)
		return 10;
	end

	--Doton: San
	spellTable[331] = function(targetId)
		return 10;
	end

	--Raiton: Ichi
	spellTable[332] = function(targetId)
		return 10;
	end

	--Raiton: Ni
	spellTable[333] = function(targetId)
		return 10;
	end

	--Raiton: San
	spellTable[334] = function(targetId)
		return 10;
	end

	--Suiton: Ichi
	spellTable[335] = function(targetId)
		return 10;
	end

	--Suiton: Ni
	spellTable[336] = function(targetId)
		return 10;
	end

	--Suiton: San
	spellTable[337] = function(targetId)
		return 10;
	end
end

return FillSpellTable;
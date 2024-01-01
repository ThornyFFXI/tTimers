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
    --Monomi: Ichi
    spellTable[318] = function(targetId)
        return 120;
    end

    --Utsusemi: Ichi
    spellTable[338] = function(targetId)
        return 900;
    end

    --Utsusemi: Ni
    spellTable[339] = function(targetId)
        return 900;
    end

    --Utsusemi: San
    spellTable[340] = function(targetId)
        return 900;
    end

	--Aisha: Ichi
	spellTable[319] = function(targetId)
		return 120;
	end

    --[[UNKNOWN
	--Jubaku: Ichi
	spellTable[341] = function(targetId)
		return 0;
	end
    ]]--

    --[[UNKNOWN
	--Hojo: Ichi
	spellTable[344] = function(targetId)
		return 0;
	end
    ]]--

    --[[UNKNOWN
	--Hojo: Ni
	spellTable[345] = function(targetId)
		return 0;
	end
    ]]--

    --[[UNKNOWN
	--Kurayami: Ichi
	spellTable[347] = function(targetId)
		return 0;
	end
    ]]--

    --[[UNKNOWN
	--Kurayami: Ni
	spellTable[348] = function(targetId)
		return 0;
	end
    ]]--

    --[[UNKNOWN
	--Dokumori: Ichi
	spellTable[350] = function(targetId)
		return 60;
	end
    ]]--

    --Tonko: Ichi
    spellTable[353] = function(targetId)
        return 180;
    end

    --Tonko: Ni
    spellTable[354] = function(targetId)
        return 300;
    end
    
    --Gekka: Ichi
    spellTable[505] = function(targetId)
        return 180;
    end
    
    --Yain: Ichi
    spellTable[506] = function(targetId)
        return 300;
    end
    
    --Myoshu: Ichi
    spellTable[507] = function(targetId)
        return 300;
    end
    
    --[[UNKNOWN
    --Yurin: Ichi
	spellTable[508] = function(targetId)
		return 0;
	end
    ]]--

    --Kakka: Ichi
    spellTable[509] = function(targetId)
        return 300;
    end    
    
    --Migawari: Ichi
    spellTable[510] = function(targetId)
        return 60;
    end
end

return FillSpellTable;
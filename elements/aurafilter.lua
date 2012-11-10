
local pClass = select(2, UnitClass('player'))

local spells = {
	["DEATHKNIGHT"] = {
		buff = {
			49222, 55233, 48792, 48707, 81256, 49039, 51271, 96268, 115989,
		},
		debuff = {
			59879, 59921,
		},
		proc = {
			50421, 81141, 59052, 51124, 81340, 53365, 63560,
		},
	},
	["WARLOCK"] = {
		buff = {
			74434, 113861, 113860, 113858, 104773, 110913, 6229, 111400, 
		},
		debuff = {
			1490, 18223, 109466, 63311, 603, 980, 172, 27243, 348, 30108, 48181, 
		},
		proc = {
			122355, 117828, 34936, 108559, 
		},
	},
}

local info = {
	buff = {
		size = 32,
		point = {"CENTER", UIParent, "CENTER", 132, 0},
		spells = {},
		filter = "BUFF",
		caster = "player",
	},
	debuff = {
		size = 32,
		point = {"CENTER", UIParent, "CENTER", 132, 37},
		spells = {},
		filter = "DEBUFF",
		caster = "player",
	},
	proc = {
		size = 64,
		point = {"CENTER", UIParent, "CENTER", 132, 54},
		spells = {},
		filter = "BUFF",
		caster = "player",
	},
}

local bars = {
	buff = {},
	debuff = {},
	proc = {},
}

local direction = "RIGHT"

local UpdatePositions = function()
	for i, icons in pairs(bars) do
		for i = 1, #icons do
			icons[i]:ClearAllPoints()
			if i == 1 then
				icons[i]:SetPoint("CENTER", icons.point, 0, 0)
			else
				if direction == "UP" then
					icons[i]:SetPoint("BOTTOM", icons[i-1], "TOP", 0, spacing)
				elseif direction == "DOWN" then
					icons[i]:SetPoint("TOP", icons[i-1], "BOTTOM", 0, -spacing)
				elseif direction == "RIGHT" then
					icons[i]:SetPoint("LEFT", icons[i-1], "RIGHT", spacing, 0)
				elseif direction == "LEFT" then
					icons[i]:SetPoint("RIGHT", icons[i-1], "LEFT", -spacing, 0)
				end
			end
			icons[i].id = i
		end
	end
end

local OnEvent = function(self, event)

end

local frame = CreateFrame("frame")
frame:RegisterEvent("UNIT_AURA")
frame:RegisterEvent("PLAYER_TARGET_CHANGED")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:SetScript("OnEvent", OnEvent)

if spells and spells[pClass] then
	for i, v in pairs(spells[pClass].buff) do
		info.buff.spells[v] = true
	end
	for i, v in pairs(spells[pClass].debuff) do
		info.debuff.spells[v] = true
	end
	for i, v in pairs(spells[pClass].proc) do
		info.proc.spells[v] = true
	end
end
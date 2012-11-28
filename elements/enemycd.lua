-- Config start
local size = 26
local spacing = 5
local direction = "UP"
local show = {
	["none"] = true, 
	["pvp"] = true, 
	["arena"] = true,
}
-- Config end

local spells = {
	[1766] = 10,	-- Kick
	[6552] = 10,	-- Pummel
	[2139] = 24,	-- Counterspell
	[19647] = 24,	-- Spell Lock
	[8122] = 30,	-- Psychic Scream
	[47476] = 120,	-- Strangulate
	[47528] = 10,	-- Mind Freeze
	[34490] = 20,	-- Silencing Shot
	[51514] = 45,	-- Hex
	[15487] = 45,	-- Silence
	[2094] = 180,	-- Blind
	[57994] = 12,	-- Wind Shear
	[78675] = 60,	-- Solar Bream
	[115781] = 24,	-- Optical Blast
	[102060] = 40,	-- Disrupting Shout
	[116705] = 15,	-- Spear Hand Strike
	[80965] = 15,	-- Skull Bash
	[96231] = 15,	-- Rebuke
}

local cfg = {}
local config = {
	general = {
		direction = {
			order = 1,
			value = direction,
			type = "select",
			select = {"UP", "DOWN", "LEFT", "RIGHT"},
		},
		enabled = {
			order = 2,
			value = true,
		},
		size = {
			order = 3,
			value = size,
			type = "range",
			min = 10,
			max = 50,
		},
		spacing = {
			order = 4,
			value = spacing,
			type = "range",
			min = 0,
			max = 30,
		},
	},
	showin = {
		world = {
			order = 1,
			value = true,
		},
		bg = {
			order = 2,
			value = true,
		},
		arena = {
			order = 3,
			value = true,
		},
	},
}

UIConfigGUI.enemycd = config
UIConfig.enemycd = cfg

local frame = CreateFrame("Frame")
frame:RegisterEvent("VARIABLES_LOADED")
frame:SetScript("OnEvent", function(self, event)
	size = cfg.general.size
	spacing = cfg.general.spacing
	direction = cfg.general.direction
	show = {
		["none"] = cfg.showin.world, 
		["pvp"] = cfg.showin.bg, 
		["arena"] = cfg.showin.arena,
	}
end)

local backdrop = {
	bgFile = [=[Interface\ChatFrame\ChatFrameBackground]=],
	edgeFile = [=[Interface\ChatFrame\ChatFrameBackground]=], edgeSize = 1,
	insets = {top = 0, left = 0, bottom = 0, right = 0},
}

local icons = {}
local band = bit.band

local anchorframe = CreateFrame("Frame", "EnemyCD", UIParent)
anchorframe:SetSize(size, size)
anchorframe:SetPoint("CENTER", -70, -70)
if UIMovableFrames then tinsert(UIMovableFrames, anchorframe) end

local CreateBG = CreateBG or function(parent)
	local bg = CreateFrame("Frame", nil, parent)
	bg:SetPoint("TOPLEFT", -1, 1)
	bg:SetPoint("BOTTOMRIGHT", 1, -1)
	bg:SetFrameLevel(parent:GetFrameLevel() - 1)
	bg:SetBackdrop(backdrop)
	bg:SetBackdropColor(0, 0, 0, 0.5)
	bg:SetBackdropBorderColor(0, 0, 0, 1)
	return bg
end

local UpdatePositions = function()
	for i = 1, #icons do
		icons[i]:ClearAllPoints()
		if i == 1 then
			icons[i]:SetPoint("CENTER", anchorframe, 0, 0)
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

local StopTimer = function(icon)
	icon:SetScript("OnUpdate", nil)
	icon:Hide()
	tremove(icons, icon.id)
	UpdatePositions()
end

local IconUpdate = function(self, elapsed)
	if (self.endTime < GetTime()) then
		StopTimer(self)
	end
end

local CreateIcon = function()
	local icon = CreateFrame("frame", nil, UIParent)
	icon:SetWidth(size)
	icon:SetHeight(size)
	icon.bg = CreateBG(icon)
	icon.Cooldown = CreateFrame("Cooldown", nil, icon)
	icon.Cooldown:SetAllPoints(icon)
	icon.Texture = icon:CreateTexture(nil, "BORDER")
	icon.Texture:SetAllPoints(icon)
	return icon
end

local StartTimer = function(sID)
	local _,_,texture = GetSpellInfo(sID)
	local icon = CreateIcon()
	icon.Texture:SetTexture(texture)
	icon.Texture:SetTexCoord(0.07, 0.93, 0.07, 0.93)
	icon.endTime = GetTime() + spells[sID]
	icon:Show()
	icon:SetScript("OnUpdate", IconUpdate)
	CooldownFrame_SetTimer(icon.Cooldown, GetTime(), spells[sID], 1)
	tinsert(icons, icon)
	UpdatePositions()
end

local OnEvent = function(self, event, ...)
	if event == "COMBAT_LOG_EVENT_UNFILTERED" then
		if not cfg.general.enabled then
			self:UnregisterAllEvents()
			return
		end
		local timestamp, eventType, _, sourceGUID, sourceName, sourceFlags, _, _, _, _, _, spellID, spellName = ...
		if eventType == "SPELL_CAST_SUCCESS" and band(sourceFlags, COMBATLOG_OBJECT_REACTION_HOSTILE) == COMBATLOG_OBJECT_REACTION_HOSTILE then			
			if sourceName ~= UnitName("player") then
				if spells[spellID] and show[select(2, IsInInstance())] then
					StartTimer(spellID)
				end
			end
		end 
	elseif event == "ZONE_CHANGED_NEW_AREA" then
		for k, v in pairs(icons) do
			StopTimer(v)
		end
	end
end

local addon = CreateFrame("frame")
addon:SetScript('OnEvent', OnEvent)
addon:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
addon:RegisterEvent("ZONE_CHANGED_NEW_AREA")

SlashCmdList["EnemyCD"] = function(msg) 
	StartTimer(47528)
	StartTimer(19647)
	StartTimer(47476)
	StartTimer(51514)
end
SLASH_EnemyCD1 = "/enemycd"
-- Config start
local width, height = 130, 14
local spacing = 5
local icon_size = 14
local show_icon = true
local texture = "Interface\\TargetingFrame\\UI-StatusBar"
local show = {
	raid = true,
	party = true,
	arena = true,
}
-- Config end

local spells = {
	[20484] = 600,	-- Rebirth
	[6203] = 900,	-- Soulstone
	[95750] = 900,
	[20707] = 900,	-- Soulstone res
	[6346] = 180,	-- Fear Ward
	[29166] = 180,	-- Innervate
	[32182] = 300,	-- Heroism
	[2825] = 300,	-- Bloodlust
	[80353] = 300,	-- Time Warp
	[90355] = 300,	-- Ancient Hysteria
	[61999] = 600,	-- Raise Ally
}

local cfg = {}
local config = {
	general = {
		enabled = {
			order = 1,
			value = true,
		},
		showicon = {
			order = 2,
			value = true,
		},
		width = {
			order = 3,
			value = width,
			type = "range",
			min = 10,
			max = 300,
		},
		height = {
			order = 4,
			value = height,
			type = "range",
			min = 5,
			max = 30,
		},
		spacing = {
			order = 5,
			value = spacing,
			type = "range",
			min = 0,
			max = 30,
		},
		iconsize = {
			order = 6,
			value = icon_size,
			type = "range",
			min = 5,
			max = 70,
		},
	},
	showin = {
		raid = {
			order = 1,
			value = true,
		},
		party = {
			order = 2,
			value = true,
		},
		arena = {
			order = 3,
			value = true,
		},
	},
}

UIConfigGUI.raidcd = config
UIConfig.raidcd = cfg

local frame = CreateFrame("Frame")
frame:RegisterEvent("VARIABLES_LOADED")
frame:SetScript("OnEvent", function(self, event)
	width = cfg.general.width
	height = cfg.general.height
	spacing = cfg.general.spacing
	icon_size = cfg.general.iconsize
	show_icon = cfg.general.showicon
	show = {
		raid = cfg.showin.raid, 
		party = cfg.showin.party, 
		arena = cfg.showin.arena,
	}
end)

local filter = COMBATLOG_OBJECT_AFFILIATION_RAID + COMBATLOG_OBJECT_AFFILIATION_PARTY + COMBATLOG_OBJECT_AFFILIATION_MINE
local band = bit.band
local sformat = string.format
local floor = math.floor
local timer = 0

local backdrop = {
	bgFile = [=[Interface\ChatFrame\ChatFrameBackground]=],
	edgeFile = [=[Interface\ChatFrame\ChatFrameBackground]=], edgeSize = 1,
	insets = {top = 0, left = 0, bottom = 0, right = 0},
}

local bars = {}

local anchorframe = CreateFrame("Frame", "RaidCD", UIParent)
anchorframe:SetSize(width, height)
anchorframe:SetPoint("TOPLEFT", 12, -300)
if UIMovableFrames then tinsert(UIMovableFrames, anchorframe) end

local FormatTime = function(time)
	if time >= 60 then
		return sformat('%.2d:%.2d', floor(time / 60), time % 60)
	else
		return sformat('%.2d', time)
	end
end

local UpdatePositions = function()
	for i = 1, #bars do
		bars[i]:ClearAllPoints()
		if i == 1 then
			bars[i]:SetPoint("TOPLEFT", anchorframe, 0, 0)
		else
			bars[i]:SetPoint("TOPLEFT", bars[i-1], "BOTTOMLEFT", 0, -spacing)
		end
		bars[i].id = i
	end
end

local StopTimer = function(bar)
	bar:SetScript("OnUpdate", nil)
	bar:Hide()
	tremove(bars, bar.id)
	UpdatePositions()
end

local BarUpdate = function(self, elapsed)
	local curTime = GetTime()
	if self.endTime < curTime then
		StopTimer(self)
		return
	end
	self.status:SetValue(100 - (curTime - self.startTime) / (self.endTime - self.startTime) * 100)
	self.right:SetText(FormatTime(self.endTime - curTime))
end

local OnEnter = function(self)
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	GameTooltip:AddLine(self.spell)
	GameTooltip:SetClampedToScreen(true)
	GameTooltip:Show()
end

local OnLeave = function(self)
	GameTooltip:Hide()
end

local OnMouseDown = function(self, button)
	if button == "LeftButton" then
		SendChatMessage(sformat("Cooldown %s %s: %s", self.left:GetText(), self.spell, self.right:GetText()), "RAID")
	elseif button == "RightButton" then
		StopTimer(self)
	end
end

local CreateBar = function()
	local bar = CreateFrame("Frame", nil, UIParent)
	bar:SetSize(width, height)
	bar.status = CreateFrame("Statusbar", nil, bar)
	if show_icon then
		bar.icon = CreateFrame("button", nil, bar)
		bar.icon:SetSize(icon_size, icon_size)
		bar.icon:SetPoint("BOTTOMLEFT", 0, 0)
		bar.status:SetPoint("BOTTOMLEFT", bar.icon, "BOTTOMRIGHT", 5, 0)
	else
		bar.status:SetPoint("BOTTOMLEFT", 0, 0)
	end
	bar.status:SetPoint("BOTTOMRIGHT", 0, 0)
	bar.status:SetHeight(height)
	bar.status:SetStatusBarTexture(texture)
	bar.status:SetMinMaxValues(0, 100)
	bar.status:SetFrameLevel(bar:GetFrameLevel()-1)
	bar.left = CreateFS(bar)
	bar.left:SetPoint('LEFT', bar.status, 2, 1)
	bar.left:SetJustifyH('LEFT')
	bar.right = CreateFS(bar)
	bar.right:SetPoint('RIGHT', bar.status, -2, 1)
	bar.right:SetJustifyH('RIGHT')
	CreateBG(bar.icon)
	CreateBG(bar.status)
	return bar
end

local StartTimer = function(name, spellId)
	local spell, rank, icon = GetSpellInfo(spellId)
	for _, v in pairs(bars) do
		if v.name == name and v.spell == spell then
			return
		end
	end
	local bar = CreateBar()
	bar.endTime = GetTime() + spells[spellId]
	bar.startTime = GetTime()
	bar.left:SetText(name)
	bar.name = name
	bar.right:SetText(FormatTime(spells[spellId]))
	if icon and bar.icon then
		bar.icon:SetNormalTexture(icon)
		bar.icon:GetNormalTexture():SetTexCoord(0.07, 0.93, 0.07, 0.93)
	end
	bar.spell = spell
	bar:Show()
	local color = RAID_CLASS_COLORS[select(2, UnitClass(name))]
	bar.status:SetStatusBarColor(color.r, color.g, color.b)
	bar:SetScript("OnUpdate", BarUpdate)
	bar:EnableMouse(true)
	bar:SetScript("OnEnter", OnEnter)
	bar:SetScript("OnLeave", OnLeave)
	bar:SetScript("OnMouseDown", OnMouseDown)
	tinsert(bars, bar)
	UpdatePositions()
end

local OnEvent = function(self, event, ...)
	if event == "COMBAT_LOG_EVENT_UNFILTERED" then
		if not cfg.general.enabled then
			self:UnregisterAllEvents()
			return
		end
		local timestamp, eventType, _, sourceGUID, sourceName, sourceFlags = ...
		if band(sourceFlags, filter) == 0 then return end
		if eventType == "SPELL_RESURRECT" or eventType == "SPELL_CAST_SUCCESS" or eventType == "SPELL_AURA_APPLIED" then
			local spellId = select(12, ...)
			if spells[spellId] and show[select(2, IsInInstance())] then
				StartTimer(sourceName, spellId)
			end
		end
	elseif event == "ZONE_CHANGED_NEW_AREA" and select(2, IsInInstance()) == "arena" then
		for k, v in pairs(bars) do
			StopTimer(v)
		end
	end
end

local addon = CreateFrame("frame")
addon:SetScript('OnEvent', OnEvent)
addon:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
addon:RegisterEvent("ZONE_CHANGED_NEW_AREA")

SlashCmdList["RaidCD"] = function(msg) 
	StartTimer(UnitName('player'), 20484)
	StartTimer(UnitName('player'), 6203)
	StartTimer(UnitName('player'), 6346)
end
SLASH_RaidCD1 = "/raidcd"
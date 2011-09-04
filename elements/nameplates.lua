
local config = {
	general = {
		enabled = {
			order = 1,
			value = true,
		},
		showincombat = {
			order = 2,
			value = true,
		},
	},
	sizes = {
		width = {
			order = 1,
			value = 80,
			type = "range",
			min = 50,
			max = 500,
		},
		height = {
			order = 2,
			value = 9,
			type = "range",
			min = 5,
			max = 20,
		},
	},
	castbar = {
		width = {
			order = 1,
			value = 80,
			type = "range",
			min = 50,
			max = 500,
		},
		height = {
			order = 2,
			value = 9,
			type = "range",
			min = 5,
			max = 20,
		},
	},
}

local cfg = {}
UIConfigGUI.nameplates = config
UIConfig.nameplates = cfg

local barTexture = "Interface\\TargetingFrame\\UI-StatusBar"
local overlayTexture = [=[Interface\Tooltips\Nameplate-Border]=]
local font, fontSize, fontOutline

local select = select


local UpdateTime = function(self, curValue)
	local minValue, maxValue = self:GetMinMaxValues()
	if self.channeling then
		self.time:SetFormattedText("%.1f ", curValue)
	else
		self.time:SetFormattedText("%.1f ", maxValue - curValue)
	end
end

local UpdateFrame = function(self)
	local r, g, b = self.healthBar:GetStatusBarColor()
	
	for class, color in pairs(RAID_CLASS_COLORS) do
		local r, g, b = floor(r * 100 + 0.5) / 100, floor(g * 100 + 0.5) / 100, floor(b * 100 + 0.5) / 100
		if RAID_CLASS_COLORS[class].r == r and RAID_CLASS_COLORS[class].g == g and RAID_CLASS_COLORS[class].b == b then
			self.hasClass = true
			break
		end
	end

	if self.hasClass then
		self.healthBar:SetStatusBarColor(r, g, b)
	elseif g + b == 0 then	-- Hostile
		self.healthBar:SetStatusBarColor(0.89, 0.21, 0.21)
	elseif r + b == 0 then	-- Friendly npc
		self.healthBar:SetStatusBarColor(0.23, 0.89, 0.23)
	elseif r + g > 1.95 then	-- Neutral
		self.healthBar:SetStatusBarColor(0.85, 0.83, 0.25)
	elseif r + g == 0 then	-- Friendly player
		self.healthBar:SetStatusBarColor(0.21, 0.35, 0.83)
	end
	
	self.healthBar:ClearAllPoints()
	self.healthBar:SetPoint("CENTER", self)
	self.healthBar:SetHeight(cfg.sizes.height * UIParent:GetEffectiveScale())
	self.healthBar:SetWidth(cfg.sizes.width)

	self.castBar:ClearAllPoints()
	self.castBar:SetPoint("TOP", self.healthBar, "BOTTOM", 0, -7 * UIParent:GetEffectiveScale())
	self.castBar:SetHeight(cfg.castbar.height * UIParent:GetEffectiveScale())
	self.castBar:SetWidth(cfg.castbar.width)

	self.name:SetText(self.oldname:GetText())
	self.highlight:ClearAllPoints()
	self.highlight:SetAllPoints(self.healthBar)

	local level, elite, mylevel = tonumber(self.level:GetText()), self.elite:IsShown(), UnitLevel("player")
	self.level:ClearAllPoints()
	self.level:SetPoint("RIGHT", self.healthBar, "LEFT", -3, 1)
	if self.boss:IsShown() then
		self.level:SetText("B")
		self.level:SetTextColor(0.8, 0.05, 0)
		self.level:Show()
	elseif not elite and level == mylevel then
		self.level:Hide()
	else
		self.level:SetText(level..(elite and "+" or ""))
	end
end

local UpdateCastbar = function(self)
	self:SetHeight(cfg.castbar.height * UIParent:GetEffectiveScale())
	self:ClearAllPoints()
	self:SetPoint("TOP", self.healthBar, "BOTTOM", 0, -7 * UIParent:GetEffectiveScale())
end

local OnSizeChanged = function(self)
	self.needFix = true
end

local OnValueChanged = function(self, curValue)
	UpdateTime(self, curValue)
	if self.needFix then
		UpdateCastbar(self)
		self.needFix = nil
	end
end

local OnShow = function(self)
	self.channeling  = UnitChannelInfo("target") 
	UpdateCastbar(self)
end

local OnHide = function(self)
	self.highlight:Hide()
end

local SetFrame = function(frame)
	local healthBar, castBar = frame:GetChildren()
	local _, castbarOverlay, shieldedRegion, spellIconRegion = castBar:GetRegions()
	local glowRegion, overlayRegion, highlightRegion, nameTextRegion, levelTextRegion, bossIconRegion, raidIconRegion, stateIconRegion = frame:GetRegions()

	local offset = UIParent:GetEffectiveScale()
	
	frame.healthBar = healthBar
	frame.castBar = castBar
	frame.oldname = nameTextRegion
	nameTextRegion:Hide()

	frame.name = frame:CreateFontString()
	frame.name:SetPoint("BOTTOM", healthBar, "TOP", 0, 2*offset)
	frame.name:SetFont(font, fontSize, fontOutline)
	frame.name:SetTextColor(0.84, 0.75, 0.65)
	frame.name:SetShadowOffset(0, 0)

	frame.level = levelTextRegion
	frame.level:SetFont(font, fontSize, fontOutline)
	frame.level:SetShadowOffset(0, 0)

	healthBar:SetStatusBarTexture(barTexture)

	local backdrop = {
		bgFile = [=[Interface\ChatFrame\ChatFrameBackground]=],
		edgeFile = [=[Interface\ChatFrame\ChatFrameBackground]=], edgeSize = offset,
		insets = {left = -offset, right = -offset, top = -offset, bottom = -offset},
	}

	healthBar.hpBg = healthBar:CreateTexture(nil, "BORDER")
	healthBar.hpBg:SetAllPoints()
	healthBar.hpBg:SetTexture(barTexture)
	healthBar.hpBg:SetVertexColor(0.05, 0.05, 0.05)
	
	healthBar.hpBg2 = CreateFrame("Frame", nil, healthBar)
	healthBar.hpBg2:SetBackdrop(backdrop)
	healthBar.hpBg2:SetBackdropColor(0, 0, 0, 1)
	healthBar.hpBg2:SetBackdropBorderColor(.4, .4, .4, 1)
	healthBar.hpBg2:SetPoint("TOPLEFT", -2 * offset, 2 * offset)
	healthBar.hpBg2:SetPoint("BOTTOMRIGHT", 2 * offset, -2 * offset)
	healthBar.hpBg2:SetFrameLevel(healthBar:GetFrameLevel() -1 > 0 and healthBar:GetFrameLevel() -1 or 0)
 
	castBar.castbarOverlay = castbarOverlay
	castBar.healthBar = healthBar
	castBar.shieldedRegion = shieldedRegion
	castBar:SetStatusBarTexture(barTexture)

	castBar:HookScript("OnShow", OnShow)
	castBar:HookScript("OnSizeChanged", OnSizeChanged)
	castBar:HookScript("OnValueChanged", OnValueChanged)

	castBar.time = castBar:CreateFontString(nil, "ARTWORK")
	castBar.time:SetPoint("RIGHT", castBar, "LEFT", -2, 1)
	castBar.time:SetFont(font, fontSize, fontOutline)
	castBar.time:SetTextColor(0.84, 0.75, 0.65)
	castBar.time:SetShadowOffset(0, -0)

	castBar.cbBg = castBar:CreateTexture(nil, "BORDER")
	castBar.cbBg:SetAllPoints()
	castBar.cbBg:SetTexture(barTexture)
	castBar.cbBg:SetVertexColor(0.05, 0.05, 0.05)
	
	castBar.cbBg2 = CreateFrame("Frame", nil, castBar)
	castBar.cbBg2:SetBackdrop(backdrop)
	castBar.cbBg2:SetBackdropColor(0, 0, 0, 1)
	castBar.cbBg2:SetBackdropBorderColor(.4, .4, .4, 1)
	castBar.cbBg2:SetPoint("TOPLEFT", castBar, "TOPLEFT", -2 * offset, 2 * offset)
	castBar.cbBg2:SetPoint("BOTTOMRIGHT", castBar, "BOTTOMRIGHT", 2 * offset, -2 * offset)
	castBar.cbBg2:SetFrameLevel(castBar:GetFrameLevel() -1 > 0 and castBar:GetFrameLevel() -1 or 0)

	spellIconRegion:ClearAllPoints()
	spellIconRegion:SetPoint("TOPLEFT", healthBar, "TOPRIGHT", 5, -2)
	spellIconRegion:SetHeight(15)
	spellIconRegion:SetWidth(15)
	spellIconRegion:SetTexCoord(0.07, 0.93, 0.07, 0.93)

	cbIconborder = CreateFrame("Frame", nil, castBar)
	cbIconborder:SetBackdrop(backdrop)
	cbIconborder:SetBackdropColor(0, 0, 0, 1)
	cbIconborder:SetBackdropBorderColor(.4, .4, .4, 1)
	cbIconborder:SetPoint("TOPLEFT", spellIconRegion, "TOPLEFT", -2 * offset, 2 * offset)
	cbIconborder:SetPoint("BOTTOMRIGHT", spellIconRegion, "BOTTOMRIGHT", 2 * offset, -2 * offset)
	cbIconborder:SetFrameLevel(0)

	raidIconRegion:ClearAllPoints()
	raidIconRegion:SetPoint("LEFT", healthBar, "RIGHT", 2, 0)
	raidIconRegion:SetHeight(15)
	raidIconRegion:SetWidth(15)
	
	highlightRegion:SetTexture(barTexture)
	highlightRegion:SetVertexColor(0.25, 0.25, 0.25)

	frame.oldglow = glowRegion
	frame.elite = stateIconRegion
	frame.boss = bossIconRegion
	frame.highlight = highlightRegion

	glowRegion:SetTexture(nil)
	overlayRegion:SetTexture(nil)
	shieldedRegion:SetTexture(nil)
	castbarOverlay:SetTexture(nil)
	stateIconRegion:SetTexture(nil)
	bossIconRegion:SetTexture(nil)

	frame:SetScript("OnShow", UpdateFrame)
	frame:SetScript("OnHide", OnHide)
	UpdateFrame(frame)

	frame.done = true
end

local CheckFrames = function(num, ...)
	for i = 1, num do
		local frame = select(i, ...)
		if not frame:GetName() or frame:GetName():find("NamePlate%d") then
			overlayRegion = select(2, frame:GetRegions())
			if not frame.done and overlayRegion and overlayRegion:GetObjectType() == "Texture" and overlayRegion:GetTexture() == overlayTexture then
				SetFrame(frame)
			end
		end
	end
end

local numKids = 0
local timer = 0
local OnUpdate = function(self, elapsed)
	timer = timer + elapsed
	if timer > 0.1 then
		local numChildren = WorldFrame:GetNumChildren()
		if numChildren ~= numKids then
			CheckFrames(numChildren, WorldFrame:GetChildren())
			numKids = numChildren
		end
		timer = 0
	end
end

local OnEvent = function(self, event, ...)
	if event == "PLAYER_REGEN_ENABLED" then
		if cfg.general.showincombat then
			SetCVar("nameplateShowEnemies", 0)
		end
	elseif event == "PLAYER_REGEN_DISABLED" then
		if cfg.general.showincombat then
			SetCVar("nameplateShowEnemies", 1)
		end
	elseif event == "VARIABLES_LOADED" then
		if not cfg.general.enabled then
			self:UnregisterAllEvents()
			self:SetScript("OnUpdate", nil)
		end
		font = UIConfig.general.fonts.font
		fontSize = UIParent:GetEffectiveScale()*UIConfig.general.fonts.size
		fontOutline = UIConfig.general.fonts.style
	end
end

local frame = CreateFrame("Frame", nil, self)
frame:RegisterEvent("VARIABLES_LOADED")
frame:RegisterEvent("PLAYER_REGEN_ENABLED")
frame:RegisterEvent("PLAYER_REGEN_DISABLED")
frame:SetScript("OnEvent", OnEvent)
frame:SetScript("OnUpdate", OnUpdate)
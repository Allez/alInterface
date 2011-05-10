
local config = {
	general = {
		showincombat = {
			order = 1,
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

local caelNamePlates = CreateFrame("Frame", nil, UIParent)
caelNamePlates:SetScript("OnEvent", function(self, event, ...) self[event](self, ...) end)

local barTexture = "Interface\\TargetingFrame\\UI-StatusBar"
local overlayTexture = [=[Interface\Tooltips\Nameplate-Border]=]
local font, fontSize, fontOutline

local select = select

local IsValidFrame = function(frame)
	if frame:GetName():find("NamePlate%d") then
		overlayRegion = select(2, frame:GetRegions())
		return overlayRegion and overlayRegion:GetObjectType() == "Texture" and overlayRegion:GetTexture() == overlayTexture
	end
end

local UpdateTime = function(self, curValue)
	local minValue, maxValue = self:GetMinMaxValues()
	if self.channeling then
		self.time:SetFormattedText("%.1f ", curValue)
	else
		self.time:SetFormattedText("%.1f ", maxValue - curValue)
	end
end

local UnitType
local UpdateFrame = function(self)
	self.healthBar.UnitType = nil
	local r, g, b = self.healthBar:GetStatusBarColor()
	self.r, self.g, self.b = r, g, b

	self.healthBar:ClearAllPoints()
	self.healthBar:SetPoint("CENTER", self.healthBar:GetParent())
	self.healthBar:SetHeight(cfg.sizes.height * UIParent:GetEffectiveScale())
	self.healthBar:SetWidth(cfg.sizes.width)

	self.castBar:ClearAllPoints()
	self.castBar:SetPoint("TOP", self.healthBar, "BOTTOM", 0, -4)
	self.castBar:SetHeight(cfg.castbar.height * UIParent:GetEffectiveScale())
	self.castBar:SetWidth(cfg.castbar.width)

	self.highlight:ClearAllPoints()
	self.highlight:SetAllPoints(self.healthBar)

	self.name:SetText(self.oldname:GetText())

	local level, elite, mylevel = tonumber(self.level:GetText()), self.elite:IsShown(), UnitLevel("player")
	self.level:ClearAllPoints()
	self.level:SetPoint("RIGHT", self.healthBar, "LEFT", -2, 1)
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

local FixCastbar = function(self)
	self.castbarOverlay:Hide()

	self:SetHeight(6)
	self:ClearAllPoints()
	self:SetPoint("TOP", self.healthBar, "BOTTOM", 0, -4)
end

local ColorCastBar = function(self, shielded)
	if shielded then
		self:SetStatusBarColor(0.8, 0.05, 0)
		self:SetBackdropColor(0.75, 0.75, 0.75)
	else
		self:SetBackdropColor(0, 0, 0)
	end
end

local OnSizeChanged = function(self)
	self.needFix = true
end

local OnValueChanged = function(self, curValue)
	UpdateTime(self, curValue)
	if self.needFix then
		FixCastbar(self)
		self.needFix = nil
	end
end

local OnShow = function(self)
	self.channeling  = UnitChannelInfo("target") 
	FixCastbar(self)
	ColorCastBar(self, self.shieldedRegion:IsShown())
end

local OnHide = function(self)
	self.highlight:Hide()
end

local OnEvent = function(self, event, unit)
	if unit == "target" then
		if self:IsShown() then
			ColorCastBar(self, event == "UNIT_SPELLCAST_NOT_INTERRUPTIBLE")
		end
	end
end

local CreateFrame = function(frame)
	if frame.done then
		return
	end

	frame.nameplate = true

	frame.healthBar, frame.castBar = frame:GetChildren()
	local healthBar, castBar = frame.healthBar, frame.castBar
	local _, castbarOverlay, shieldedRegion, spellIconRegion = castBar:GetRegions()
	local glowRegion, overlayRegion, highlightRegion, nameTextRegion, levelTextRegion, bossIconRegion, raidIconRegion, stateIconRegion = frame:GetRegions()

	frame.oldname = nameTextRegion
	nameTextRegion:Hide()

	local newNameRegion = frame:CreateFontString()
	newNameRegion:SetPoint("BOTTOM", healthBar, "TOP", 0, 1)
	newNameRegion:SetFont(font, fontSize, fontOutline)
	newNameRegion:SetTextColor(0.84, 0.75, 0.65)
	newNameRegion:SetShadowOffset(0, -0)
	frame.name = newNameRegion

	frame.level = levelTextRegion
	levelTextRegion:SetFont(font, fontSize, fontOutline)
	levelTextRegion:SetShadowOffset(0, -0)

	healthBar:SetStatusBarTexture(barTexture)

	local offset = UIParent:GetEffectiveScale()
	
	local backdrop = {
		bgFile = [=[Interface\ChatFrame\ChatFrameBackground]=],
		edgeFile = [=[Interface\ChatFrame\ChatFrameBackground]=], edgeSize = offset,
		insets = {left = -offset, right = -offset, top = -offset, bottom = -offset},
	}

	healthBar.hpBackground = healthBar:CreateTexture(nil, "BORDER")
	healthBar.hpBackground:SetAllPoints()
	healthBar.hpBackground:SetTexture(barTexture)
	healthBar.hpBackground:SetVertexColor(0.05, 0.05, 0.05)
	
	healthBar.hpGlow = CreateFrame("Frame", nil, healthBar)
	healthBar.hpGlow:SetBackdrop(backdrop)
	healthBar.hpGlow:SetBackdropColor(0, 0, 0, 1)
	healthBar.hpGlow:SetBackdropBorderColor(.4, .4, .4, 1)
	healthBar.hpGlow:SetPoint("TOPLEFT", -2 * offset, 2 * offset)
	healthBar.hpGlow:SetPoint("BOTTOMRIGHT", 2 * offset, -2 * offset)
	healthBar.hpGlow:SetFrameLevel(healthBar:GetFrameLevel() -1 > 0 and healthBar:GetFrameLevel() -1 or 0)
 
	castBar.castbarOverlay = castbarOverlay
	castBar.healthBar = healthBar
	castBar.shieldedRegion = shieldedRegion
	castBar:SetStatusBarTexture(barTexture)

	castBar:HookScript("OnShow", OnShow)
	castBar:HookScript("OnSizeChanged", OnSizeChanged)
	castBar:HookScript("OnValueChanged", OnValueChanged)
	castBar:HookScript("OnEvent", OnEvent)
	castBar:RegisterEvent("UNIT_SPELLCAST_INTERRUPTIBLE")
	castBar:RegisterEvent("UNIT_SPELLCAST_NOT_INTERRUPTIBLE")

	castBar.time = castBar:CreateFontString(nil, "ARTWORK")
	castBar.time:SetPoint("RIGHT", castBar, "LEFT", -2, 1)
	castBar.time:SetFont(font, fontSize, fontOutline)
	castBar.time:SetTextColor(0.84, 0.75, 0.65)
	castBar.time:SetShadowOffset(0, -0)

	castBar.cbBackground = castBar:CreateTexture(nil, "BORDER")
	castBar.cbBackground:SetAllPoints()
	castBar.cbBackground:SetTexture(barTexture)
	castBar.cbBackground:SetVertexColor(0.05, 0.05, 0.05)
	
	castBar.cbGlow = CreateFrame("Frame", nil, castBar)
	castBar.cbGlow:SetBackdrop(backdrop)
	castBar.cbGlow:SetBackdropColor(0, 0, 0, 1)
	castBar.cbGlow:SetBackdropBorderColor(.4, .4, .4, 1)
	castBar.cbGlow:SetPoint("TOPLEFT", castBar, "TOPLEFT", -2 * offset, 2 * offset)
	castBar.cbGlow:SetPoint("BOTTOMRIGHT", castBar, "BOTTOMRIGHT", 2 * offset, -2 * offset)
	castBar.cbGlow:SetFrameLevel(castBar:GetFrameLevel() -1 > 0 and castBar:GetFrameLevel() -1 or 0)

	spellIconRegion:ClearAllPoints()
	spellIconRegion:SetPoint("TOPLEFT", healthBar, "TOPRIGHT", 5, -2)
	spellIconRegion:SetHeight(15)
	spellIconRegion:SetWidth(15)
	spellIconRegion:SetTexCoord(0.07, 0.93, 0.07, 0.93)

	cbIconborder = CreateFrame("Frame", nil, castBar)
	cbIconborder:SetBackdrop({
			bgFile = [=[Interface\ChatFrame\ChatFrameBackground]=],
			insets = {top = -offset, left = -offset, bottom = -offset, right = -offset},
		})
	cbIconborder:SetBackdropColor(0, 0, 0)
	cbIconborder:SetPoint("TOPLEFT", spellIconRegion, "TOPLEFT", 0, 0)
	cbIconborder:SetPoint("BOTTOMRIGHT", spellIconRegion, "BOTTOMRIGHT", 0, 0)

	highlightRegion:SetTexture(barTexture)
	highlightRegion:SetVertexColor(0.25, 0.25, 0.25)
	frame.highlight = highlightRegion

	raidIconRegion:ClearAllPoints()
	raidIconRegion:SetPoint("LEFT", healthBar, "RIGHT", 2, 0)
	raidIconRegion:SetHeight(15)
	raidIconRegion:SetWidth(15)

	frame.oldglow = glowRegion
	frame.elite = stateIconRegion
	frame.boss = bossIconRegion

	frame.done = true

	glowRegion:SetTexture(nil)
	overlayRegion:SetTexture(nil)
	shieldedRegion:SetTexture(nil)
	castbarOverlay:SetTexture(nil)
	stateIconRegion:SetTexture(nil)
	bossIconRegion:SetTexture(nil)

	UpdateFrame(frame)
	frame:SetScript("OnShow", UpdateFrame)
	frame:SetScript("OnHide", OnHide)

	frame.elapsed = 0
end

local numKids = 0
local lastUpdate = 0
local OnUpdate = function(self, elapsed)
	lastUpdate = lastUpdate + elapsed

	if lastUpdate > 0.1 then
		lastUpdate = 0

		local newNumKids = WorldFrame:GetNumChildren()
		if newNumKids ~= numKids then
			for i = numKids+1, newNumKids do
				frame = select(i, WorldFrame:GetChildren())

				if IsValidFrame(frame) then
					CreateFrame(frame)
				end
			end
			numKids = newNumKids
		end
	end
end

caelNamePlates:SetScript("OnUpdate", OnUpdate)

caelNamePlates:RegisterEvent("PLAYER_REGEN_ENABLED")
function caelNamePlates:PLAYER_REGEN_ENABLED()
	if cfg.general.showincombat then
		SetCVar("nameplateShowEnemies", 0)
	end
end

caelNamePlates:RegisterEvent("PLAYER_REGEN_DISABLED")
function caelNamePlates.PLAYER_REGEN_DISABLED()
	if cfg.general.showincombat then
		SetCVar("nameplateShowEnemies", 1)
	end
end

caelNamePlates:RegisterEvent("VARIABLES_LOADED")
function caelNamePlates:VARIABLES_LOADED()
	font, fontSize, fontOutline = UIConfig.general.fonts.font, UIParent:GetEffectiveScale()*UIConfig.general.fonts.size, UIConfig.general.fonts.style
end
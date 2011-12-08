
if UnitLevel('player') == MAX_PLAYER_LEVEL then

	local OnEnter = function(self)
		local name, id, min, max, value = GetWatchedFactionInfo()
		GameTooltip:SetOwner(self, 'ANCHOR_LEFT', 0, -5)
		GameTooltip:SetClampedToScreen(true)
		GameTooltip:AddLine(string.format('%s (%s)', name, _G['FACTION_STANDING_LABEL'..id]))
		GameTooltip:AddLine(string.format('%d / %d (%d%%)', value - min, max - min, (value - min) / (max - min) * 100))
		GameTooltip:Show()
	end

	local OnLeave = function(self)
		GameTooltip:Hide()
	end

	local OnEvent = function(self, event, ...)
		local name, standing, min, max, value = GetWatchedFactionInfo()
		if not name then
			return self:Hide()
		else
			self:Show()
		end
		self:SetMinMaxValues(min, max)
		self:SetValue(value)
		self:SetStatusBarColor(FACTION_BAR_COLORS[standing].r, FACTION_BAR_COLORS[standing].g, FACTION_BAR_COLORS[standing].b)
	end

	local reputation = CreateFrame("StatusBar", "UIReputation", UIParent)
	reputation:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
	reputation:SetOrientation("VERTICAL")
	reputation:SetPoint("TOPRIGHT", Minimap, "TOPLEFT", -7, 0)
	reputation:SetPoint("BOTTOMRIGHT", Minimap, "BOTTOMLEFT", -7, 0)
	reputation:SetWidth(5)
	reputation:SetScript("OnEvent", OnEvent)
	reputation:SetScript('OnEnter', OnEnter)
	reputation:SetScript('OnLeave', OnLeave)
	reputation:RegisterEvent('UPDATE_FACTION')
	CreateBG(reputation)

else

	local OnEnter = function(self)
		local min, max = UnitXP('player'), UnitXPMax('player')

		GameTooltip:SetOwner(self, 'ANCHOR_BOTTOM', 0, -5)
		GameTooltip:AddLine(string.format(XP..": %d / %d (%d%% - %d/%d)", min, max, min/max * 100, 20 - (20 * (max - min) / max), 20))
		GameTooltip:AddLine(string.format(LEVEL_ABBR..": %d (%d%% - %d/%d)", max - min, (max - min) / max * 100, 1 + 20 * (max - min) / max, 20))

		local exhaustion = GetXPExhaustion() or 0
		GameTooltip:AddLine(string.format("|cff0090ff"..TUTORIAL_TITLE26..": +%d (%d%%)", exhaustion, exhaustion / max * 100))

		GameTooltip:Show()
	end

	local OnLeave = function(self)
		GameTooltip:Hide()
	end

	local OnEvent = function(self, event, ...)
		if UnitLevel('player') == MAX_PLAYER_LEVEL then
			return self:Hide()
		else
			self:Show()
		end

		local min, max = UnitXP('player'), UnitXPMax('player')
		self:SetMinMaxValues(0, max)
		self:SetValue(min)

		local exhaustion = GetXPExhaustion() or 0
		self.rested:SetMinMaxValues(0, max)
		self.rested:SetValue(math.min(min + exhaustion, max))
	end

	local experience = CreateFrame("StatusBar", "UIExperience", UIParent)
	experience:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
	experience:SetOrientation("VERTICAL")
	experience:SetPoint("TOPRIGHT", Minimap, "TOPLEFT", -7, 0)
	experience:SetPoint("BOTTOMRIGHT", Minimap, "BOTTOMLEFT", -7, 0)
	experience:SetWidth(5)
	experience:SetStatusBarColor(0.15, 0.7, 0.1)
	experience:SetScript("OnEvent", OnEvent)
	experience:SetScript('OnEnter', OnEnter)
	experience:SetScript('OnLeave', OnLeave)
	experience:RegisterEvent('PLAYER_XP_UPDATE')
	experience:RegisterEvent('PLAYER_LEVEL_UP')
	experience:RegisterEvent('UPDATE_EXHAUSTION')
	experience:RegisterEvent('PLAYER_LOGIN')
	experience.rested = CreateFrame("StatusBar", nil, experience)
	experience.rested:SetAllPoints()
	experience.rested:SetOrientation("VERTICAL")
	experience.rested:SetFrameLevel(experience:GetFrameLevel() - 1)
	experience.rested:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
	experience.rested:SetStatusBarColor(0, 0.4, 1, 0.8)
	CreateBG(experience)

end

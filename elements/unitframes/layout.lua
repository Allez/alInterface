local addon_name, ns = ...

local stdfont = GameFontNormal:GetFont()
local texture = "Interface\\Addons\\"..addon_name.."\\media\\statusbarTex"
local glowTex = "Interface\\Addons\\"..addon_name.."\\media\\glowTex"

local config = {
	general = {
		smooth = {
			order = 1,
			value = true,
		},
		auraspiral = {
			order = 2,
			value = false,
		},
		auratimer = {
			order = 3,
			value = true,
		},
		focusdebuffs = {
			order = 4,
			value = true,
		},
		targetdebuffs = {
			order = 5,
			value = true,
		},
		petdebuffs = {
			order = 6,
			value = true,
		},
		totdebuffs = {
			order = 7,
			value = true,
		},
		colordebuff = {
			order = 8,
			value = true,
		},
		aggro = {
			order = 9,
			value = true,
		},
	},
	raid = {
		enable = {
			order = 1,
			value = true,
		},
		showparty = {
			order = 2,
			value = false,
		},
		numgroups = {
			order = 3,
			type = "range",
			value = 8,
			min = 1,
			max = 8,
		},
		unitpergroup = {
			order = 4,
			type = "range",
			value = 5,
			min = 1,
			max = 40,
		},
		growth = {
			order = 5,
			value = "LEFT",
			type = "select",
			select = {"UP", "DOWN", "LEFT", "RIGHT"},
		},
		hgroups = {
			order = 6,
			value = false,
		},
		width = {
			order = 7,
			type = "range",
			value = 36,
			min = 12,
			max = 100,
		},
		height = {
			order = 8,
			type = "range",
			value = 23,
			min = 12,
			max = 100,
		},
		spacing = {
			order = 9,
			type = "range",
			value = 7,
			min = 1,
			max = 20,
		},
		raiddebuffs = {
			order = 10,
			value = true,
		},
		showpower = {
			order = 11,
			value = false,
		},
		tankframes = {
			order = 12,
			value = true,
		},
	},
	colors = {
		healthbyclass = {
			order = 1,
			value = true,
		},
		powerbyclass = {
			order = 2,
			value = false,
		},
		namebyclass = {
			order = 3,
			value = false,
		},
		health = {
			order = 4,
			type = "color",
			value = {0.2, 0.2, 0.2},
		},
		healthbg = {
			order = 5,
			type = "color",
			value = {0.0, 0.0, 0.0},
		},
		powerbg = {
			order = 6,
			type = "color",
			value = {0.0, 0.0, 0.0},
		},
		castcomplete = {
			order = 7,
			type = "color",
			value = {0.12, 0.86, 0.15},
		},
		casting = {
			order = 8,
			type = "color",
			value = {1.0, 0.49, 0},
		},
		channeling = {
			order = 9,
			type = "color",
			value = {0.32, 0.3, 1},
		},
		castfail = {
			order = 10,
			type = "color",
			value = {1.0, 0.09, 0},
		},
	},
	elements ={
		portraits = {
			order = 1,
			value = true,
		},
		gcd = {
			order = 2,
			value = true,
		},
		eclipsebar = {
			order = 3,
			value = true,
		},
		holypower = {
			order = 4,
			value = true,
		},
		combo = {
			order = 5,
			value = true,
		},
		soulshards = {
			order = 6,
			value = true,
		},
		runes = {
			order = 7,
			value = true,
		},
		totembar = {
			order = 8,
			value = true,
		},
		castbar = {
			order = 9,
			value = true,
		},
	},
}

local cfg = {}

UIConfigGUI.unitframes = config
UIConfig.unitframes = cfg

local _, class = UnitClass('player')

local backdrop = {
	bgFile = [=[Interface\ChatFrame\ChatFrameBackground]=],
	edgeFile = [=[Interface\ChatFrame\ChatFrameBackground]=], edgeSize = 1,
	insets = {top = 0, left = 0, bottom = 0, right = 0},
}

local frameBD = {
	edgeFile = glowTex, edgeSize = 5,
	insets = {left = 3, right = 3, top = 3, bottom = 3}
}

local movable = {}
local addon_name = 'UF'
local origColor

local NumRaidGroups = 8
local max = math.max
local floor = math.floor

local colors = setmetatable({
	power = setmetatable({
		MANA = {0.31, 0.45, 1},
	}, {__index = oUF.colors.power}),
	reaction = setmetatable({
		[2] = {1.0, 0.3, 0.3},
		[4] = {0.8, 0.8, 0.2},
		[5] = {0.2, 0.7, 0.2},
	}, {__index = oUF.colors.reaction}),
	runes = setmetatable({
		[1] = {0.77, 0.22, 0.33},
		[2] = {0.2, 0.5, 0.2},
		[3] = {0.2, 0.4, 0.7},
		[4] = {0.8, 0.8, 0.8},
	}, {__index = oUF.colors.runes}),
	class = setmetatable({
		SHAMAN = {0.16, 0.31, 0.61},
	}, {__index = oUF.colors.class}),
}, {__index = oUF.colors})

local channelingTicks = {
	-- warlock
	[GetSpellInfo(1120)] = 6, -- drain soul
	[GetSpellInfo(689)] = 3, -- drain life
	[GetSpellInfo(5740)] = 4, -- rain of fire
	[GetSpellInfo(79268)] = 4, -- soul harvest
	-- druid
	[GetSpellInfo(740)] = 4, -- Tranquility
	[GetSpellInfo(16914)] = 10, -- Hurricane
	-- priest
	[GetSpellInfo(15407)] = 3, -- mind flay
	[GetSpellInfo(48045)] = 5, -- mind sear
	[GetSpellInfo(47540)] = 2, -- penance
	-- mage
	[GetSpellInfo(5143)] = 5, -- arcane missiles
	[GetSpellInfo(10)] = 5, -- blizzard
	[GetSpellInfo(12051)] = 4, -- evocation
}

local dummy = function() end

local indicators = {
	['TR'] = {'TOPRIGHT'},
	['TL'] = {'TOPLEFT'},
	['BR'] = {'BOTTOMRIGHT'},
	['BL'] = {'BOTTOMLEFT'},
}

local auras = {
	[GetSpellInfo(774)]   = {class = 'DRUID', point = 'TR', color = {0.8, 0.4, 0.8}},  -- Rejuvenation
	[GetSpellInfo(94447)] = {class = 'DRUID', point = 'TL', color = {0.2, 0.8, 0.2}},  -- Lifebloom
	[GetSpellInfo(48438)] = {class = 'DRUID', point = 'BR', color = {0.4, 0.8, 0.2}},  -- Wild Growth
	[GetSpellInfo(8936)]  = {class = 'DRUID', point = 'BL', color = {0.8, 0.4, 0}},  -- Regrowth
	[GetSpellInfo(20707)] = {class = 'WARLOCK', point = 'TL', color = {0.9, 0, 0.9}},
	[GetSpellInfo(6788)]  = {class = 'PRIEST', point = 'TR', color = {1, 0, 0}},		-- Weakened Soul
	[GetSpellInfo(33076)] = {class = 'PRIEST', point = 'BR', color = {0.2, 0.7, 0.2}},		-- Prayer of Mending
	[GetSpellInfo(139)]   = {class = 'PRIEST', point = 'BL', color = {0.4, 0.7, 0.2}}, 		-- Renew
	[GetSpellInfo(17)]    = {class = 'PRIEST', point = 'TL', color = {0.81, 0.85, 0.1}},	-- Power Word: Shield
	[GetSpellInfo(53563)] = {class = 'PALADIN', point = 'TR', color = {0.7, 0.3, 0.7}},			-- Beacon of Light
	[GetSpellInfo(1022)]  = {class = 'PALADIN', point = 'BR', color = {0.2, 0.2, 1}},    -- Hand of Protection
	[GetSpellInfo(1044)]  = {class = 'PALADIN', point = 'BR', color = {0.89, 0.45, 0}},  -- Hand of Freedom
	[GetSpellInfo(1038)]  = {class = 'PALADIN', point = 'BR', color = {0.93, 0.75, 0}},  -- Hand of Salvation
	[GetSpellInfo(61295)] = {class = 'SHAMAN', point = 'TR', color = {0.7, 0.3, 0.7}},		-- Riptide 
	[GetSpellInfo(974)]   = {class = 'SHAMAN', point = 'BL', color = {0.2, 0.7, 0.2}},		-- Earth Shield
	[GetSpellInfo(16236)] = {class = 'SHAMAN', point = 'TL', color = {0.4, 0.7, 0.2}},		-- Ancestral Fortitude
	[GetSpellInfo(51945)] = {class = 'SHAMAN', point = 'BR', color = {0.7, 0.4, 0}},		-- Earthliving
}

local CreateShadow = function(parent)
	local shadow = CreateFrame('Frame', nil, parent)
	shadow:SetPoint('TOPLEFT', parent, 'TOPLEFT', -7.5, 7.5)
	shadow:SetPoint('BOTTOMRIGHT', parent, 'BOTTOMRIGHT', 7.5, -7.5)
	shadow:SetFrameStrata('LOW')
	shadow:SetBackdrop(frameBD)
	shadow:SetBackdropColor(0, 0, 0, 0)
	shadow:SetBackdropBorderColor(0, 0, 0)
	return shadow
end

local menu = function(self)
	local unit = self.unit:gsub("(.)", string.upper, 1) 
	if _G[unit.."FrameDropDown"] then
		ToggleDropDownMenu(1, nil, _G[unit.."FrameDropDown"], "cursor")
	elseif self.unit:match("party") then
		ToggleDropDownMenu(1, nil, _G["PartyMemberFrame"..self.id.."DropDown"], "cursor")
	else
		FriendsDropDown.unit = self.unit
		FriendsDropDown.id = self.id
		FriendsDropDown.initialize = RaidFrameDropDown_Initialize
		ToggleDropDownMenu(1, nil, FriendsDropDown, "cursor")
	end
end

local CreateAuraIndicator = function(self)
	self.indicator = {}
	for i, v in pairs(indicators) do
		self.indicator[i] = CreateFrame('Frame', nil, self)
		self.indicator[i]:SetSize(5, 5)
		self.indicator[i]:SetPoint(unpack(v))
		self.indicator[i]:SetFrameStrata('HIGH')
		self.indicator[i]:Hide()
		self.indicator[i].tex = self.indicator[i]:CreateTexture(nil, 'OVERLAY')
		self.indicator[i].tex:SetAllPoints(self.indicator[i])
		self.indicator[i].tex:SetTexture(texture)
		self.indicator[i]:SetBackdrop({
			bgFile = [=[Interface\ChatFrame\ChatFrameBackground]=],
			insets = {top = -1, left = -1, bottom = -1, right = -1},
		})
		self.indicator[i]:SetBackdropColor(0, 0, 0, 1)
	end
end

local UpdateAuraIndicator = function(self, event, unit)
	if self.unit ~= unit then return end
	for i, v in pairs(auras) do
		if class == v.class then
			if UnitAura(unit, i) then
				self.indicator[v.point]:Show()
				self.indicator[v.point].tex:SetVertexColor(unpack(v.color))
			else
				self.indicator[v.point]:Hide()
			end
		end
	end
end

local GetFormattedTime = function(s)
	if s >= 86400 then
		return format('%dd', floor(s/86400 + 0.5))
	elseif s >= 3600 then
		return format('%dh', floor(s/3600 + 0.5))
	elseif s >= 60 then
		return format('%dm', floor(s/60 + 0.5))
	end
	return floor(s + 0.5)
end

local UpdateAuraTimer = function(self, elapsed)
	if self.timeLeft then
		self.elapsed = (self.elapsed or 0) + elapsed
		if self.elapsed >= 0.1 then
			if not self.first then
				self.timeLeft = self.timeLeft - self.elapsed
			else
				self.timeLeft = self.timeLeft - GetTime()
				self.first = false
			end
			if self.timeLeft > 0 then
				local time = GetFormattedTime(self.timeLeft)
				self.remaining:SetText(time)
			else
				self.remaining:Hide()
				self:SetScript('OnUpdate', nil)
			end
			self.elapsed = 0
		end
	end
end

local CreateAuraTimer = function(icon, duration, expTime)
	icon.first = true
	if duration and duration > 0 then
		icon.remaining:Show()
		icon.timeLeft = expTime
		icon:SetScript('OnUpdate', UpdateAuraTimer)
	else
		icon.remaining:Hide()
		icon.timeLeft = 0
		icon:SetScript('OnUpdate', nil)
	end
end

local PostUpdateDebuff = function(self, unit, icon, index)
	local name, _, _, _, dtype, duration, expTime = UnitAura(unit, index, icon.filter)
	local color = DebuffTypeColor[dtype] or DebuffTypeColor.none
	icon.bg:SetBackdropBorderColor(color.r*0.6, color.g*0.6, color.b*0.6)
	icon.icon:SetDesaturated(false)
	CreateAuraTimer(icon, duration, expTime)
end

local PostUpdateBuff = function(self, unit, icon, index)
	local name, _, _, _, dtype, duration, expTime = UnitAura(unit, index, icon.filter)
	CreateAuraTimer(icon, duration, expTime)
end

local PostCreateAuraIcon = function(self, button)
	button.bg = CreateBG(button)
	button.cd:SetReverse()
	button.cd.noCooldownCount = true
	button.icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
	button.icon:SetDrawLayer('ARTWORK')
	button.overlay:SetTexture(nil)
	button.remaining = CreateFS(button, 10)
	button.remaining:SetPoint('CENTER', 1, 1)
	button.count:SetFont(UIConfig.general.fonts.font, UIConfig.general.fonts.size, UIConfig.general.fonts.style)
end

local ticks = {}

local setBarTicks = function(castBar, ticknum)
	if ticknum and ticknum > 0 then
		local delta = castBar:GetWidth() / ticknum
		for k = 1, ticknum do
			if not ticks[k] then
				ticks[k] = castBar:CreateTexture(nil, 'OVERLAY')
				ticks[k]:SetTexture(texture)
				ticks[k]:SetVertexColor(0.6, 0.6, 0.6)
				ticks[k]:SetWidth(1)
				ticks[k]:SetHeight(21)
			end
			ticks[k]:ClearAllPoints()
			ticks[k]:SetPoint('CENTER', castBar, 'LEFT', delta * k, 0 )
			ticks[k]:Show()
		end
	else
		for k, v in pairs(ticks) do
			v:Hide()
		end
	end
end

local OnCastbarUpdate = function(self, elapsed)
	local currentTime = GetTime()
	if self.casting or self.channeling then
		local parent = self:GetParent()
		local duration = self.casting and self.duration + elapsed or self.duration - elapsed
		if (self.casting and duration >= self.max) or (self.channeling and duration <= 0) then
			self.casting = nil
			self.channeling = nil
			return
		end
		if parent.unit == 'player' then
			if self.delay ~= 0 then
				self.Time:SetFormattedText('%.1f/|cffff0000%.1f|r', duration, self.casting and self.max + self.delay or self.max - self.delay)
			else
				self.Time:SetFormattedText('%.1f/%.1f', duration, self.max)
				self.Lag:SetFormattedText('%d ms', self.SafeZone.timeDiff * 1000)
			end
		else
			self.Time:SetFormattedText('%.1f/%.1f', duration, self.casting and self.max + self.delay or self.max - self.delay)
		end
		self.duration = duration
		self:SetValue(duration)
		self.Spark:SetPoint('CENTER', self, 'LEFT', (duration / self.max) * self:GetWidth(), 0)
	elseif self.fadeOut then
		self.Spark:Hide()
		local alpha = self:GetAlpha() - 0.02
		if alpha > 0 then
			self:SetAlpha(alpha)
		else
			self.fadeOut = nil
			self:Hide()
		end
	end
end

local OnCastSent = function(self, event, unit)
	if self.unit ~= unit or not self.Castbar.SafeZone then return end
	self.Castbar.SafeZone.sendTime = GetTime()
end

local PostCastStart = function(self, unit)
	self:SetAlpha(1.0)
	self.Spark:Show()
	self:SetStatusBarColor(unpack(self.casting and self.CastingColor or self.ChannelingColor))
	if self.casting then
		self.cast = true
	else
		self.cast = false
	end
	if unit == 'vehicle' then
		self.SafeZone:Hide()
		self.Lag:Hide()
	elseif unit == 'player' then
		local sf = self.SafeZone
		sf.timeDiff = GetTime() - sf.sendTime
		sf.timeDiff = sf.timeDiff > self.max and self.max or sf.timeDiff
		sf:SetWidth(self:GetWidth() * sf.timeDiff / self.max)
		sf:Show()
		self.Lag:Show()
		if self.casting then
			setBarTicks(self, 0)
		else
			local spell = UnitChannelInfo(unit)
			self.channelingTicks = channelingTicks[spell] or 0
			setBarTicks(self, self.channelingTicks)
		end
	end
end

local PostCastStop = function(self, unit)
	if not self.fadeOut then
		self:SetStatusBarColor(unpack(self.CompleteColor))
		self.fadeOut = true
	end
	self:SetValue(self.cast and self.max or 0)
	self:Show()
end

local PostCastFailed = function(self, event, unit)
	self:SetStatusBarColor(unpack(self.FailColor))
	self:SetValue(self.max)
	if not self.fadeOut then
		self.fadeOut = true
	end
	self:Show()
end

local UpdateAuraTrackerTime = function(self, elapsed)
	if self.active then
		self.timeleft = self.timeleft - elapsed
		if self.timeleft <= 5 then
			self.text:SetTextColor(1, 0, 0) -- red
		else
			self.text:SetTextColor(1, 1, 1) -- white
		end
		if self.timeleft <= 0 then
			self.icon:SetTexture('')
			self.text:SetText('')
		end	
		self.text:SetFormattedText('%.1f', self.timeleft)
	end
end

local UpdateThreat = function(self, event, unit)
	if unit and self.unit ~= unit then return end
	if not unit or not UnitExists(unit) then
		self.background:SetBackdropBorderColor(unpack(origColor))
		return
	end
	local status = UnitThreatSituation(self.unit)
	if status and status > 1 then
		r, g, b = GetThreatStatusColor(status)
		self.background:SetBackdropBorderColor(r, g, b)
	else
		self.background:SetBackdropBorderColor(unpack(origColor))
	end
end

local PreUpdatePortrait = function(self, unit)
	if not UnitExists(unit) or not UnitIsConnected(unit) or not UnitIsVisible(unit) then
		self:Hide()
		self.__owner.PortraitTexture:Show()
		SetPortraitTexture(self.__owner.PortraitTexture, unit)
	else
		self:Show()
		self.__owner.PortraitTexture:Hide()
	end
end

local PostUpdateBar = function(self, unit, min, max)
	if not UnitIsConnected(unit) or UnitIsGhost(unit) or UnitIsDead(unit) then
		self:SetValue(0)
	end
end

local EclipseDirChange = function(self)
	if GetEclipseDirection() == "sun" then
		self.Dir:SetText('|cff4478BC>>>|r')
	elseif GetEclipseDirection() == "moon" then
		self.Dir:SetText('|cffE5994C<<<|r')
	else
		self.Dir:SetText("")
	end
end

local UpdateComboPoint = function(self, event, unit)
	if unit == 'pet' then return end

	local cp
	if UnitHasVehicleUI('player') then
		cp = GetComboPoints('vehicle', 'target')
	else
		cp = GetComboPoints('player', 'target')
	end

	local cpoints = self.CPoints
	if cp == 0 then
		cpoints:Hide()
		return
	else
		cpoints:Show()
	end
	for i = 1, MAX_COMBO_POINTS do
		if i <= cp then
			cpoints[i]:Show()
		else
			cpoints[i]:Hide()
		end
	end 
end

local CreateStyle = function(self, unit)
	self.colors = colors
	self.menu = menu
	self:RegisterForClicks('AnyUp')

	local unit = unit:find('arena%dtarget') and 'arenatarget' or
		unit:find('arena%d') and 'arena' or
		unit:find('boss%d') and 'boss' or
		(self:GetParent():GetName():match(addon_name..'_Party')) and 'party' or
		(self:GetParent():GetName():match(addon_name..'_Raid')) and 'raid' or
		(self:GetParent():GetName():match(addon_name..'_MainTank')) and 'tank' or unit

	if unit == 'arena' then
		self:SetAttribute('*type2', 'focus')
	end

	self:SetScript('OnEnter', UnitFrame_OnEnter)
	self:SetScript('OnLeave', UnitFrame_OnLeave)

	self.Health = CreateFrame('StatusBar', nil, self)
	self.Health:SetPoint('TOPLEFT', self)
	self.Health:SetPoint('TOPRIGHT', self)

	self.Health:SetStatusBarTexture(texture)
	self.colors.health = cfg.colors.health
	if unit == 'raid' and cfg.raid.showpower then
		self.Health:SetPoint("TOPLEFT")
		self.Health:SetPoint("TOPRIGHT")
		self.Health:SetHeight(self:GetHeight() - 3)
	else
		self.Health:SetAllPoints(self)
	end
	self.Health.frequentUpdates = true
	self.Health.Smooth = cfg.general.smooth
	self.Health.PostUpdate = PostUpdateBar

	self.Health.colorTapping = not cfg.colors.healthbyclass
	self.Health.colorClass = cfg.colors.healthbyclass or unit == 'arenatarget'
	self.Health.colorReaction = cfg.colors.healthbyclass
	self.Health.colorHealth = not cfg.colors.healthbyclass

	self.Health.bg = self.Health:CreateTexture(nil, 'BACKGROUND')
	self.Health.bg:SetTexture(texture)
	self.Health.bg:SetVertexColor(unpack(cfg.colors.healthbg))
	self.Health.bg:SetAllPoints()
	self.Health.bg.multiplier = 0.15

	self.background = CreateBG(self)
	origColor = {self.background:GetBackdropBorderColor()}

	self.Power = CreateFrame('StatusBar', nil, self)
	if unit == 'player' or unit == 'target' then
		if unit == 'player' then
			self.Power:SetPoint('BOTTOMRIGHT', self.Health, -10, -4)
		else
			self.Power:SetPoint('BOTTOMLEFT', self.Health, 10, -4)
		end
		self.Power:SetHeight(5)
		self.Power:SetWidth(130)
		self.Power:SetFrameLevel(self.Health:GetFrameLevel()+2)
		self.Power.background = CreateBG(self.Power)
	elseif unit == 'boss' or unit == 'arena' then
		self.Power:SetPoint('BOTTOMRIGHT', self.Health, -10, -3)
		self.Power:SetHeight(3)
		self.Power:SetWidth(100)
		self.Power:SetFrameLevel(self.Health:GetFrameLevel()+2)
		self.Power.background = CreateBG(self.Power)
	elseif unit == 'party' then
		if not cfg.raid.showparty then
			self.Power:SetPoint('BOTTOMRIGHT', self.Health, -10, -3)
			self.Power:SetHeight(3)
			self.Power:SetWidth(100)
			self.Power:SetFrameLevel(self.Health:GetFrameLevel()+2)
			self.Power.background = CreateBG(self.Power)
		else
			self.Power:SetPoint("BOTTOMLEFT")
			self.Power:SetPoint("BOTTOMRIGHT")
			self.Power:SetHeight(2)
		end
	elseif unit == 'raid' and cfg.raid.showpower then
		self.Power:SetPoint("BOTTOMLEFT")
		self.Power:SetPoint("BOTTOMRIGHT")
		self.Power:SetHeight(2)
	else
		self.Power:Hide()
	end
	self.Power:SetStatusBarTexture(texture)
	self.Power.frequentUpdates = true
	self.Power.Smooth = cfg.general.smooth
	self.Power.PostUpdate = PostUpdateBar

	self.Power.colorPower = not cfg.colors.powerbyclass
	self.Power.colorReaction = true
	self.Power.colorClass = cfg.colors.powerbyclass

	self.Power.bg = self.Power:CreateTexture(nil, 'BACKGROUND')
	self.Power.bg:SetTexture(texture)
	self.Power.bg:SetAllPoints()
	self.Power.bg.multiplier = 0.15

	self.Leader = self.Health:CreateTexture(nil, 'OVERLAY')
	self.Leader:SetPoint('TOPLEFT', self, 0, 8)
	self.Leader:SetHeight(14)
	self.Leader:SetWidth(14)

	self.RaidIcon = self.Health:CreateTexture(nil, 'OVERLAY')
	self.RaidIcon:SetPoint('TOPRIGHT', self, -14, 8)
	self.RaidIcon:SetHeight(14)
	self.RaidIcon:SetWidth(14)

	-- Trinket status
	if unit == 'arena' then
		self.Trinket = CreateFrame('Frame', nil, self)
		self.Trinket:SetHeight(27)
		self.Trinket:SetWidth(27)
		self.Trinket:SetPoint('TOPRIGHT', self, 'TOPLEFT', -5, 0)
		self.Trinket.bg = CreateBG(self.Trinket)
		self.Trinket.trinketUseAnnounce = true
	end

	-- Aura Tracker
	if unit == 'arena' then
		self.AuraTracker = CreateFrame('Frame', nil, self)
		self.AuraTracker:SetAllPoints(self.Trinket)
		self.AuraTracker:SetFrameStrata('HIGH')
		self.AuraTracker.icon = self.AuraTracker:CreateTexture(nil, 'ARTWORK')
		self.AuraTracker.icon:SetAllPoints(self.AuraTracker)
		self.AuraTracker.icon:SetTexCoord(0.07,0.93,0.07,0.93)
		self.AuraTracker.text = self.AuraTracker:CreateFontString(nil, 'OVERLAY', 'NumberFontNormal')
		self.AuraTracker.text:SetPoint('CENTER', self.AuraTracker, 0, 0)
		self.AuraTracker:SetScript('OnUpdate', UpdateAuraTrackerTime)
	end

	-- Info text
	if unit == 'target' then
		local Info = CreateFS(self.Power)
		Info:SetPoint('LEFT', self.Power, 3, 1)
		self:Tag(Info, ' ')
	end

	if unit == 'target' or unit == 'player' or unit == 'arena' then
		local power = CreateFS(self.Power)
		power:SetPoint('CENTER', self.Power, 3, 1)
		self:Tag(power, '[allez:druid][allez:power]')
	end

	if unit == 'target' or unit == 'player' or unit == 'focus' or unit == 'targettarget' or 
		unit == 'focustarget' or unit == 'boss' or unit == 'arena' or unit == 'party' then
		local name = CreateFS(self.Health)
		name:SetPoint('LEFT', 3, 1)
		name:SetPoint('RIGHT', -60, 1)
		name:SetJustifyH'LEFT'
		self:Tag(name, (unit == 'target' and '[allez:level][rare] ' or '') .. (cfg.colors.namebyclass and '[allez:name]' or '[name]'))
	end

	if unit == 'raid' or unit == 'tank' then
		local name = CreateFS(self.Health)
		name:SetPoint('CENTER', 1, 1)
		self:Tag(name, cfg.colors.namebyclass and '[raidnameclass]' or '[raidname]')
	end

	if not (unit == 'arenatarget' or unit == 'raid' or unit == 'tank') then
		local health = CreateFS(self.Health)
		health:SetPoint('RIGHT', -2, 1)
		health:SetJustifyH'RIGHT'
		self:Tag(health, '[allez:health]')
	end

	-- Player frame
	if unit == 'player' then
		if cfg.elements.gcd then
			self.GCD = CreateFrame('Frame', nil, self)
			self.GCD:SetWidth(213)
			self.GCD:SetHeight(4)
			self.GCD:SetFrameStrata('HIGH')
			self.GCD:SetPoint('BOTTOMLEFT', self.Health, 'TOPLEFT', 0, 1)
			self.GCD.Color = {1, 1, 1}
			self.GCD.Height = 6
			self.GCD.Width = 15
		end

		if class == 'DRUID' and cfg.elements.eclipsebar then
			self.EclipseBar = CreateFrame('Frame', addon_name.."_EclipseBar", self)
			self.EclipseBar:SetPoint('TOPLEFT', self.Health, 10, 4)
			self.EclipseBar:SetSize(130, 5)
			self.EclipseBar:SetFrameLevel(self.Health:GetFrameLevel()+2)
			self.EclipseBar:SetFrameStrata('MEDIUM')
			self.EclipseBar.bg = CreateBG(self.EclipseBar)
			self.EclipseBar.LunarBar = CreateFrame('StatusBar', nil, self.EclipseBar)
			self.EclipseBar.LunarBar:SetPoint('LEFT', self.EclipseBar)
			self.EclipseBar.LunarBar:SetSize(self.EclipseBar:GetWidth(), self.EclipseBar:GetHeight())
			self.EclipseBar.LunarBar:SetStatusBarTexture(texture)
			self.EclipseBar.LunarBar:SetStatusBarColor(0.30, 0.52, 0.90)
			self.EclipseBar.SolarBar = CreateFrame('StatusBar', nil, self.EclipseBar)
			self.EclipseBar.SolarBar:SetPoint('LEFT', self.EclipseBar.LunarBar:GetStatusBarTexture(), 'RIGHT', 0, 0)
			self.EclipseBar.SolarBar:SetSize(self.EclipseBar:GetWidth(), self.EclipseBar:GetHeight())
			self.EclipseBar.SolarBar:SetStatusBarTexture(texture)
			self.EclipseBar.SolarBar:SetStatusBarColor(0.90, 0.92, 0.30)
			self.EclipseBar.Dir = CreateFS(self.EclipseBar.LunarBar)
			self.EclipseBar.Dir:SetPoint("CENTER", self.EclipseBar, "CENTER", -6, 1)
			self.EclipseBar.PostUpdatePower = EclipseDirChange
			self.EclipseBar.Text = CreateFS(self.EclipseBar.LunarBar)
			self.EclipseBar.Text:SetPoint("LEFT", self.EclipseBar.Dir, "RIGHT", 2, 0)
			self:Tag(self.EclipseBar.Text, '[pereclipse] %')
		end

		if class == 'DEATHKNIGHT' and cfg.elements.runes then
			self.Runes = CreateFrame('Frame', addon_name.."_RuneBar", self)
			self.Runes:SetPoint('TOPLEFT', self.Health, 10, 4)
			self.Runes:SetSize(130, 5)
			self.Runes:SetFrameLevel(self.Health:GetFrameLevel()+2)
			self.Runes.bg = CreateBG(self.Runes)
			for i = 1, 6 do
				self.Runes[i] = CreateFrame('StatusBar', nil, self.Runes)
				self.Runes[i]:SetStatusBarTexture(texture)
				self.Runes[i]:SetSize(self.Runes:GetWidth() / 6 - 0.85, self.Runes:GetHeight())
				self.Runes[i].bg = self.Runes[i]:CreateTexture(nil, 'BACKGROUND')
				self.Runes[i].bg:SetTexture(texture)
				self.Runes[i].bg:SetAllPoints()
				self.Runes[i].bg.multiplier = 0.25
				if i == 1 then
					self.Runes[i]:SetPoint('LEFT')
				else
					self.Runes[i]:SetPoint('LEFT', self.Runes[i-1], 'RIGHT', 1, 0)
				end
			end
		end

		if class == 'SHAMAN' and UnitLevel('player') >= 20 and cfg.elements.totembar then
			self.TotemBar = CreateFrame('Frame', addon_name.."_TotemBar", self)
			self.TotemBar:SetPoint('TOPLEFT', self.Health, 10, 4)
			self.TotemBar:SetSize(130, 5)
			self.TotemBar:SetFrameLevel(self.Health:GetFrameLevel()+2)
			self.TotemBar.bg = CreateBG(self.TotemBar)
			for i = 1, 4 do
				self.TotemBar[i] = CreateFrame('StatusBar', nil, self.TotemBar)
				self.TotemBar[i]:SetStatusBarTexture(texture)
				self.TotemBar[i]:SetSize(self.TotemBar:GetWidth() / 4 - 0.85, self.TotemBar:GetHeight())
				self.TotemBar[i]:SetMinMaxValues(0, 1)
				self.TotemBar[i].bg = self.TotemBar:CreateTexture(nil, 'BACKGROUND')
				self.TotemBar[i].bg:SetTexture(texture)
				self.TotemBar[i].bg:SetAllPoints()
				self.TotemBar[i].bg.multiplier = 0.15
				if i == 1 then
					self.TotemBar[i]:SetPoint('LEFT')
				else
					self.TotemBar[i]:SetPoint('LEFT', self.TotemBar[i-1], 'RIGHT', 1, 0)
				end
			end
		end

		if class == 'WARLOCK' and cfg.elements.soulshards then
			self.SoulShards = CreateFrame('Frame', addon_name.."_SoulShards", UIParent)
			self.SoulShards:SetPoint('TOPLEFT', self.Health, 10, 4)
			self.SoulShards:SetSize(130, 5)
			self.SoulShards:SetFrameLevel(self.Health:GetFrameLevel()+2)
			self.SoulShards.bg = CreateBG(self.SoulShards)
			for i = 1, 3 do
				self.SoulShards[i] = CreateFrame('StatusBar', nil, self.SoulShards)
				self.SoulShards[i]:SetStatusBarTexture(texture)
				self.SoulShards[i]:SetSize(self.SoulShards:GetWidth() / 3 - 0.85, self.SoulShards:GetHeight())					
				self.SoulShards[i]:SetStatusBarColor(0.90, 0.42, 0.85)
				self.SoulShards[i].bg = self.SoulShards:CreateTexture(nil, 'BACKGROUND')
				self.SoulShards[i].bg:SetTexture(texture)
				self.SoulShards[i].bg:SetVertexColor(0.2, 0.1, 0.2)
				self.SoulShards[i].bg:SetAllPoints(self.SoulShards[i])
				if i == 1 then
					self.SoulShards[i]:SetPoint('LEFT')
				else
					self.SoulShards[i]:SetPoint('LEFT', self.SoulShards[i-1], 'RIGHT', 1, 0)
				end
			end
		end

		if class == 'PALADIN' and cfg.elements.holypower then
			self.HolyPower = CreateFrame('Frame', addon_name.."_HolyPower", self)
			self.HolyPower:SetPoint('TOPLEFT', self.Health, 10, 4)
			self.HolyPower:SetSize(130, 5)
			self.HolyPower:SetFrameLevel(self.Health:GetFrameLevel()+2)
			self.HolyPower.bg = CreateBG(self.HolyPower)
			for i = 1, 3 do
				self.HolyPower[i] = CreateFrame('StatusBar', nil, self.HolyPower)
				self.HolyPower[i]:SetStatusBarTexture(texture)
				self.HolyPower[i]:SetSize(self.HolyPower:GetWidth() / 3 - 0.85, self.HolyPower:GetHeight())					
				self.HolyPower[i]:SetStatusBarColor(0.95, 0.90, 0.60)
				self.HolyPower[i].bg = self.HolyPower:CreateTexture(nil, 'BACKGROUND')
				self.HolyPower[i].bg:SetTexture(texture)
				self.HolyPower[i].bg:SetVertexColor(0.2, 0.2, 0.1)
				self.HolyPower[i].bg:SetAllPoints(self.HolyPower[i])
				if i == 1 then
					self.HolyPower[i]:SetPoint('LEFT')
				else
					self.HolyPower[i]:SetPoint('LEFT', self.HolyPower[i-1], 'RIGHT', 1, 0)
				end
			end
		end
	end

	-- Alternative power bar
	if unit == 'player' or unit == 'boss' then
		self.AltPowerBar = CreateFrame("StatusBar", nil, self.Health)
		self.AltPowerBar:SetFrameLevel(self.Health:GetFrameLevel() + 1)
		self.AltPowerBar:SetHeight(4)
		self.AltPowerBar:SetStatusBarTexture(texture)
		self.AltPowerBar:GetStatusBarTexture():SetHorizTile(false)
		self.AltPowerBar:SetStatusBarColor(1, 0, 0)
		self.AltPowerBar:SetPoint("LEFT")
		self.AltPowerBar:SetPoint("RIGHT")
		self.AltPowerBar:SetPoint("TOP", self.Health, "TOP")
	end

	-- Combo points
	if unit == 'target' and cfg.elements.combo then
		self.CPoints = CreateFrame("Frame", nil, self)
		self.CPoints:SetPoint('TOPRIGHT', self.Health, -10, 4)
		self.CPoints:SetSize(130, 5)
		self.CPoints:SetFrameLevel(self.CPoints:GetFrameLevel()+2)
		self.CPoints.bg = CreateBG(self.CPoints)
		for i = 1, 5 do
			self.CPoints[i] = CreateFrame("StatusBar", nil, self.CPoints)
			self.CPoints[i]:SetSize(self.CPoints:GetWidth() / 5 - 0.85, 5)
			self.CPoints[i]:SetStatusBarTexture(texture)
			if i == 1 then
				self.CPoints[i]:SetPoint("LEFT", self.CPoints)
			else
				self.CPoints[i]:SetPoint("LEFT", self.CPoints[i-1], "RIGHT", 1, 0)
			end
		end
		self.CPoints[1]:SetStatusBarColor(0.9, 0.1, 0.1)
		self.CPoints[2]:SetStatusBarColor(0.9, 0.1, 0.1)
		self.CPoints[3]:SetStatusBarColor(0.9, 0.9, 0.1)
		self.CPoints[4]:SetStatusBarColor(0.9, 0.9, 0.1)
		self.CPoints[5]:SetStatusBarColor(0.1, 0.9, 0.1)
		self.CPoints.Override = UpdateComboPoint
	end

	-- Auras
	if (unit == 'focus' and cfg.general.focusdebuffs) or 
	   (unit == 'targettarget' and cfg.general.totdebuffs) or 
	   (unit == 'pet' and cfg.general.petdebuffs) then
		self.Debuffs = CreateFrame('Frame', addon_name..unit.."_Debuffs", self)
		self.Debuffs:SetPoint('BOTTOMLEFT', self, 'TOPLEFT', 0, 6)
		self.Debuffs:SetHeight(22)
		self.Debuffs:SetWidth(105)
		self.Debuffs.num = 4
		self.Debuffs.size = 22
		self.Debuffs.spacing = 5
		self.Debuffs.disableCooldown = not cfg.general.auraspiral
		self.Debuffs.initialAnchor = 'TOPLEFT'
		if (unit == 'focus') then
			self.BarFade = true
			self.Debuffs.onlyShowPlayer = true
		end
		self.Debuffs.PostCreateIcon = PostCreateAuraIcon
		self.Debuffs.PostUpdateIcon = PostUpdateDebuff
		tinsert(UIMovableFrames, self.Debuffs)
	end

	if unit == 'target' then
		self.Buffs = CreateFrame('Frame', addon_name.."_TargetBuffs", self)
		self.Buffs:SetPoint('TOPLEFT', self, 'BOTTOMLEFT', 0, -10)
		self.Buffs:SetHeight(50)
		self.Buffs:SetWidth(215)
		self.Buffs.num = 16
		self.Buffs.size = 22
		self.Buffs.spacing = 5
		self.Buffs.disableCooldown = not cfg.general.auraspiral
		self.Buffs.initialAnchor = 'TOPLEFT'
		self.Buffs['growth-y'] = 'DOWN'
		self.Buffs.PostCreateIcon = PostCreateAuraIcon
		self.Buffs.PostUpdateIcon = PostUpdateBuff
		tinsert(UIMovableFrames, self.Buffs)

		if cfg.general.targetdebuffs then
			self.Debuffs = CreateFrame('Frame', addon_name.."_TargetDebuffs", self)
			self.Debuffs:SetPoint('BOTTOMLEFT', self, 'TOPRIGHT', 7, 7)
			self.Debuffs:SetHeight(130)
			self.Debuffs:SetWidth(180)
			self.Debuffs.size = 18
			self.Debuffs.spacing = 5
			self.Debuffs.disableCooldown = not cfg.general.auraspiral
			self.Debuffs.initialAnchor = 'BOTTOMLEFT'
			self.Debuffs['growth-x'] = 'RIGHT'
			self.Debuffs['growth-y'] = 'UP'
			self.Debuffs.PostCreateIcon = PostCreateAuraIcon
			self.Debuffs.PostUpdateIcon = PostUpdateDebuff
			tinsert(UIMovableFrames, self.Debuffs)
		end
	end

	if unit == 'player' then
		self.Debuffs = CreateFrame('Frame', addon_name.."_PlayerDebuffs", self)
		self.Debuffs:SetPoint('TOPLEFT', self, 'BOTTOMLEFT', 0, -10)
		self.Debuffs.initialAnchor = 'TOPLEFT'
		self.Debuffs['growth-x'] = 'RIGHT'
		self.Debuffs['growth-y'] = 'DOWN'
		self.Debuffs:SetHeight(50)
		self.Debuffs:SetWidth(215)
		self.Debuffs.spacing = 5
		self.Debuffs.size = 22
		self.Debuffs.disableCooldown = not cfg.general.auraspiral
		self.Debuffs.PostCreateIcon = PostCreateAuraIcon
		self.Debuffs.PostUpdateIcon = PostUpdateDebuff
	end

	if unit == 'raid' and cfg.raid.raiddebuffs then
		self.RaidDebuffs = CreateFrame('Frame', nil, self)
		self.RaidDebuffs:SetHeight(19)
		self.RaidDebuffs:SetWidth(19)
		self.RaidDebuffs:SetPoint('CENTER', self)
		self.RaidDebuffs:SetFrameStrata'HIGH'
		self.RaidDebuffs:SetBackdrop({
			bgFile = [=[Interface\ChatFrame\ChatFrameBackground]=],
			insets = {top = -1, left = -1, bottom = -1, right = -1},
		})
		self.RaidDebuffs:SetBackdropColor(0, 0, 0, 1)
		self.RaidDebuffs.icon = self.RaidDebuffs:CreateTexture(nil, 'OVERLAY')
		self.RaidDebuffs.icon:SetTexCoord(.07,.93,.07,.93)
		self.RaidDebuffs.icon:SetAllPoints(self.RaidDebuffs)
		self.RaidDebuffs.time = CreateFS(self.RaidDebuffs)
		self.RaidDebuffs.time:SetPoint('CENTER', self.RaidDebuffs, 'CENTER', 0, 0)
		self.RaidDebuffs.time:SetTextColor(1, .9, 0)
		self.RaidDebuffs.count = CreateFS(self.RaidDebuffs)
		self.RaidDebuffs.count:SetPoint('BOTTOMRIGHT', self.RaidDebuffs, 'BOTTOMRIGHT', 2, 0)
 		self.RaidDebuffs.ShowDispelableDebuff = true
		self.RaidDebuffs.FilterDispelableDebuff = true
		self.RaidDebuffs.ShowBossDebuff = true
		self.RaidDebuffs.MatchBySpellName = true
		self.RaidDebuffs.Debuffs = ns.raid_debuffs
	end

	if (unit == 'raid' or unit == 'party') then
		CreateAuraIndicator(self)
		self:RegisterEvent('UNIT_AURA', UpdateAuraIndicator)
		self:RegisterEvent('PLAYER_TARGET_CHANGED', UpdateAuraIndicator)
	end

	-- Cast bars
	if (unit == 'player' or unit == 'target' or unit == 'focus' or unit == 'arena') and cfg.elements.castbar then
		self.Castbar = CreateFrame('StatusBar', addon_name.."_Castbar_"..self.unit, self)
		self.Castbar:SetWidth(215 - 26)
		self.Castbar:SetHeight(21)
		self.Castbar:SetStatusBarTexture(texture)
		self.Castbar:SetStatusBarColor(1.0, 0.49, 0)
		self.Castbar.bg = CreateBG(self.Castbar)

		self.Castbar.Text = CreateFS(self.Castbar)
		self.Castbar.Text:SetPoint('LEFT', 2, 1)
		self.Castbar.Text:SetPoint('RIGHT', -50, 1)
		self.Castbar.Text:SetJustifyH('LEFT')

		self.Castbar.Time = CreateFS(self.Castbar)
		self.Castbar.Time:SetPoint('RIGHT', -2, 1)

		self.Castbar.CastingColor = cfg.colors.casting
		self.Castbar.CompleteColor = cfg.colors.castcomplete
		self.Castbar.FailColor = cfg.colors.castfail
		self.Castbar.ChannelingColor = cfg.colors.channeling

		self.Castbar.Button = CreateFrame('Frame', nil, self.Castbar)
		self.Castbar.Button:SetHeight(21)
		self.Castbar.Button:SetWidth(21)
		self.Castbar.Button.bg = CreateBG(self.Castbar.Button)

		if unit == 'target' then
			self.Castbar:SetPoint('BOTTOMLEFT', self, 'TOPLEFT', 0, 70)
			self.Castbar.Button:SetPoint('BOTTOMLEFT', self.Castbar, 'BOTTOMRIGHT', 5, 0)
			self.Castbar.Shield = CreateShadow(self.Castbar.Button)
			self.Castbar.Shield:SetBackdropBorderColor(1, 0, 0, 1)
			tinsert(UIMovableFrames, self.Castbar)
		elseif unit == 'focus' then
			self.Castbar:SetPoint('BOTTOMLEFT', self, 'TOPLEFT', -112 + 26, 38)
			self.Castbar.Button:SetPoint('BOTTOMRIGHT', self.Castbar, 'BOTTOMLEFT', -5, 0)
			self.Castbar.Shield = CreateShadow(self.Castbar.Button)
			self.Castbar.Shield:SetBackdropBorderColor(1, 0, 0, 1)
			tinsert(UIMovableFrames, self.Castbar)
		elseif unit == 'player' then
			self.Castbar:SetPoint('BOTTOM', UIParent, 'BOTTOM', 13, 145)
			self.Castbar.Button:SetPoint('BOTTOMRIGHT', self.Castbar, 'BOTTOMLEFT', -5, 0)
			self.Castbar.SafeZone = self.Castbar:CreateTexture(nil, 'BORDER')
			self.Castbar.SafeZone:SetTexture(texture)
			self.Castbar.SafeZone:SetVertexColor(.8,.11,.15)
			self.Castbar.Lag = CreateFS(self.Castbar, 10, 'OUTLINEMONOCHROME')
			self.Castbar.Lag:SetPoint('BOTTOMRIGHT', -2, -1)
			self.Castbar.Lag:SetJustifyH('RIGHT')
			self:RegisterEvent('UNIT_SPELLCAST_SENT', OnCastSent)
			tinsert(UIMovableFrames, self.Castbar)
		else
			self.Castbar:SetPoint('TOPLEFT', self, 'BOTTOMLEFT', 0, -10)
			self.Castbar:SetPoint('TOPRIGHT', self, 'BOTTOMRIGHT', 0, -10)
			self.Castbar:SetHeight(7)
			self.Castbar.Button:SetPoint('BOTTOMRIGHT', self.Castbar, 'BOTTOMLEFT', -5, 0)
			self.Castbar.Button:SetSize(7, 7)
		end

		self.Castbar.Spark = self.Castbar:CreateTexture(nil,'OVERLAY')
		self.Castbar.Spark:SetBlendMode('Add')
		self.Castbar.Spark:SetHeight(self.Castbar:GetHeight() * 2)
		self.Castbar.Spark:SetWidth(20)
		self.Castbar.Spark:SetVertexColor(1, 1, 1)

		self.Castbar.Icon = self.Castbar.Button:CreateTexture(nil, 'ARTWORK')
		self.Castbar.Icon:SetAllPoints(self.Castbar.Button)
		self.Castbar.Icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)

		self.Castbar.OnUpdate = OnCastbarUpdate
		self.Castbar.PostCastStart = PostCastStart
		self.Castbar.PostChannelStart = PostCastStart
		self.Castbar.PostCastStop = PostCastStop
		self.Castbar.PostChannelStop = PostCastStop
		self.Castbar.PostCastFailed = PostCastFailed
		self.Castbar.PostCastInterrupted = PostCastFailed
	end

	-- Portraits
	if (unit == 'target' or unit == 'player') and cfg.elements.portraits then
		local PortHolder = CreateFrame('Frame', nil, self)
		PortHolder:SetSize(40, 31)
		if unit == 'player' then
			PortHolder:SetPoint('TOPRIGHT', self, 'TOPLEFT', -7, 0)
		else
			PortHolder:SetPoint('TOPLEFT', self, 'TOPRIGHT', 7, 0)
		end
		PortHolder.bg = CreateBG(PortHolder)
		self.PortraitTexture = PortHolder:CreateTexture(nil, 'ARTWORK')
		self.PortraitTexture:SetAllPoints()
		self.PortraitTexture:SetTexCoord(0.14644660941, 0.85355339059, 0.24644660941, 0.85355339059)
		self.Portrait = CreateFrame('PlayerModel', nil, PortHolder)
		self.Portrait:SetPoint("TOPLEFT", -0.5, 0)
		self.Portrait:SetPoint("BOTTOMRIGHT", -0.5, 0)
		self.Portrait.PreUpdate = PreUpdatePortrait
		-- Combat text
		self.CombatFeedbackText = CreateFS(self.Portrait, 16, 'OUTLINE', stdfont)
		self.CombatFeedbackText:SetPoint('CENTER')
		-- Auras on portraits
		self.AuraTracker = CreateFrame('Frame', nil, self)
		self.AuraTracker:SetAllPoints(self.Portrait)
		self.AuraTracker:SetFrameStrata('HIGH')
		self.AuraTracker.icon = self.AuraTracker:CreateTexture(nil, 'ARTWORK')
		self.AuraTracker.icon:SetAllPoints(self.AuraTracker)
		self.AuraTracker.icon:SetTexCoord(0.07,0.93,0.07,0.93)
		self.AuraTracker.text = self.AuraTracker:CreateFontString(nil, 'OVERLAY', 'NumberFontNormal')
		self.AuraTracker.text:SetPoint('CENTER', self.AuraTracker, 0, 0)
		self.AuraTracker:SetScript('OnUpdate', UpdateAuraTrackerTime)
	end

	-- Threat background
	if self:GetAttribute('unitsuffix') ~= 'target' and unit ~= 'arena' and unit ~= 'boss' and cfg.general.aggro then
		self:RegisterEvent('UNIT_THREAT_SITUATION_UPDATE', UpdateThreat)
		self:RegisterEvent('UNIT_THREAT_LIST_UPDATE', UpdateThreat)
		self:RegisterEvent('ZONE_CHANGED_NEW_AREA', UpdateThreat)
		self:RegisterEvent('PLAYER_TARGET_CHANGED', UpdateThreat)
	end

	-- Player icons
	if unit=='player' then
		self.Resting = self.Health:CreateTexture(nil, 'OVERLAY')
		self.Resting:SetHeight(18)
		self.Resting:SetWidth(18)
		self.Resting:SetPoint('TOPRIGHT',self,10,10)
		self.Combat = self.Health:CreateTexture(nil, 'OVERLAY')
		self.Combat:SetHeight(20)
		self.Combat:SetWidth(20)
		self.Combat:SetPoint('BOTTOMRIGHT',self,10,-10)
	end

	-- Party icons
	if unit == 'party' then
		self.LFDRole = self:CreateTexture(nil, 'OVERLAY') 
		self.LFDRole:SetHeight(16) 
		self.LFDRole:SetWidth(16)
		self.LFDRole:SetPoint('LEFT', self, 'RIGHT', 2, 0)
	end

	-- Range and Ready check
	if (unit == 'raid' or unit == 'party') then
		self.Range = {
			insideAlpha = 1.0,
			outsideAlpha = 0.3,
		}
	end

	if unit == 'raid' or unit == 'party' then
		self.ReadyCheck = self.Health:CreateTexture(nil, 'OVERLAY')
		self.ReadyCheck:SetPoint('TOPLEFT', self, -5, 5)
		self.ReadyCheck:SetHeight(16)
		self.ReadyCheck:SetWidth(16)
	end

	return self
end



-- Spawning
oUF:Factory(function(self)
	self:RegisterStyle('Allez', CreateStyle)
	self:SetActiveStyle('Allez')

	local player = self:Spawn('player', addon_name..'_Player')
	player:SetSize(215, 27)
	player:SetPoint('BOTTOM', UIParent, -190, 240)
	tinsert(UIMovableFrames, player)

	local target = self:Spawn('target', addon_name..'_Target')
	target:SetSize(215, 27)
	target:SetPoint('BOTTOM', UIParent, 190, 240)
	tinsert(UIMovableFrames, target)

	local targettarget = self:Spawn('targettarget', addon_name..'_ToT')
	targettarget:SetPoint('BOTTOMRIGHT', target, 'TOPRIGHT', 0, 9)
	targettarget:SetSize(103, 24)
	tinsert(UIMovableFrames, targettarget)

	local pet = self:Spawn('pet', addon_name..'_Pet')
	pet:SetPoint('BOTTOMLEFT', player, 'TOPLEFT', 0, 9)
	pet:SetSize(103, 24)
	tinsert(UIMovableFrames, pet)

	local focus = self:Spawn('focus', addon_name..'_Focus')
	focus:SetPoint('TOPLEFT', pet, 'TOPRIGHT', 9, 0)
	focus:SetSize(103, 24)
	tinsert(UIMovableFrames, focus)

	local focustarget = self:Spawn('focustarget', addon_name..'_FocusTarget')
	focustarget:SetPoint('BOTTOMLEFT', target, 'TOPLEFT', 0, 9)
	focustarget:SetSize(103, 24)
	tinsert(UIMovableFrames, focustarget)

	if not cfg.raid.showparty then
		local party = self:SpawnHeader(addon_name..'_Party', nil, 'custom [@raid6,exists] hide;show',
			'oUF-initialConfigFunction', [[
				self:SetAttribute('*type1', 'target')
				self:SetWidth(150)
				self:SetHeight(25)
				self:SetAttribute('toggleForVehicle', true)
				RegisterUnitWatch(self)
			]],
			'showParty', true,
			'yOffset', -14
		)
		party:SetPoint('BOTTOMLEFT', UIParent, 'LEFT', 12, -100)
		tinsert(UIMovableFrames, party)
	end

	if cfg.raid.tankframes then
		local tankAnchor = CreateFrame("Frame", "MainTank", UIParent)
		tankAnchor:SetPoint('BOTTOMLEFT', UIParent, 'BOTTOM', 195, 11)
		tankAnchor:SetSize(36, 23)
		tinsert(UIMovableFrames, tankAnchor)
		local tank = self:SpawnHeader(addon_name..'_MainTank', nil, 'raid',
			'oUF-initialConfigFunction', [[
				self:SetAttribute('*type1', 'target')
				self:SetWidth(36)
				self:SetHeight(23)
				RegisterUnitWatch(self)
			]],
			'showRaid', true,
			'yOffset', -7,
			'groupFilter', 'MAINTANK',
			'template', 'oUF_MainTank'
		)
		tank:SetPoint('BOTTOM', tankAnchor)
	end

	if cfg.raid.enable then
		local raidAnchor = CreateFrame("Frame", "RaidFrameAnchor", UIParent)
		raidAnchor:SetPoint('BOTTOMRIGHT', UIParent, 'BOTTOMRIGHT', -12, 12)
		local colAnchors = {
			["UP"]    = "BOTTOM",
			["DOWN"]  = "TOP",
			["LEFT"]  = "RIGHT",
			["RIGHT"] = "LEFT",
		}
		local xoff, yoff, width, height
		if cfg.raid.hgroups then
			xoff = cfg.raid.spacing
			yoff = 0
			point = "LEFT"
			width = cfg.raid.width*cfg.raid.unitpergroup + cfg.raid.spacing*(cfg.raid.unitpergroup-1)
			height = cfg.raid.height*cfg.raid.numgroups + cfg.raid.spacing*(cfg.raid.numgroups-1)
		else
			xoff = 0
			yoff = -cfg.raid.spacing
			point = "TOP"
			width = cfg.raid.width*cfg.raid.numgroups + cfg.raid.spacing*(cfg.raid.numgroups-1)
			height = cfg.raid.height*cfg.raid.unitpergroup + cfg.raid.spacing*(cfg.raid.unitpergroup-1)
		end
		raidAnchor:SetSize(width, height)
		local raid = self:SpawnHeader(addon_name..'_Raid', nil, 'party,raid',
			'oUF-initialConfigFunction', string.format([[
				self:SetAttribute('*type1', 'target')
				self:SetWidth(%d)
				self:SetHeight(%d)
				RegisterUnitWatch(self)
			]], cfg.raid.width, cfg.raid.height),
			'showRaid', true,
			'showParty', cfg.raid.showparty,
			'xoffset', xoff,
			'yOffset', yoff,
			'point', point,
			'groupFilter', '1,2,3,4,5,6,7,8',
			'groupingOrder', '1,2,3,4,5,6,7,8',
			'groupBy', 'GROUP',
			'maxColumns', cfg.raid.numgroups,
			'unitsPerColumn', cfg.raid.unitpergroup,
			'columnSpacing', cfg.raid.spacing,
			'columnAnchorPoint', colAnchors[cfg.raid.growth]
		)
		raid:SetPoint(colAnchors[cfg.raid.growth], raidAnchor, colAnchors[cfg.raid.growth], 0, 0)
		tinsert(UIMovableFrames, raidAnchor)
	end

	local arena = {}
	local arenatarget = {}
	for i = 1, 5 do
		arena[i] = self:Spawn('arena'..i, addon_name..'_Arena'..i)
		arena[i]:SetSize(150, 25)
		if i == 1 then
			arena[i]:SetPoint('BOTTOMRIGHT', UIParent, 'RIGHT', -150, -70)
		else
			arena[i]:SetPoint('BOTTOM', arena[i-1], 'TOP', 0, 26)
		end
		arenatarget[i] = self:Spawn('arena'..i..'target', addon_name..'_Arena'..i..'target')
		arenatarget[i]:SetPoint('LEFT', arena[i], 'RIGHT', 7, 0)
		arenatarget[i]:SetSize(25, 25)
		tinsert(UIMovableFrames, arena[i])
		tinsert(UIMovableFrames, arenatarget[i])
	end

	local boss = {}
	for i = 1, MAX_BOSS_FRAMES do
		boss[i] = self:Spawn('boss'..i, addon_name..'_Boss'..i)
		if i == 1 then
			boss[i]:SetPoint('RIGHT', UIParent, -12, 215)
		else
			boss[i]:SetPoint('BOTTOM', boss[i-1], 'TOP', 0, 14)
		end
		boss[i]:SetSize(150, 23)
		tinsert(UIMovableFrames, boss[i])
	end
end)

SlashCmdList["DPS"] = function()
	UISetValue('unitframes','raid','showparty',false)
	UISetup5.unitframes.raid = nil
	UISavedPositions["UF_Target"] = nil
	UISavedPositions["UF_Player"] = nil
	UISavedPositions["UF_Castbar_player"] = nil
	UISavedPositions["RaidFrameAnchor"] = nil
	ReloadUI()
end
SLASH_DPS1 = "/default"

SlashCmdList["HEAL"] = function()
	UISetValue('unitframes','raid','showparty',true)
	UISetValue('unitframes','raid','numgroups',5)
	UISetValue('unitframes','raid','unitpergroup',5)
	UISetValue('unitframes','raid','growth',"DOWN")
	UISetValue('unitframes','raid','hgroups',true)
	UISetValue('unitframes','raid','width',53)
	UISetValue('unitframes','raid','height',25)
	UISetValue('unitframes','raid','spacing',7)
	UISetValue('unitframes','raid','showpower',true)

	UISavedPositions["UF_Target"] = {"BOTTOM", "UIParent", "BOTTOM", 265, 260}
	UISavedPositions["UF_Player"] = {"BOTTOM", "UIParent", "BOTTOM", -265, 260}
	UISavedPositions["UF_Castbar_player"] = {"BOTTOM", "UIParent", "BOTTOM", 13, 300}
	UISavedPositions["RaidFrameAnchor"] = {"BOTTOM", "UIParent", "BOTTOM", -0.5, 136}
	ReloadUI()
end
SLASH_HEAL1 = "/heal"
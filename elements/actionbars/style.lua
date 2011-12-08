
local update_timer = TOOLTIP_UPDATE_TIME

local config = {
	general = {
		hidemacro = {
			order = 1,
			value = true,
		},
		hidehotkey = {
			order = 2,
			value = false,
		},
	},
	colors = {
		checked = {
			order = 1,
			type = "color",
			value = {0, 144, 255},
		},
		equipped = {
			order = 2,
			type = "color",
			value = {0, 0.5, 0},
		},
		hover = {
			order = 3,
			type = "color",
			value = {144, 255, 0},
		},
		outofmana = {
			order = 4,
			type = "color",
			value = {0.1, 0.3, 1},
		},
		outofrange = {
			order = 5,
			type = "color",
			value = {0.8, 0.1, 0.1},
		},
		unusable = {
			order = 6,
			type = "color",
			value = {0.4, 0.4, 0.4},
		},
	},
}

local cfg = {}
UIConfigGUI.buttons = config
UIConfig.buttons = cfg

local LibKeyBound = LibStub("LibKeyBound-1.0")
local origColor

local GetHotkey = function(button)
	local actionButtonType = button.buttonType or "ACTIONBUTTON"
	return LibKeyBound:ToShortKey(GetBindingKey(actionButtonType..button:GetID()) or GetBindingKey("CLICK "..button:GetName()..":LeftButton"))
end

local modSetBorderColor = function(button)
	if not button.bd then return end
	if button.hover then
		button.bd:SetBackdropBorderColor(unpack(cfg.colors.hover))
	elseif button.checked then
		button.bd:SetBackdropBorderColor(unpack(cfg.colors.checked))
	elseif button.equipped then
		button.bd:SetBackdropBorderColor(unpack(cfg.colors.equipped))
	else
		button.bd:SetBackdropBorderColor(unpack(origColor))
	end
end

local hideTex = function(button)
	_G[button:GetName().."Flash"]:SetTexture("")
	--button:SetHighlightTexture("")
	button:SetPushedTexture(button:GetHighlightTexture())
	button:SetCheckedTexture("")
	button:SetNormalTexture("")
end

local setStyle = function(bname)
	local button    = _G[bname]
	local icon      = _G[bname.."Icon"]
	local count     = _G[bname.."Count"]
	local border    = _G[bname.."Border"]
	local hotkey    = _G[bname.."HotKey"]
	local macro     = _G[bname.."Name"]
	local cooldown  = _G[bname.."Cooldown"]
	local autocast  = _G[bname.."AutoCastable"]
	local floatbg   = _G[bname.."FloatingBG"]
	
	if floatbg then
		floatbg:Hide()
		floatbg.Show = function() end
	end

	if border then
		border:Hide()
		border.Show = function() end
	end

	if macro then 
		macro:SetFont(UIConfig.general.fonts.font, 10, UIConfig.general.fonts.style)
		if cfg.general.hidemacro then
			macro:Hide()
		end
	end

	if hotkey then
		hotkey:SetFont(UIConfig.general.fonts.font, 10, UIConfig.general.fonts.style)
		hotkey:ClearAllPoints()
		hotkey:SetPoint("TOPRIGHT", button, "TOPRIGHT", 2, 2)
		hotkey:SetPoint("TOPLEFT", button, "TOPLEFT", -2, 2)
		if cfg.general.hidehotkey then
			hotkey:Hide()
			hotkey.Show = function() end
		end
	end

	if count then
		count:SetFont(UIConfig.general.fonts.font, 10, UIConfig.general.fonts.style)
		count:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 2, 0)
	end

	if cooldown then
		cooldown:ClearAllPoints()
		cooldown:SetAllPoints(button)
	end

	if autocast then
		autocast:SetTexCoord(0.24, 0.75, 0.24, 0.75)
		autocast:SetPoint("TOPLEFT", 0, -0)
		autocast:SetPoint("BOTTOMRIGHT", -0, 0)
	end

	button.bd = CreateBG(button)
	origColor = {button.bd:GetBackdropBorderColor()}

	button.GetHotkey = GetHotkey

	button:HookScript("OnEnter", function(self)
		self.hover = true
		modSetBorderColor(self)
		if self.GetHotkey then
			LibKeyBound:Set(self)
		end
	end)
	button:HookScript("OnLeave", function(self)
		self.hover = false
		modSetBorderColor(self)
	end)

	icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
	icon:SetPoint("TOPLEFT", button, "TOPLEFT", 0, -0)
	icon:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -0, 0)
end

local modActionButton_UpdateState = function(button)
	local action = button.action
	if not button.bd then return end
	if IsCurrentAction(action) or IsAutoRepeatAction(action) then
		button.checked = true
	else
		button.checked = false
	end
	modSetBorderColor(button)
end

local modActionButton_Update = function(self)
	local action = self.action
	local name = self:GetName()

	hideTex(self)
	if IsEquippedAction(action) then
		self.equipped = true
	else
		self.equipped = false
	end
	modSetBorderColor(self)
end

local modActionButton_UpdateFlyout = function(self)
	local actionType = GetActionInfo(self.action)
	if actionType == "flyout" then
		self.FlyoutBorder:SetAlpha(0)
		self.FlyoutBorderShadow:SetAlpha(0)
		SpellFlyoutHorizontalBackground:SetAlpha(0)
		SpellFlyoutVerticalBackground:SetAlpha(0)
		SpellFlyoutBackgroundEnd:SetAlpha(0)
	end
end

local modPetActionBar_Update = function()
	for i=1, NUM_PET_ACTION_SLOTS do
		local name = "PetActionButton"..i
		local button  = _G[name]

		hideTex(button)
		local name, subtext, texture, isToken, isActive, autoCastAllowed, autoCastEnabled = GetPetActionInfo(i)
		if isActive then
			button.checked = true
		else
			button.checked = false
		end
		modSetBorderColor(button)
	end  
end

local modShapeshiftBar_UpdateState = function()    
	for i=1, NUM_SHAPESHIFT_SLOTS do
		local name = "ShapeshiftButton"..i
		local button  = _G[name]
  
		hideTex(button)
		local texture, name, isActive, isCastable = GetShapeshiftFormInfo(i)
		if isActive then
			button.checked = true
		else
			button.checked = false
		end
		modSetBorderColor(button)
	end    
end

local modActionButton_UpdateUsable = function(self)
	local name = self:GetName()
	local action = self.action
	local icon = _G[name.."Icon"]
	local isUsable, notEnoughMana = IsUsableAction(action)
	if ActionHasRange(action) and IsActionInRange(action) == 0 then
		icon:SetVertexColor(unpack(cfg.colors.outofrange))
		return
	elseif notEnoughMana then
		icon:SetVertexColor(unpack(cfg.colors.outofmana))
		return
	elseif isUsable then
		icon:SetVertexColor(1, 1, 1, 1)
		return
	else
		icon:SetVertexColor(unpack(cfg.colors.unusable))
		return
	end
end

local modActionButton_OnUpdate = function(self, elapsed)
	local t = self.mod_range
	if not t then
		self.mod_range = 0
		return
	end
	t = t + elapsed
	if t < update_timer then
		self.mod_range = t
		return
	else
		self.mod_range = 0
		modActionButton_UpdateUsable(self)
	end
end

local modActionButton_UpdateHotkeys = function(self)
	local hotkey = _G[self:GetName().."HotKey"]
	hotkey:SetText(GetHotkey(self))
	hotkey:SetPoint("TOPRIGHT", self, "TOPRIGHT", 2, 2)
	hotkey:SetPoint("TOPLEFT", self, "TOPLEFT", -2, 2)
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:SetScript("OnEvent", function(self, event)
	self:UnregisterEvent(event)
	for i = 1, 12 do
		setStyle("ActionButton"..i)
		setStyle("BonusActionButton"..i)
		setStyle("MultiBarRightButton"..i)
		setStyle("MultiBarBottomRightButton"..i)
		setStyle("MultiBarLeftButton"..i)
		setStyle("MultiBarBottomLeftButton"..i)
		setStyle("MultiCastActionButton"..i)
	end

	for i=1, 10 do
		setStyle("ShapeshiftButton"..i)
		setStyle("PetActionButton"..i)
	end
	
	setStyle("ExtraActionButton1")
	setStyle("MultiCastSummonSpellButton")
	setStyle("MultiCastRecallSpellButton")
end)

hooksecurefunc("ActionButton_Update", modActionButton_Update)
hooksecurefunc("ActionButton_UpdateUsable", modActionButton_UpdateUsable)
hooksecurefunc("ActionButton_UpdateState", modActionButton_UpdateState)
hooksecurefunc("ActionButton_UpdateFlyout", modActionButton_UpdateFlyout)
hooksecurefunc("ActionButton_UpdateHotkeys", modActionButton_UpdateHotkeys)
hooksecurefunc("ShapeshiftBar_UpdateState", modShapeshiftBar_UpdateState)
hooksecurefunc("PetActionBar_Update", modPetActionBar_Update)
ActionButton_OnUpdate = modActionButton_OnUpdate

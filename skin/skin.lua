----------------------------------------------------------------------------------------
--	Reskin Blizzard windows(by Tukz and Co)
----------------------------------------------------------------------------------------
local addon_name, ns = ...

local backdrop = {
	bgFile = [=[Interface\ChatFrame\ChatFrameBackground]=],
	edgeFile = [=[Interface\ChatFrame\ChatFrameBackground]=], edgeSize = 1,
	insets = {top = 0, left = 0, bottom = 0, right = 0},
}

local function SetModifiedBackdrop(self)
	self:SetBackdropBorderColor(1, 1, 0, 1)
end

local function SetOriginalBackdrop(self)
	self:SetBackdropBorderColor(0, 0, 0, 1)
end

local SkinPanel = function(frame)
	frame:SetBackdrop(backdrop)
	frame:SetBackdropColor(0, 0, 0, 0.5)
	frame:SetBackdropBorderColor(0, 0, 0, 1) 
end

local function SkinButton(f)
	f:SetNormalTexture("")
	f:SetHighlightTexture("")
	f:SetPushedTexture("")
	f:SetDisabledTexture("")
	SkinPanel(f)
	f:HookScript("OnEnter", SetModifiedBackdrop)
	f:HookScript("OnLeave", SetOriginalBackdrop)
end

local SkinBlizzUI = CreateFrame("Frame")
SkinBlizzUI:RegisterEvent("ADDON_LOADED")
SkinBlizzUI:SetScript("OnEvent", function(self, event, addon)
	if IsAddOnLoaded("Skinner") then return end
	
	-- Stuff not in Blizzard load-on-demand
	if addon == addon_name then
		-- Blizzard Frame reskin
		local bgskins = {
			"StaticPopup1",
			"StaticPopup2",
			"StaticPopup3",
			"GameMenuFrame",
			"InterfaceOptionsFrame",
			"VideoOptionsFrame",
			"AudioOptionsFrame",
			"LFDDungeonReadyStatus",
			"BNToastFrame",
			"TicketStatusFrameButton",
			"DropDownList1MenuBackdrop",
			"DropDownList2MenuBackdrop",
			"DropDownList1Backdrop",
			"DropDownList2Backdrop",
			"LFDSearchStatus",
			"AutoCompleteBox",
			"ReadyCheckFrame",
			"ColorPickerFrame",
			"ConsolidatedBuffsTooltip",
			"LFDRoleCheckPopup",
			"VoiceChatTalkers",
			"ChannelPulloutBackground",			
			"FriendsTooltip",
			"LFDDungeonReadyDialog",
			"GuildInviteFrame",
			"ChatConfigFrame",
			"RolePollPopup",
		}
		
		local insetskins = {
			"InterfaceOptionsFramePanelContainer",
			"InterfaceOptionsFrameAddOns",
			"InterfaceOptionsFrameCategories",
			"InterfaceOptionsFrameTab1",
			"InterfaceOptionsFrameTab2",
			"VideoOptionsFrameCategoryFrame",
			"VideoOptionsFramePanelContainer",			
			"AudioOptionsFrameCategoryFrame",
			--"AudioOptionsFramePanelContainer",			
			"AudioOptionsSoundPanel",
			"AudioOptionsSoundPanelPlayback",
			"AudioOptionsSoundPanelHardware",
			"AudioOptionsSoundPanelVolume",
			"AudioOptionsVoicePanel",
			"AudioOptionsVoicePanelTalking",
			"AudioOptionsVoicePanelBinding",
			"AudioOptionsVoicePanelListening",
			"GhostFrameContentsFrame",
			"ChatConfigCategoryFrame",
			"ChatConfigBackgroundFrame",
			"ChatConfigChatSettingsClassColorLegend",
			"ChatConfigChatSettingsLeft",
		}
		
		-- Reskin popup buttons
		for i = 1, 3 do
			for j = 1, 3 do
				SkinButton(_G["StaticPopup"..i.."Button"..j])
			end
		end

		for i = 1, getn(bgskins) do
			SkinPanel(_G[bgskins[i]])
		end
		
		for i = 1, getn(insetskins) do
			SkinPanel(_G[insetskins[i]])
		end
		
		local ChatMenus = {
			"ChatMenu",
			"EmoteMenu",
			"LanguageMenu",
			"VoiceMacroMenu",
		}
		
		for i = 1, getn(ChatMenus) do
			if _G[ChatMenus[i]] == _G["ChatMenu"] then
				_G[ChatMenus[i]]:HookScript("OnShow", function(self) SkinPanel(self) self:ClearAllPoints() self:SetPoint("BOTTOMRIGHT", ChatFrame1, "BOTTOMRIGHT", 0, 30) end)
			else
				_G[ChatMenus[i]]:HookScript("OnShow", function(self) SkinPanel(self) end)
			end
		end
		
		-- Reskin all esc/menu buttons
		local BlizzardMenuButtons = {
			"Options",
			"SoundOptions",
			"UIOptions",
			"Keybindings",
			"Macros",
			"Ratings",
			"AddOns",
			"Logout",
			"Quit",
			"Continue",
			"MacOptions",
			"OptionHouse",
			"AddonManager",
			"SettingsGUI",
		}
		
		for i = 1, getn(BlizzardMenuButtons) do
			local UIMenuButtons = _G["GameMenuButton"..BlizzardMenuButtons[i]]
			if UIMenuButtons then
				SkinButton(UIMenuButtons)
				_G["GameMenuButton"..BlizzardMenuButtons[i].."Left"]:SetAlpha(0)
				_G["GameMenuButton"..BlizzardMenuButtons[i].."Middle"]:SetAlpha(0)
				_G["GameMenuButton"..BlizzardMenuButtons[i].."Right"]:SetAlpha(0)
			end
		end

		-- Hide header textures and move text/buttons
		local BlizzardHeader = {
			"GameMenuFrame", 
			"InterfaceOptionsFrame", 
			"AudioOptionsFrame", 
			"VideoOptionsFrame",
			"ColorPickerFrame",
			"ChatConfigFrame",
		}
		
		for i = 1, getn(BlizzardHeader) do
			local title = _G[BlizzardHeader[i].."Header"]			
			if title then
				title:SetTexture("")
				title:ClearAllPoints()
				if title == _G["GameMenuFrameHeader"] then
					title:SetPoint("TOP", GameMenuFrame, 0, 7)
				elseif title == _G["ColorPickerFrameHeader"] then
					title:SetPoint("TOP", ColorPickerFrame, 0, 7)
				elseif title == _G["ChatConfigFrameHeader"] then
					title:SetPoint("TOP", ChatConfigFrame, 0, 7)
				else
					title:SetPoint("TOP", BlizzardHeader[i], 0, 0)
				end
			end
		end
		
		-- Reskin all "normal" buttons
		local BlizzardButtons = {
			"VideoOptionsFrameOkay",
			"VideoOptionsFrameCancel",
			"VideoOptionsFrameDefaults",
			"VideoOptionsFrameApply",
			"AudioOptionsFrameOkay",
			"AudioOptionsFrameCancel",
			"AudioOptionsFrameDefaults",
			"InterfaceOptionsFrameDefaults",
			"InterfaceOptionsFrameOkay",
			"InterfaceOptionsFrameCancel",
			"ReadyCheckFrameYesButton",
			"ReadyCheckFrameNoButton",
			"ColorPickerOkayButton",
			"ColorPickerCancelButton",
			"BaudErrorFrameClearButton",
			"BaudErrorFrameCloseButton",
			"GuildInviteFrameJoinButton",
			"GuildInviteFrameDeclineButton",
			"LFDDungeonReadyDialogLeaveQueueButton",
			"LFDDungeonReadyDialogEnterDungeonButton",
			"ChatConfigFrameDefaultButton",
			"ChatConfigFrameOkayButton",
			"RolePollPopupAcceptButton",
			"LFDRoleCheckPopupDeclineButton",
			"LFDRoleCheckPopupAcceptButton",
		}
		
		for i = 1, getn(BlizzardButtons) do
			local UIButtons = _G[BlizzardButtons[i]]
			if UIButtons then
				SkinButton(UIButtons)
			end
		end
		
		-- Button position or text
		_G["VideoOptionsFrameCancel"]:ClearAllPoints()
		_G["VideoOptionsFrameCancel"]:SetPoint("RIGHT", _G["VideoOptionsFrameApply"], "LEFT", -4, 0)	 
		_G["VideoOptionsFrameOkay"]:ClearAllPoints()
		_G["VideoOptionsFrameOkay"]:SetPoint("RIGHT", _G["VideoOptionsFrameCancel"], "LEFT", -4, 0)
		_G["AudioOptionsFrameOkay"]:ClearAllPoints()
		_G["AudioOptionsFrameOkay"]:SetPoint("RIGHT", _G["AudioOptionsFrameCancel"], "LEFT", -4, 0)
		_G["InterfaceOptionsFrameOkay"]:ClearAllPoints()
		_G["InterfaceOptionsFrameOkay"]:SetPoint("RIGHT", _G["InterfaceOptionsFrameCancel"], "LEFT", -4, 0)
		_G["ColorPickerOkayButton"]:ClearAllPoints()
		_G["ColorPickerOkayButton"]:SetPoint("BOTTOMLEFT", _G["ColorPickerFrame"], "BOTTOMLEFT", 6, 6)		 
		_G["ColorPickerCancelButton"]:ClearAllPoints()
		_G["ColorPickerCancelButton"]:SetPoint("BOTTOMRIGHT", _G["ColorPickerFrame"], "BOTTOMRIGHT", -6, 6)
		_G["ReadyCheckFrameYesButton"]:SetParent(_G["ReadyCheckFrame"])
		_G["ReadyCheckFrameNoButton"]:SetParent(_G["ReadyCheckFrame"]) 
		_G["ReadyCheckFrameYesButton"]:SetPoint("RIGHT", _G["ReadyCheckFrame"], "CENTER", -6, 0)
		_G["ReadyCheckFrameNoButton"]:SetPoint("LEFT", _G["ReadyCheckFrameYesButton"], "RIGHT", 6, 0)
		_G["ReadyCheckFrameText"]:SetParent(_G["ReadyCheckFrame"])	
		_G["ReadyCheckFrameText"]:ClearAllPoints()
		_G["ReadyCheckFrameText"]:SetPoint("TOP", 0, -12)
		_G["InterfaceOptionsFrameTab1"]:ClearAllPoints()
		_G["InterfaceOptionsFrameTab1"]:SetPoint("TOPLEFT", _G["InterfaceOptionsFrameCategories"], "TOPLEFT", 10, 27)
		_G["InterfaceOptionsFrameTab2"]:ClearAllPoints()
		_G["InterfaceOptionsFrameTab2"]:SetPoint("TOPLEFT", _G["InterfaceOptionsFrameTab1"], "TOPRIGHT", 6, 0)
		_G["ChatConfigFrameDefaultButton"]:SetWidth(125)
		_G["ChatConfigFrameDefaultButton"]:ClearAllPoints()
		_G["ChatConfigFrameDefaultButton"]:SetPoint("TOP", _G["ChatConfigCategoryFrame"], "BOTTOM", 0, -4)
		_G["ChatConfigFrameOkayButton"]:ClearAllPoints()
		_G["ChatConfigFrameOkayButton"]:SetPoint("TOPRIGHT", _G["ChatConfigBackgroundFrame"], "BOTTOMRIGHT", 0, -4)
		
		-- Others
		_G["ReadyCheckListenerFrame"]:SetAlpha(0)
		_G["ReadyCheckFrame"]:HookScript("OnShow", function(self) if UnitIsUnit("player", self.initiator) then self:Hide() end end)
		_G["PlayerPowerBarAlt"]:HookScript("OnShow", function(self) self:ClearAllPoints() self:SetPoint("TOP", 0, -12) end)
		
		_G["LFDRoleCheckPopupAcceptButtonLeft"]:SetAlpha(0)
		_G["LFDRoleCheckPopupAcceptButtonMiddle"]:SetAlpha(0)
		_G["LFDRoleCheckPopupAcceptButtonRight"]:SetAlpha(0)
		_G["LFDRoleCheckPopupDeclineButtonLeft"]:SetAlpha(0)
		_G["LFDRoleCheckPopupDeclineButtonMiddle"]:SetAlpha(0)
		_G["LFDRoleCheckPopupDeclineButtonRight"]:SetAlpha(0)
		
		_G["InterfaceOptionsFrameTab1Left"]:SetAlpha(0)
		_G["InterfaceOptionsFrameTab1Middle"]:SetAlpha(0)
		_G["InterfaceOptionsFrameTab1Right"]:SetAlpha(0)
		_G["InterfaceOptionsFrameTab1LeftDisabled"]:SetAlpha(0)
		_G["InterfaceOptionsFrameTab1MiddleDisabled"]:SetAlpha(0)
		_G["InterfaceOptionsFrameTab1RightDisabled"]:SetAlpha(0)
		_G["InterfaceOptionsFrameTab1HighlightTexture"]:SetAlpha(0)
		_G["InterfaceOptionsFrameTab2Left"]:SetAlpha(0)
		_G["InterfaceOptionsFrameTab2Middle"]:SetAlpha(0)
		_G["InterfaceOptionsFrameTab2Right"]:SetAlpha(0)
		_G["InterfaceOptionsFrameTab2LeftDisabled"]:SetAlpha(0)
		_G["InterfaceOptionsFrameTab2MiddleDisabled"]:SetAlpha(0)
		_G["InterfaceOptionsFrameTab2RightDisabled"]:SetAlpha(0)
		_G["InterfaceOptionsFrameTab2HighlightTexture"]:SetAlpha(0)
	end
end) 
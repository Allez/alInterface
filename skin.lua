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
	--self.bg:SetVertexColor(SettingsDB.color.r, SettingsDB.color.g, SettingsDB.color.b, 0.3)
end

local function SetOriginalBackdrop(self)
	self:SetBackdropBorderColor(0, 0, 0, 1)
	--self.bg:SetVertexColor(0.1, 0.1, 0.1, 1)
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
		
		-- Others
		_G["ReadyCheckListenerFrame"]:SetAlpha(0)
		_G["ReadyCheckFrame"]:HookScript("OnShow", function(self) if UnitIsUnit("player", self.initiator) then self:Hide() end end)
		_G["GhostFrameContentsFrameIcon"]:SetTexCoord(0.1, 0.9, 0.1, 0.9)
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
	
	-- AtlasLoot Tooltip
	if addon == "AtlasLoot" then
		AtlasLootTooltip:HookScript("OnShow", function(self) SkinPanel(self) end)
	end
	
	-- DBM-GUI Frame
	if addon == "DBM-GUI" then
		SkinPanel(_G["DBM_GUI_OptionsFrame"])
		SkinPanel(_G["DBM_GUI_OptionsFramePanelContainer"])
		SkinPanel(_G["DBM_GUI_OptionsFrameTab1"])
		SkinPanel(_G["DBM_GUI_OptionsFrameTab2"])
		
		_G["DBM_GUI_OptionsFrameTab1Left"]:SetAlpha(0)
		_G["DBM_GUI_OptionsFrameTab1Middle"]:SetAlpha(0)
		_G["DBM_GUI_OptionsFrameTab1Right"]:SetAlpha(0)
		_G["DBM_GUI_OptionsFrameTab1LeftDisabled"]:SetAlpha(0)
		_G["DBM_GUI_OptionsFrameTab1MiddleDisabled"]:SetAlpha(0)
		_G["DBM_GUI_OptionsFrameTab1RightDisabled"]:SetAlpha(0)
		_G["DBM_GUI_OptionsFrameTab1HighlightTexture"]:SetAlpha(0)
		_G["DBM_GUI_OptionsFrameTab2Left"]:SetAlpha(0)
		_G["DBM_GUI_OptionsFrameTab2Middle"]:SetAlpha(0)
		_G["DBM_GUI_OptionsFrameTab2Right"]:SetAlpha(0)
		_G["DBM_GUI_OptionsFrameTab2LeftDisabled"]:SetAlpha(0)
		_G["DBM_GUI_OptionsFrameTab2MiddleDisabled"]:SetAlpha(0)
		_G["DBM_GUI_OptionsFrameTab2RightDisabled"]:SetAlpha(0)
		_G["DBM_GUI_OptionsFrameTab2HighlightTexture"]:SetAlpha(0)

		_G["DBM_GUI_OptionsFrameTab1"]:ClearAllPoints()
		_G["DBM_GUI_OptionsFrameTab1"]:SetPoint("TOPLEFT", _G["DBM_GUI_OptionsFrameBossMods"], "TOPLEFT", 10, 27)
		_G["DBM_GUI_OptionsFrameTab2"]:ClearAllPoints()
		_G["DBM_GUI_OptionsFrameTab2"]:SetPoint("TOPLEFT", _G["DBM_GUI_OptionsFrameTab1"], "TOPRIGHT", 6, 0)
		
		_G["DBM_GUI_OptionsFrameBossMods"]:HookScript("OnShow", function(self) SkinPanel(self) end)
		_G["DBM_GUI_OptionsFrameDBMOptions"]:HookScript("OnShow", function(self) SkinPanel(self) end)
		_G["DBM_GUI_OptionsFrameHeader"]:SetTexture("")
		_G["DBM_GUI_OptionsFrameHeader"]:ClearAllPoints()
		_G["DBM_GUI_OptionsFrameHeader"]:SetPoint("TOP", DBM_GUI_OptionsFrame, 0, 7)
		
		local dbmbskins = {
			"DBM_GUI_OptionsFrameOkay",
		}
		
		for i = 1, getn(dbmbskins) do
			local DBMButtons = _G[dbmbskins[i]]
			if DBMButtons then
				SkinButton(DBMButtons)
			end
		end
	end
end) 
----------------------------------------------------------------------------------------
--	Reskin Blizzard windows(by Tukz and Co)
----------------------------------------------------------------------------------------
local addon_name, ns = ...

local function SetModifiedBackdrop(self)
	self.bg:SetBackdropBorderColor(1, 1, 0, 1)
end

local function SetOriginalBackdrop(self)
	self.bg:SetBackdropBorderColor(0.35, 0.3, 0.3, 1)
end

local SkinPanel = function(frame)
	frame:SetBackdrop(nil)
	local skin = CreateFrame("Frame", nil, frame)
	skin:SetPoint("TOPLEFT", frame, 3, -2)
	skin:SetPoint("BOTTOMRIGHT", frame, -3, 2)
	frame.bg = CreateBG(skin)
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

local CleanFrame = function(frame)
	for i=1, frame:GetNumRegions() do
		local region = select(i, frame:GetRegions())
		if region:GetObjectType() == "Texture" then
			region:SetTexture(nil)
		end
	end
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
			"Help",
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
	if addon == "Blizzard_MacroUI" then
		CleanFrame(MacroFrame)
		CleanFrame(MacroPopupFrame)
		local MacroBD = CreateFrame("Frame", nil, MacroFrame)
		MacroBD:SetPoint("TOPLEFT", 12, -10)
		MacroBD:SetPoint("BOTTOMRIGHT", -33, 68)
		SkinPanel(MacroBD)
		SkinPanel(MacroFrameTextBackground)
		SkinPanel(MacroPopupFrame)
		MacroPopupScrollFrame:GetRegions():Hide()
		select(2, MacroPopupScrollFrame:GetRegions()):Hide()

		for _, v in pairs({
			"MacroDeleteButton",
			"MacroNewButton",
			"MacroExitButton",
			"MacroEditButton",
			"MacroFrameTab1",
			"MacroFrameTab2",
			"MacroPopupOkayButton",
			"MacroPopupCancelButton",
		}) do
			SkinButton(_G[v])
			CleanFrame(MacroFrame)
		end
		
		MacroFrameTab1:SetHeight(25)
		MacroFrameTab2:SetHeight(25)

		for i = 1, MAX_ACCOUNT_MACROS do
			if _G["MacroButton"..i] then
				CreateBG(_G["MacroButton"..i])
				CleanFrame(_G["MacroButton"..i])
			end
			if _G["MacroButton"..i.."Icon"] then
				_G["MacroButton"..i.."Icon"]:SetTexCoord(.08, .92, .08, .92)
			end
			if _G["MacroButton"..i.."Border"] then
				_G["MacroButton"..i.."Border"]:Hide()
			end
			if _G["MacroPopupButton"..i] then
				CreateBG(_G["MacroPopupButton"..i])
				CleanFrame(_G["MacroPopupButton"..i])
			end
			if _G["MacroPopupButton"..i.."Icon"] then
				_G["MacroPopupButton"..i.."Icon"]:SetTexCoord(.08, .92, .08, .92)
			end
			if _G["MacroPopupButton"..i.."Border"] then
				_G["MacroPopupButton"..i.."Border"]:Hide()
			end
		end
	end
end) 
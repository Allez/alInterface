local addon_name, ns = ...
local scale = 0.89
local anchor = "TOPRIGHT"
local pos_x = -12
local pos_y = -12

function GetMinimapShape() return "SQUARE" end

local frames = {
	MinimapZoomIn,
	MinimapZoomOut,
	MinimapBorder,
	MinimapBorderTop,
	MiniMapWorldMapButton,
	MinimapZoneTextButton,
	MiniMapTrackingBackground,
	MiniMapTrackingButtonBorder,
	MiniMapVoiceChatFrameBackground,
	MiniMapVoiceChatFrameBorder,
	MinimapNorthTag,
	MiniMapInstanceDifficulty,
	GuildInstanceDifficulty,
	MiniMapBattlefieldBorder,
	MiniMapLFGFrameBorder,
	MiniMapMailBorder,
	BattlegroundShine,
	GameTimeFrame,
}

local menuFrame = CreateFrame("Frame", "MinimapRightClickMenu", UIParent, "UIDropDownMenuTemplate")
local micromenu = {
	{text = CHARACTER_BUTTON,
	func = function() ToggleCharacter("PaperDollFrame") end},
	{text = SPELLBOOK_ABILITIES_BUTTON,
	func = function() ToggleFrame(SpellBookFrame) end},
	{text = TALENTS_BUTTON,
	func = function() if not PlayerTalentFrame then LoadAddOn("Blizzard_TalentUI") end PlayerTalentFrame_Toggle() end},
	{text = ACHIEVEMENT_BUTTON,
	func = function() ToggleAchievementFrame() end},
	{text = QUESTLOG_BUTTON,
	func = function() ToggleFrame(QuestLogFrame) end},
	{text = SOCIAL_BUTTON,
	func = function() ToggleFriendsFrame(1) end},
	{text = ACHIEVEMENTS_GUILD_TAB,
	func = function() if IsInGuild() then if not GuildFrame then LoadAddOn("Blizzard_GuildUI") end GuildFrame_Toggle() end end},
	{text = PLAYER_V_PLAYER,
	func = function() ToggleFrame(PVPFrame) end},
	{text = LFG_TITLE,
	func = function() ToggleFrame(LFDParentFrame) end},
	{text = LOOKING_FOR_RAID,
	func = function() ToggleRaidFrame(3) end},
	{text = ENCOUNTER_JOURNAL,
    func = function() if not EncounterJournal then LoadAddOn("Blizzard_EncounterJournal") end ToggleFrame(EncounterJournal) end},
	{text = HELP_BUTTON,
	func = function() ToggleHelpFrame() end},
}

local function OnEvent(self, event, ...)
	if event == 'PLAYER_LOGIN' then
		for _, v in pairs(frames) do
			if(v:GetObjectType() == 'Texture') then
				v:SetTexture(nil)
			else
				v:Hide()
				v.Show = function() end
			end
		end
		MiniMapInstanceDifficulty:SetAlpha(0)

		Minimap:EnableMouseWheel()
		Minimap:SetScript('OnMouseWheel', function(self, direction)
			if direction > 0 then
				MinimapZoomIn:Click()
			else
				MinimapZoomOut:Click()
			end
		end)

		MiniMapTracking:ClearAllPoints()
		MiniMapTracking:SetParent(Minimap)
		MiniMapTracking:SetPoint('TOPLEFT', -1, 1)
		MiniMapTrackingButton:SetHighlightTexture(nil)
		MiniMapTrackingIcon:SetTexCoord(0.07, 0.93, 0.07, 0.93)

		MiniMapVoiceChatFrame:ClearAllPoints()
		MiniMapVoiceChatFrame:SetParent(Minimap)
		MiniMapVoiceChatFrame:SetPoint("TOP", 0, 0)

		MiniMapLFGFrame:ClearAllPoints()
		MiniMapLFGFrame:SetParent(Minimap)
		MiniMapLFGFrame:SetPoint('BOTTOMLEFT', -2, -2)

		MiniMapBattlefieldFrame:ClearAllPoints()
		MiniMapBattlefieldFrame:SetParent(Minimap)
		MiniMapBattlefieldFrame:SetPoint('TOPRIGHT', 3, 0)

		MiniMapMailFrame:ClearAllPoints()
		MiniMapMailFrame:SetParent(Minimap)
		MiniMapMailFrame:SetPoint('BOTTOMRIGHT', 0, -4)
		MiniMapMailIcon:SetTexture("Interface\\Addons\\"..addon_name.."\\media\\mail")

		MinimapCluster:EnableMouse(false)

		if not IsAddOnLoaded("Blizzard_TimeManager") then
			LoadAddOn("Blizzard_TimeManager")
		end
		TimeManagerClockTicker:SetPoint('BOTTOM', Minimap, 'BOTTOM', 0, 1)
		TimeManagerClockTicker:SetFont(UIConfig.general.fonts.font, UIConfig.general.fonts.size/scale, UIConfig.general.fonts.style)
		TimeManagerClockTicker:SetShadowOffset(0, 0)
		TimeManagerClockButton:GetRegions():Hide()
		TimeManagerClockButton:SetWidth(40)
		TimeManagerClockButton:SetScript("OnClick", function(_,click)
			if click == "RightButton" then
				ToggleCalendar()
			else
				ToggleTimeManager()
			end
		end)
		self:RegisterEvent('CALENDAR_UPDATE_PENDING_INVITES')

		Minimap:ClearAllPoints()
		Minimap:SetPoint(anchor, UIParent, anchor, pos_x, pos_y)
		Minimap:SetScale(scale)
		Minimap:SetFrameStrata("LOW")
		Minimap:SetMaskTexture([=[Interface\ChatFrame\ChatFrameBackground]=])
		Minimap.bg = CreateBG(Minimap)
		
		local zoneTextFrame = CreateFrame("Frame", nil, UIParent)
		zoneTextFrame:SetPoint("TOPLEFT", Minimap, "BOTTOMLEFT", 0, -7)
		zoneTextFrame:SetPoint("TOPRIGHT", Minimap, "BOTTOMRIGHT", 0, -7)
		zoneTextFrame:SetHeight(19)
		zoneTextFrame:SetAlpha(0)
		zoneTextFrame.bg = CreateBG(zoneTextFrame)
		
		MinimapZoneText:SetParent(zoneTextFrame)
		MinimapZoneText:ClearAllPoints()
		MinimapZoneText:SetPoint("LEFT", 2, 1)
		MinimapZoneText:SetPoint("RIGHT", -2, 1)
		MinimapZoneText:SetFont(UIConfig.general.fonts.font, UIConfig.general.fonts.size, UIConfig.general.fonts.style)
		
		Minimap:SetScript("OnEnter", function(self)
			UIFrameFadeIn(zoneTextFrame, 0.3, 0, 1)
		end)
		Minimap:SetScript("OnLeave", function(self)
			UIFrameFadeOut(zoneTextFrame, 0.3, 1, 0)
		end)

		Minimap:SetScript("OnMouseUp", function(self, button)
			if button == "MiddleButton" then
				EasyMenu(micromenu, menuFrame, "cursor", 0, 0, "MENU", 2)
			else
				Minimap_OnClick(self)
			end
		end)

		if UIMovableFrames then tinsert(UIMovableFrames, Minimap) end
	elseif event == 'CALENDAR_UPDATE_PENDING_INVITES' then
		if CalendarGetNumPendingInvites() ~= 0 then
			TimeManagerClockTicker:SetTextColor(0, 1, 0)
		else
			TimeManagerClockTicker:SetTextColor(1, 1, 1)
		end
	end
end

local addon = CreateFrame('Frame')
addon:SetScript('OnEvent', OnEvent)
addon:RegisterEvent('PLAYER_LOGIN')
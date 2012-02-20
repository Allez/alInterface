SlashCmdList["RELOADUI"] = function() ReloadUI() end
SLASH_RELOADUI1 = "/rl"

SlashCmdList["RCSLASH"] = function() DoReadyCheck() end
SLASH_RCSLASH1 = "/rc"

SlashCmdList["TICKET"] = function() ToggleHelpFrame() end
SLASH_TICKET1 = "/gm"

SlashCmdList["CLFIX"] = function() CombatLogClearEntries() end
SLASH_CLFIX1 = "/clfix"

SlashCmdList["GROUPDISBAND"] = function()
	local pName = UnitName("player")
	if UnitInRaid("player") then
		for i = 1, GetNumRaidMembers() do
			local name, _, _, _, _, _, _, online = GetRaidRosterInfo(i)
			if online and name ~= pName then
				UninviteUnit(name)
			end
		end
	else
		for i = MAX_PARTY_MEMBERS, 1, -1 do
			if GetPartyMember(i) then
				UninviteUnit(UnitName("party"..i))
			end
		end
	end
	LeaveParty()
end
SLASH_GROUPDISBAND1 = "/rd"

local SetupUI = function() 
	SetCVar("chatStyle", "classic")
	SetCVar("chatMouseScroll", 1)
	SetCVar("nameplateShowFriends", 0)
	SetCVar("nameplateShowEnemyTotems", 1)
	SetCVar("ShowClassColorInNameplate", 1)
	SetCVar("autoSelfCast", 1)
	SetCVar("rotateMinimap", 0)
	SetCVar("UnitNameOwn", 1)
	SetCVar("UnitNameNPC", 1)
	SetCVar("UnitNameNonCombatCreatureName", 0)
	SetCVar("UnitNamePlayerPVPTitle", 1)
	SetCVar("UnitNameFriendlyPlayerName", 1)
	SetCVar("UnitNameFriendlyPetName", 1)
	SetCVar("UnitNameFriendlyGuardianName", 0)
	SetCVar("UnitNameFriendlyTotemName", 1)
	SetCVar("UnitNameEnemyPlayerName", 1)
	SetCVar("UnitNameEnemyPetName", 1)
	SetCVar("UnitNameEnemyGuardianName", 1)
	SetCVar("UnitNameEnemyTotemName", 1)
	SetCVar("cameraDistanceMax", 50)
	SetCVar("cameraDistanceMaxFactor", 3.4)
	SetCVar("screenshotQuality", 8)
	SetCVar("lootUnderMouse", 1)
	SetCVar("UberTooltips", 1)
	SetCVar("showArenaEnemyFrames", 0)
	SetCVar("alwaysShowActionBars", 1)
	SetCVar("consolidateBuffs",0)
	SetCVar("buffDurations",1)
	SetCVar("useUiScale", 1)
	SetCVar("uiScale", min(2, max(.64, 768/string.match(({GetScreenResolutions()})[GetCurrentResolution()], "%d+x(%d+)"))))

	ToggleChatColorNamesByClassGroup(true, "SAY")
	ToggleChatColorNamesByClassGroup(true, "EMOTE")
	ToggleChatColorNamesByClassGroup(true, "YELL")
	ToggleChatColorNamesByClassGroup(true, "GUILD")
	ToggleChatColorNamesByClassGroup(true, "GUILD_OFFICER")
	ToggleChatColorNamesByClassGroup(true, "OFFICER")
	ToggleChatColorNamesByClassGroup(true, "GUILD_ACHIEVEMENT")
	ToggleChatColorNamesByClassGroup(true, "ACHIEVEMENT")
	ToggleChatColorNamesByClassGroup(true, "WHISPER")
	ToggleChatColorNamesByClassGroup(true, "PARTY")
	ToggleChatColorNamesByClassGroup(true, "PARTY_LEADER")
	ToggleChatColorNamesByClassGroup(true, "RAID")
	ToggleChatColorNamesByClassGroup(true, "RAID_LEADER")
	ToggleChatColorNamesByClassGroup(true, "RAID_WARNING")
	ToggleChatColorNamesByClassGroup(true, "BATTLEGROUND")
	ToggleChatColorNamesByClassGroup(true, "BATTLEGROUND_LEADER")	
	ToggleChatColorNamesByClassGroup(true, "CHANNEL1")
	ToggleChatColorNamesByClassGroup(true, "CHANNEL2")
	ToggleChatColorNamesByClassGroup(true, "CHANNEL3")
	ToggleChatColorNamesByClassGroup(true, "CHANNEL4")
	ToggleChatColorNamesByClassGroup(true, "CHANNEL5")
	setupUI5 = true
	ReloadUI()
end

SlashCmdList["UISETUP"] = SetupUI
SLASH_UISETUP1 = "/uisetup"

local WatchFrameAnchor = CreateFrame("Frame", "WatchFrameAnchor", UIParent)
WatchFrameAnchor:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 190, -20)
WatchFrameAnchor:SetSize(250, 20)
WatchFrame:ClearAllPoints()
WatchFrame:SetPoint("TOP", WatchFrameAnchor, 0, 0)
WatchFrame:SetWidth(250)
WatchFrame:SetHeight(500)
WatchFrame.SetPoint = function() end
WatchFrame.ClearAllPoints = function() end
if UIMovableFrames then tinsert(UIMovableFrames, WatchFrameAnchor) end

function frame_info(f)
   local str = ""
   if(f) then
      local name = f:GetName() 
      if(name) then
         str = str..name
         local parent = f:GetParent()
         if(parent) then str = str.." -> ".. frame_info(parent) end
      else str = "no name" end   
   end
   return str
end

StaticPopupDialogs["SETUP_UI"] = {
	text = "First time on Allez UI with this Character. You must reload UI to configure it.", 
	button1 = ACCEPT, 
	button2 = CANCEL,
	OnAccept = SetupUI,
	timeout = 0, 
	whileDead = 1,
	hideOnEscape = 1, 
}

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:SetScript("OnEvent", function(self, event, addon)
	self:UnregisterEvent(event)
	if not setupUI5 then
		StaticPopup_Show("SETUP_UI")
	end
end)


CreateBG = function(parent, noparent)
	local bg = CreateFrame('Frame', nil, noparent and UIParent or parent)
	bg:SetPoint('TOPLEFT', parent, 'TOPLEFT', -2, 2)
	bg:SetPoint('BOTTOMRIGHT', parent, 'BOTTOMRIGHT', 2, -2)
	bg:SetFrameLevel(parent:GetFrameLevel()-1 > 0 and parent:GetFrameLevel()-1 or 0)
	bg:SetBackdrop({
		bgFile = [=[Interface\ChatFrame\ChatFrameBackground]=],
		edgeFile = [=[Interface\ChatFrame\ChatFrameBackground]=],
		edgeSize = 1,
		insets = { left = 1, right = 1, top = 1, bottom = 1}
	})
	bg:SetBackdropColor(0, 0, 0, .65) 
    bg:SetBackdropBorderColor(.35, .3, .3, 1)
	bg.border = CreateFrame("Frame", nil, bg)
	bg.border:SetPoint("TOPLEFT", 1, -1)
	bg.border:SetPoint("BOTTOMRIGHT", -1, 1)
	bg.border:SetFrameLevel(bg:GetFrameLevel())
	bg.border:SetBackdrop({
		edgeFile = [=[Interface\ChatFrame\ChatFrameBackground]=],
		edgeSize = 1,
		insets = { left = 1, right = 1, top = 1, bottom = 1}
	})
	bg.border:SetBackdropBorderColor(0, 0, 0, 1)
	bg.border2 = CreateFrame("Frame", nil, bg)
	bg.border2:SetPoint("TOPLEFT", -1, 1)
	bg.border2:SetPoint("BOTTOMRIGHT", 1, -1)
	bg.border2:SetFrameLevel(bg:GetFrameLevel())
	bg.border2:SetBackdrop({
		edgeFile = [=[Interface\ChatFrame\ChatFrameBackground]=],
		edgeSize = 1,
		insets = { left = 1, right = 1, top = 1, bottom = 1}
	})
	bg.border2:SetBackdropBorderColor(0, 0, 0, 0.9)
	return bg
end

CreateFS = function(frame, fsize, fstyle, font, fstring)
	local fstring = fstring or frame:CreateFontString(nil, 'OVERLAY')
	fstring:SetFont(font or UIConfig.general.fonts.font, fsize or UIConfig.general.fonts.size, fstyle or UIConfig.general.fonts.style)
	fstring:SetShadowColor(0, 0, 0, 1)
	if UIConfig.general.fonts.shadow then
		fstring:SetShadowOffset(0.5, -0.5)
	else
		fstring:SetShadowOffset(0, 0)
	end
	return fstring
end
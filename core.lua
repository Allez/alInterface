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

SlashCmdList["UISETUP"] = function() 
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
	for i = 1, NUM_CHAT_WINDOWS do
		local frame = _G["ChatFrame"..i]
		frame:SetSize(400, 145)
		SetChatWindowSavedDimensions(i, 400, 145)
		if i == 1 then
			frame:ClearAllPoints()
			frame:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 12, 12)
		end
		FCF_SavePositionAndDimensions(frame)
	end
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
	ReloadUI()
end
SLASH_UISETUP1 = "/uisetup"

WatchFrame:ClearAllPoints()
WatchFrame:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 190, -20)
WatchFrame:SetWidth(250)
WatchFrame:SetHeight(500)
WatchFrame.SetPoint = function() end
WatchFrame.ClearAllPoints = function() end

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

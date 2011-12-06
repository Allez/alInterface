﻿----------------------------------------------------------------------------------------
--	WorldMap style(m_Map by Monolit)
----------------------------------------------------------------------------------------
WORLDMAP_WINDOWED_SIZE = 0.75
local mapscale = WORLDMAP_WINDOWED_SIZE

local mapbg = CreateFrame("Frame", nil, WorldMapDetailFrame)
CreateBG(mapbg)

-- Create move button for map
local movebutton = CreateFrame ("Frame", nil, WorldMapFrameSizeUpButton)
movebutton:SetHeight(32)
movebutton:SetWidth(32)
movebutton:SetPoint("TOP", WorldMapFrameSizeUpButton, "BOTTOM", -1, 4)
movebutton:SetBackdrop({bgFile = "Interface\\AddOns\\alInterface\\Media\\Cross.tga"})
movebutton:EnableMouse(true)

movebutton:SetScript("OnMouseDown", function()
	local maplock = GetCVar("advancedWorldMap")
	if maplock ~= "1" or InCombatLockdown() then return end
	WorldMapScreenAnchor:ClearAllPoints()
	WorldMapFrame:ClearAllPoints()
	WorldMapFrame:StartMoving()
	WorldMapBlobFrame:Hide()
end)

movebutton:SetScript("OnMouseUp", function()
	local maplock = GetCVar("advancedWorldMap")
	if maplock ~= "1" or InCombatLockdown() then return end
	WorldMapFrame:StopMovingOrSizing()
	WorldMapScreenAnchor:StartMoving()
	WorldMapScreenAnchor:StopMovingOrSizing()
	WorldMapBlobFrame:Show()
	WorldMapFrame:Hide()
	WorldMapFrame:Show()
end)

local SmallerMap = GetCVarBool("miniWorldMap")
if SmallerMap == nil then
	SetCVar("miniWorldMap", 1)
end

-- Styling World Map
local SmallerMapSkin = function()
	mapbg:SetScale(1 / mapscale)
	mapbg:SetPoint("TOPLEFT", WorldMapDetailFrame, 0, 0)
	mapbg:SetPoint("BOTTOMRIGHT", WorldMapDetailFrame, 0, 0)
	mapbg:SetFrameStrata("MEDIUM")
	mapbg:SetFrameLevel(20)

	WorldMapButton:SetAllPoints(WorldMapDetailFrame)
	WorldMapFrame:SetFrameStrata("MEDIUM")
	WorldMapFrame:SetClampedToScreen(true)
	--WorldMapFrame:ClearAllPoints()
	--WorldMapFrame:SetPoint("CENTER")

	WorldMapDetailFrame:SetFrameStrata("MEDIUM")

	WorldMapTitleButton:Show()
	WorldMapTitleButton:SetFrameStrata("MEDIUM")
	WorldMapTooltip:SetFrameStrata("TOOLTIP")

	WorldMapFrameMiniBorderLeft:Hide()
	WorldMapFrameMiniBorderRight:Hide()

	WorldMapFrameSizeUpButton:ClearAllPoints()
	WorldMapFrameSizeUpButton:SetPoint("TOPRIGHT", WorldMapButton, "TOPRIGHT", 3, -18)
	WorldMapFrameSizeUpButton:SetFrameStrata("HIGH")
	WorldMapFrameSizeUpButton:SetFrameLevel(18)

	WorldMapFrameCloseButton:ClearAllPoints()
	WorldMapFrameCloseButton:SetPoint("TOPRIGHT", WorldMapButton, "TOPRIGHT", 3, 3)
	WorldMapFrameCloseButton:SetFrameStrata("HIGH")

	WorldMapFrameSizeDownButton:SetPoint("TOPRIGHT", WorldMapFrameMiniBorderRight, "TOPRIGHT", -66, 7)

	WorldMapFrameTitle:ClearAllPoints()
	WorldMapFrameTitle:SetParent(WorldMapDetailFrame)
	WorldMapFrameTitle:SetPoint("TOP", WorldMapDetailFrame, 0, -3)
	WorldMapFrameTitle:SetFont(GameFontNormal:GetFont(), 17)

	WorldMapQuestShowObjectivesText:SetFont(GameFontNormal:GetFont(), 17)
	WorldMapQuestShowObjectivesText:ClearAllPoints()
	WorldMapQuestShowObjectivesText:SetPoint("BOTTOMRIGHT", WorldMapButton, "BOTTOMRIGHT", 0, 4)

	WorldMapQuestShowObjectives:SetParent(WorldMapDetailFrame)
	WorldMapQuestShowObjectives:ClearAllPoints()
	WorldMapQuestShowObjectives:SetPoint("RIGHT", WorldMapQuestShowObjectivesText, "LEFT", 0, 0)
	WorldMapQuestShowObjectives:SetFrameStrata("TOOLTIP")

	WorldMapTrackQuest:SetParent(WorldMapDetailFrame)
	WorldMapTrackQuest:ClearAllPoints()
	WorldMapTrackQuest:SetPoint("BOTTOMLEFT", WorldMapButton, "BOTTOMLEFT", 0, 0)
	WorldMapTrackQuest:SetFrameStrata("TOOLTIP")

	WorldMapTrackQuestText:SetFont(GameFontNormal:GetFont(), 17)

	WorldMapShowDigSites:SetParent(WorldMapDetailFrame)
	WorldMapShowDigSites:ClearAllPoints()
	WorldMapShowDigSites:SetPoint("BOTTOM", WorldMapQuestShowObjectives, "TOP", 0, 0)
	WorldMapShowDigSites:SetFrameStrata("TOOLTIP")

	WorldMapShowDigSitesText:ClearAllPoints()
	WorldMapShowDigSitesText:SetPoint("LEFT", WorldMapShowDigSites, "RIGHT", 0, 0)
	WorldMapShowDigSitesText:SetFont(GameFontNormal:GetFont(), 17)

	WorldMapFrameAreaLabel:SetFontObject("GameFontNormal")
	WorldMapFrameAreaLabel:SetTextColor(0.9, 0.83, 0.64)
	WorldMapFrameAreaLabel:SetFont(GameFontNormal:GetFont(), 40)

	WorldMapLevelDropDown:SetAlpha(0)
	WorldMapLevelDropDown:SetScale(0.00001)

	-- Fix tooltip not hidding after leaving quest # tracker icon
	hooksecurefunc("WorldMapQuestPOI_OnLeave", function() WorldMapTooltip:Hide() end)
end
hooksecurefunc("WorldMap_ToggleSizeDown", function() SmallerMapSkin() end)

local BiggerMapSkin = function()
	WorldMapLevelDropDown:SetAlpha(1)
	WorldMapLevelDropDown:SetScale(1)

	WorldMapQuestShowObjectivesText:ClearAllPoints()
	WorldMapQuestShowObjectivesText:SetPoint("BOTTOMRIGHT", WorldMapButton, "BOTTOMRIGHT", 0, 4)

	WorldMapQuestShowObjectives:SetParent(WorldMapDetailFrame)
	WorldMapQuestShowObjectives:ClearAllPoints()
	WorldMapQuestShowObjectives:SetPoint("RIGHT", WorldMapQuestShowObjectivesText, "LEFT", 0, 0)
	WorldMapQuestShowObjectives:SetFrameStrata("TOOLTIP")

	WorldMapShowDigSites:SetParent(WorldMapDetailFrame)
	WorldMapShowDigSites:ClearAllPoints()
	WorldMapShowDigSites:SetPoint("BOTTOM", WorldMapQuestShowObjectives, "TOP", 0, 0)
	WorldMapShowDigSites:SetFrameStrata("TOOLTIP")

	WorldMapShowDigSitesText:ClearAllPoints()
	WorldMapShowDigSitesText:SetPoint("LEFT", WorldMapShowDigSites, "RIGHT", 0, 0)
end
hooksecurefunc("WorldMap_ToggleSizeUp", function() BiggerMapSkin() end)

mapbg:SetScript("OnShow", function(self)
	local SmallerMap = GetCVarBool("miniWorldMap")
	if SmallerMap == nil then
		BiggerMapSkin()
	end
	self:SetScript("OnShow", function() end)
end)

local addon = CreateFrame("Frame")
addon:RegisterEvent("PLAYER_ENTERING_WORLD")
addon:RegisterEvent("PLAYER_REGEN_ENABLED")
addon:RegisterEvent("PLAYER_REGEN_DISABLED")
addon:SetScript("OnEvent", function(self, event)
	if event == "PLAYER_ENTERING_WORLD" then
		SetCVar("questPOI", 1)
		BlackoutWorld:Hide()
		BlackoutWorld.Show = function() end
		BlackoutWorld.Hide = function() end
		WorldMapBlobFrame.Show = function() end
		WorldMapBlobFrame.Hide = function() end
		WorldMapQuestPOI_OnLeave = function()
			WorldMapTooltip:Hide()
		end
		WorldMap_ToggleSizeDown()
		if FeedbackUIMapTip then 
			FeedbackUIMapTip:Hide()
			FeedbackUIMapTip.Show = function() end
		end
	elseif event == "PLAYER_REGEN_DISABLED" then
		WorldMapFrameSizeUpButton:Disable()
		WorldMap_ToggleSizeDown()
		WorldMapBlobFrame:DrawBlob(WORLDMAP_SETTINGS.selectedQuestId, false)
		WorldMapBlobFrame:DrawBlob(WORLDMAP_SETTINGS.selectedQuestId, true)
	elseif event == "PLAYER_REGEN_ENABLED" then
		WorldMapFrameSizeUpButton:Enable()
	end
end)

----------------------------------------------------------------------------------------
--	Creating coords
----------------------------------------------------------------------------------------
local coords = CreateFrame("Frame", "CoordsFrame", WorldMapFrame)
coords.PlayerText = WorldMapButton:CreateFontString(nil, "ARTWORK", "GameFontNormal")
coords.PlayerText:SetFont(GameFontNormal:GetFont(), 17)
coords.PlayerText:SetJustifyH("LEFT")
coords.PlayerText:SetText(UnitName("player")..": 0,0")
if (IsAddOnLoaded("_NPCScan.Overlay")) then
	coords.PlayerText:SetPoint("TOPLEFT", WorldMapButton, "TOPLEFT", 3, -25)
else
	coords.PlayerText:SetPoint("TOPLEFT", WorldMapButton, "TOPLEFT", 3, -3)
end

coords.MouseText = WorldMapButton:CreateFontString(nil, "ARTWORK", "GameFontNormal")
coords.MouseText:SetFont(GameFontNormal:GetFont(), 17)
coords.MouseText:SetJustifyH("LEFT")
coords.MouseText:SetPoint("TOPLEFT", coords.PlayerText, "BOTTOMLEFT", 0, -3)
coords.MouseText:SetText("Cursor : 0,0")

local int = 0
coords:SetScript("OnUpdate", function(self, elapsed)
	int = int + 1

	if int >= 3 then
		local inInstance, _ = IsInInstance()
		local x,y = GetPlayerMapPosition("player")
		x = math.floor(100 * x)
		y = math.floor(100 * y)
		if x ~= 0 and y ~= 0 then
			self.PlayerText:SetText(UnitName("player")..": "..x..","..y)
		else
			self.PlayerText:SetText(UnitName("player")..": ".."|cffff0000Out of bounds|r")
		end

		local scale = WorldMapDetailFrame:GetEffectiveScale()
		local width = WorldMapDetailFrame:GetWidth()
		local height = WorldMapDetailFrame:GetHeight()
		local centerX, centerY = WorldMapDetailFrame:GetCenter()
		local x, y = GetCursorPosition()
		local adjustedX = (x / scale - (centerX - (width/2))) / width
		local adjustedY = (centerY + (height/2) - y / scale) / height	

		if (adjustedX >= 0 and adjustedY >= 0 and adjustedX <= 1 and adjustedY <= 1) then
			adjustedX = math.floor(100 * adjustedX)
			adjustedY = math.floor(100 * adjustedY)
			coords.MouseText:SetText("Cursor: "..adjustedX..","..adjustedY)
		else
			coords.MouseText:SetText("Cursor: ".."|cffff0000Out of bounds|r")
		end

		int = 0
	end
end)
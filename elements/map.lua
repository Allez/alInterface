local arrowscale = 0.8
local fontsize = 15

local CreateText = function(offset)
	local text = WorldMapButton:CreateFontString(nil, 'ARTWORK')
	text:SetPoint('BOTTOMLEFT', WorldMapDetailFrame, 3 , offset)
	text:SetFont (GameFontNormal:GetFont(),fontsize,"LINE")
	text:SetJustifyH('LEFT')
	return text
end

local MouseXY = function()
	local left, top = WorldMapDetailFrame:GetLeft(), WorldMapDetailFrame:GetTop()
	local width, height = WorldMapDetailFrame:GetWidth(), WorldMapDetailFrame:GetHeight()
	local scale = WorldMapDetailFrame:GetEffectiveScale()
	local x, y = GetCursorPosition()
	local cx = (x/scale - left) / width
	local cy = (top - y/scale) / height
	if cx < 0 or cx > 1 or cy < 0 or cy > 1 then
		return
	end
	return cx, cy
end

local OnUpdate = function(player, cursor)
	local cx, cy = MouseXY()
	local px, py = GetPlayerMapPosition("player")

	if cx then
		cursor:SetFormattedText('Cursor: %.2d, %.2d', 100 * cx, 100 * cy)
	else
		cursor:SetText("")
	end

	if px == 0 then
		player:SetText("")
	else
		player:SetFormattedText(UnitName("player")..': %.2d, %.2d', 100 * px, 100 * py)
	end
end

local updateFrame = CreateFrame("Frame")
local function restoreBlobs()
	WorldMapBlobFrame_CalculateHitTranslations()
	if WorldMapQuestScrollChildFrame.selected and not WorldMapQuestScrollChildFrame.selected.completed then
		WorldMapBlobFrame:DrawQuestBlob(WorldMapQuestScrollChildFrame.selected.questId, true)
	end
	updateFrame:SetScript("OnUpdate", nil)
end

local OnEvent = function(self, event, ...)
	if event == 'PLAYER_LOGIN' then
		local player = CreateText(3)
		local cursor = CreateText(fontsize+4)
		local elapsed = 0
		WorldMap_ToggleSizeUp()
		self:SetScript('OnUpdate', function(self, u)
			elapsed = elapsed + u
			if elapsed > 0.1 then
				OnUpdate(player, cursor)
				elapsed = 0
			end
		end)
		PlayerArrowFrame:SetModelScale(arrowscale)
		PlayerArrowEffectFrame:SetModelScale(arrowscale)
		BlackoutWorld:Hide()
		UIPanelWindows["WorldMapFrame"] = nil
		WorldMapFrame:SetAttribute("UIPanelLayout-enabled", false)
		WorldMapFrame:SetParent(UIParent)
		WorldMapFrame:SetToplevel(true)
		BlackoutWorld:Hide()
		WorldMapFrame:EnableKeyboard(false)
		WorldMapFrame:EnableMouse(false)
		WorldMapFrameSizeDownButton:Disable()
	elseif event == 'PLAYER_REGEN_DISABLED' then
		WorldMapBlobFrame:SetParent(nil)
		WorldMapBlobFrame:Hide()
		WorldMapBlobFrame.Hide = function() end
		WorldMapBlobFrame.Show = function() end
		WorldMapBlobFrame.SetScale = function() end
	elseif event == 'PLAYER_REGEN_ENABLED' then
		WorldMapBlobFrame:SetParent(WorldMapFrame)
		WorldMapBlobFrame:ClearAllPoints()
		WorldMapBlobFrame:SetPoint("TOPLEFT", WorldMapDetailFrame)
		WorldMapBlobFrame.Hide = nil
		WorldMapBlobFrame.Show = nil
		WorldMapBlobFrame.SetScale = nil
		if WorldMapQuestScrollChildFrame.selected then
			WorldMapBlobFrame:DrawQuestBlob(WorldMapQuestScrollChildFrame.selected.questId, false)
		end
	end
end

local addon = CreateFrame('Frame')
addon:SetScript('OnEvent', OnEvent)
addon:RegisterEvent('PLAYER_LOGIN')
addon:RegisterEvent('PLAYER_REGEN_DISABLED')
addon:RegisterEvent('PLAYER_REGEN_ENABLED')
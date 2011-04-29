
local config = {
	["Chat background"] = false,
	["Chat font size"] = 14,
	["Chat font style"] = "OUTLINE",
	["Tab font size"] = 10,
	["Tab font style"] = "OUTLINEMONOCHROME",
	["Tab font"] = 'Fonts\\VisitorR.TTF',
}
if UIConfig then
	--UIConfig["Chat"] = config
end

local backdrop = {
	bgFile = [=[Interface\ChatFrame\ChatFrameBackground]=],
	edgeFile = [=[Interface\ChatFrame\ChatFrameBackground]=], edgeSize = 1,
	insets = {top = 0, left = 0, bottom = 0, right = 0},
}

local CreateBG = CreateBG or function(parent)
	local bg = CreateFrame('Frame', nil, parent)
	bg:SetPoint('TOPLEFT', parent, 'TOPLEFT', -1, 1)
	bg:SetPoint('BOTTOMRIGHT', parent, 'BOTTOMRIGHT', 1, -1)
	bg:SetFrameLevel(parent:GetFrameLevel() - 1)
	bg:SetBackdrop(backdrop)
	bg:SetBackdropColor(0, 0, 0, 0.5)
	bg:SetBackdropBorderColor(0, 0, 0, 1)
	return bg
end

ChatFrameMenuButton.Show = ChatFrameMenuButton.Hide
ChatFrameMenuButton:Hide()
FriendsMicroButton.Show = FriendsMicroButton.Hide
FriendsMicroButton:Hide()

for i = 1, 10 do
	local chatName = "ChatFrame"..i
	local editBox = "ChatFrame"..i.."EditBox"
	_G[chatName.."ButtonFrame"].Show = _G[chatName.."ButtonFrame"].Hide
	_G[chatName.."ButtonFrame"]:Hide()
	_G[editBox]:ClearAllPoints()
	if i == 2 then
		_G[editBox]:SetPoint("BOTTOMLEFT",  _G[chatName], "TOPLEFT",  0, 45)
		_G[editBox]:SetPoint("BOTTOMRIGHT", _G[chatName], "TOPRIGHT", 0, 45)
	else
		_G[editBox]:SetPoint("BOTTOMLEFT",  _G[chatName], "TOPLEFT",  0, 25)
		_G[editBox]:SetPoint("BOTTOMRIGHT", _G[chatName], "TOPRIGHT", 0, 25)
	end
	_G[editBox]:SetHeight(20)
	_G[editBox]:SetAltArrowKeyMode(false)
	_G[editBox].bg = CreateBG(_G[editBox])
	_G[editBox.."Left"]:Hide()
	_G[editBox.."Mid"]:Hide()
	_G[editBox.."Right"]:Hide()
	_G[editBox.."FocusLeft"]:SetTexture(nil)
	_G[editBox.."FocusMid"]:SetTexture(nil)
	_G[editBox.."FocusRight"]:SetTexture(nil) 
	_G[chatName.."TabLeft"]:Hide()
	_G[chatName.."TabRight"]:Hide()
	_G[chatName.."TabMiddle"]:Hide()
	_G[chatName.."TabSelectedLeft"]:SetTexture(nil)
	_G[chatName.."TabSelectedRight"]:SetTexture(nil)
	_G[chatName.."TabSelectedMiddle"]:SetTexture(nil)
	_G[chatName.."TabHighlightLeft"]:Hide()
	_G[chatName.."TabHighlightRight"]:Hide()
	_G[chatName.."TabHighlightMiddle"]:Hide()
	for j = 1, #CHAT_FRAME_TEXTURES do
		_G[chatName..CHAT_FRAME_TEXTURES[j]]:SetTexture(nil)
	end
	_G[chatName]:SetClampRectInsets(0, 0, 0, 0)
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:SetScript("OnEvent", function(self, event)
	self:UnregisterEvent(event)
	for i = 1, 10 do
		if config["Chat background"] then _G["ChatFrame"..i].bg = CreateBG(_G["ChatFrame"..i]) end
		_G["ChatFrame"..i]:SetFont("Fonts\\ARIALN.TTF", config["Chat font size"], config["Chat font style"])
		_G["ChatFrame"..i]:SetShadowColor(0, 0, 0, 0)
	end
	FCF_FadeInChatFrame(ChatFrame1)
	FCF_FadeOutChatFrame = function() end
end)

FCFTab_UpdateColors = function(self, selected)
	local color = RAID_CLASS_COLORS[select(2, UnitClass("player"))]
	local fs = self:GetFontString()
	fs:SetFont(config["Tab font"], config["Tab font size"], config["Tab font style"])
	fs:SetShadowOffset(0, 0)
	if selected then
		fs:SetTextColor(color.r, color.g, color.b)
	else
		fs:SetTextColor(1, 1, 1)
	end
end


local AddMsg = {}

local AddMessage = function(frame, text, ...)
	text = string.gsub(text, "%[(%d+)%. .-%]", "[%1]")
	text = ('|cffffffff|HalChat|h|r%s|h %s'):format('|cff777777'..date('%H:%M')..'|r', text)
	return AddMsg[frame:GetName()](frame, text, ...)
end

for i = 1, 10 do
	if i ~= 2 then
		AddMsg["ChatFrame"..i] = _G["ChatFrame"..i].AddMessage
		_G["ChatFrame"..i].AddMessage = AddMessage
	end
end

local uPatterns = {
	'(http://%S+)',
	'(www%.%S+)',
	'(%d+%.%d+%.%d+%.%d+:?%d*)',
}

local cTypes = {
	'CHAT_MSG_GUILD',
	'CHAT_MSG_PARTY',
	'CHAT_MSG_RAID',
	'CHAT_MSG_WHISPER',
	'CHAT_MSG_SAY',
}

for _, event in pairs(cTypes) do
	ChatFrame_AddMessageEventFilter(event, function(self, event, text, ...)
		for _, pattern in pairs(uPatterns) do
			local result, matches = string.gsub(text, pattern, '|cffffffff|Hurl:%1|h[%1]|h|r')
			if matches > 0 then
				return false, result, ...
			end
		end
	end)
end

local GetText = function(...)
	for l = 1, select("#", ...) do
		local obj = select(l, ...)
		if obj:GetObjectType() == "FontString" and obj:IsMouseOver() then
			return obj:GetText()
		end
	end
end

local SetIRef = SetItemRef
SetItemRef = function(link, text, ...)
	local txt, frame
	if link:sub(1, 6) == 'alChat' then
		frame = GetMouseFocus():GetParent()
		txt = GetText(frame:GetRegions())
		txt = txt:gsub("|c%x%x%x%x%x%x%x%x(.-)|r", "%1")
		txt = txt:gsub("|H.-|h(.-)|h", "%1")
	elseif link:sub(1, 3) == 'url' then
		frame = GetMouseFocus():GetParent()
		txt = link:sub(5)
	end
	if txt then
		local editbox
		if GetCVar('chatStyle') == 'classic' then
			editbox = LAST_ACTIVE_CHAT_EDIT_BOX
		else
			editbox = _G['ChatFrame'..frame:GetID()..'EditBox']
		end
		editbox:Show()
		editbox:Insert(txt)
		editbox:HighlightText()
		editbox:SetFocus()
		return
	end
	return SetIRef(link, text, ...)
end

DEFAULT_CHATFRAME_ALPHA = 0

CHAT_BATTLEGROUND_GET = "|Hchannel:Battleground|h[BG]|h %s:\32"
CHAT_BATTLEGROUND_LEADER_GET = "|Hchannel:Battleground|h[BGL]|h %s:\32"
CHAT_GUILD_GET = "|Hchannel:Guild|h[G]|h %s:\32"
CHAT_PARTY_GET = "|Hchannel:Party|h[P]|h %s:\32"
CHAT_PARTY_LEADER_GET = "|Hchannel:party|h[PL]|h %s:\32"
CHAT_PARTY_GUIDE_GET = "|Hchannel:PARTY|h[PL]|h %s:\32"
CHAT_OFFICER_GET = "|Hchannel:o|h[O]|h %s:\32"
CHAT_RAID_GET = "|Hchannel:raid|h[R]|h %s:\32"
CHAT_RAID_LEADER_GET = "|Hchannel:raid|h[RL]|h %s:\32"
CHAT_RAID_WARNING_GET = "[RW] %s:\32"
CHAT_FLAG_AFK = "[AFK]"
CHAT_FLAG_DND = "[DND]"

ChatTypeInfo["SAY"].sticky = 1
ChatTypeInfo["YELL"].sticky = 1
ChatTypeInfo["PARTY"].sticky = 1
ChatTypeInfo["GUILD"].sticky = 1
ChatTypeInfo["OFFICER"].sticky = 1
ChatTypeInfo["RAID"].sticky = 1
ChatTypeInfo["RAID_WARNING"].sticky = 1
ChatTypeInfo["BATTLEGROUND"].sticky = 1
ChatTypeInfo["WHISPER"].sticky = 1
ChatTypeInfo["CHANNEL"].sticky = 1
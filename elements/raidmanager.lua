-- Config start
local anchor = "TOPLEFT"
local x, y = 12, -136
local font = "Fonts\\VisitorR.TTF"
local font_style = "OUTLINEMONOCHROME"
local font_size = 10
-- Config end

local config = {
	["Font"] = font,
	["Font size"] = font_size,
	["Font style"] = font_style,
}
if UIConfig then
	--UIConfig["Raid manager"] = config
end

local backdrop = {
	bgFile = [=[Interface\ChatFrame\ChatFrameBackground]=],
	edgeFile = [=[Interface\ChatFrame\ChatFrameBackground]=], edgeSize = 1,
	insets = {top = 0, left = 0, bottom = 0, right = 0},
}

CompactRaidFrameManager:Hide()
CompactRaidFrameManager:UnregisterAllEvents()
CompactRaidFrameManager:SetScript("OnUpdate", nil)
CompactRaidFrameContainer:Hide()
CompactRaidFrameContainer:UnregisterAllEvents()
CompactRaidFrameContainer:SetScript("OnUpdate", nil)

local CreateBG = CreateBG or function(parent)
	local bg = CreateFrame('Frame', nil, parent)
	bg:SetPoint('TOPLEFT', parent, 'TOPLEFT', -1, 1)
	bg:SetPoint('BOTTOMRIGHT', parent, 'BOTTOMRIGHT', 1, -1)
	bg:SetFrameLevel(parent:GetFrameLevel() - 1)
	bg:SetBackdrop(backdrop)
	bg:SetBackdropColor(0, 0, 0, 0.4)
	bg:SetBackdropBorderColor(0, 0, 0, 1)
	return bg
end

local CreateFS = function(frame)
	local fstring = frame:CreateFontString(nil, 'OVERLAY')
	fstring:SetFont(config["Font"], config["Font size"], config["Font style"])
	fstring:SetShadowColor(0, 0, 0, 1)
	fstring:SetShadowOffset(0, 0)
	return fstring
end

local main = CreateFrame("Frame", nil, UIParent)
main:SetSize(212, 102)
main.bg = CreateBG(main)
main:Hide()

local toggle = CreateFrame("Button", "RaidControlFrameToggle", UIParent)
toggle:SetSize(125, 13)
toggle:SetPoint(anchor, x, y)
toggle:SetScript("OnClick", function()
	if main:IsShown() then
		main:Hide()
	else
		main:Show()
	end
end)
toggle.label = CreateFS(toggle)
toggle.label:SetPoint("CENTER", 0, 1)
toggle.label:SetText(RAID_CONTROL)
toggle.bg = CreateBG(toggle)
if UIMovableFrames then tinsert(UIMovableFrames, toggle) end

main:SetPoint("TOPLEFT", toggle, "BOTTOMLEFT", 0, -5)

local rolecheck = CreateFrame("Button", nil, main)
rolecheck:SetPoint("TOP", 0, -5)
rolecheck:SetSize(main:GetSize() - 10, 20)
rolecheck:SetScript("OnClick", function()
	InitiateRolePoll()
end)
rolecheck.label = CreateFS(rolecheck)
rolecheck.label:SetPoint("CENTER")
rolecheck.label:SetText(ROLE_POLL)
rolecheck.bg = CreateBG(rolecheck)

local maintank = CreateFrame("Button", nil, main, "SecureActionButtonTemplate")
maintank:SetPoint("TOPLEFT", rolecheck, "BOTTOMLEFT", 0, -5)
maintank:SetSize((main:GetSize() - 10) / 2 - 3, 20)
maintank:SetAttribute("type", "maintank")
maintank:SetAttribute("unit", "target")
maintank:SetAttribute("action", "set")
maintank.label = CreateFS(maintank)
maintank.label:SetPoint("CENTER")
maintank.label:SetText(MAINTANK)
maintank.bg = CreateBG(maintank)

local mainassist = CreateFrame("Button", nil, main, "SecureActionButtonTemplate")
mainassist:SetPoint("LEFT", maintank, "RIGHT", 5, 0)
mainassist:SetSize((main:GetSize() - 10) / 2 - 2, 20)
mainassist:SetAttribute("type", "mainassist")
mainassist:SetAttribute("unit", "target")
mainassist:SetAttribute("action", "set")
mainassist.label = CreateFS(mainassist)
mainassist.label:SetPoint("CENTER")
mainassist.label:SetText(MAINASSIST)
mainassist.bg = CreateBG(mainassist)

local readycheck = CreateFrame("Button", nil, main)
readycheck:SetPoint("TOPLEFT", maintank, "BOTTOMLEFT", 0, -5)
readycheck:SetSize(main:GetSize() - 55, 20)
readycheck:SetScript("OnClick", function()
	DoReadyCheck()
end)
readycheck.label = CreateFS(readycheck)
readycheck.label:SetPoint("CENTER")
readycheck.label:SetText(READY_CHECK)
readycheck.bg = CreateBG(readycheck)

local worldmarker = CreateFrame("Button", "alWorldMarkerButton", main, "SecureActionButtonTemplate")
worldmarker:SetPoint("LEFT", readycheck, "RIGHT", 5, 0)
worldmarker:SetSize(40, 20)
CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton:SetAllPoints(worldmarker)
worldmarker:SetAttribute("type", "macro")
worldmarker:SetAttribute("macrotext", [=[
/click CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton
]=])
worldmarker.texture = worldmarker:CreateTexture(nil, "OVERLAY")
worldmarker.texture:SetTexture("Interface\\RaidFrame\\Raid-WorldPing")
worldmarker.texture:SetSize(18, 18)
worldmarker.texture:SetPoint("CENTER")
worldmarker.bg = CreateBG(worldmarker)

local marks = {}
for i = 1, 8 do
	marks[i] = CreateFrame("Button", nil, main)
	marks[i]:SetSize(18, 18)
	if i == 1 then
		marks[i]:SetPoint("TOPLEFT", readycheck, "BOTTOMLEFT", 0, -5)
	else
		marks[i]:SetPoint("LEFT", marks[i-1], "RIGHT", 5, 0)
	end
	local left = mod((i - 1) / 4, 1)
	local right = left + 0.25
	local top = floor((i - 1) / 4) * 0.25
	local bottom = top + 0.25
	marks[i]:SetNormalTexture("Interface\\TargetingFrame\\UI-RaidTargetingIcons")
	marks[i]:GetNormalTexture():SetTexCoord(left, right, top, bottom)
	marks[i]:SetScript("OnClick", function()
		SetRaidTarget("target", i)
	end)
	marks[i].bg = CreateBG(marks[i])
end
local rmark = CreateFrame("Button", nil, main)
rmark:SetSize(18, 18)
rmark:SetPoint("LEFT", marks[8], "RIGHT", 5, 0)
rmark:SetNormalTexture("Interface\\Buttons\\UI-GroupLoot-Pass-Up")
rmark:SetScript("OnClick", function()
	SetRaidTarget("target", 0)
end)
rmark.bg = CreateBG(rmark)

local frame = CreateFrame("Frame")
frame:RegisterEvent("RAID_ROSTER_UPDATE")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:SetScript("OnEvent", function(self, event, ...)
	if UnitIsRaidOfficer("player") then
		toggle:Show()
	else
		toggle:Hide()
		main:Hide()
	end
end)
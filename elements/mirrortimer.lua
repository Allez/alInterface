
-- Config start
local width = 150
local height = 14
local spacing = 7
local anchor = "TOP"
local x, y = 0, -100
local font = 'Fonts\\VisitorR.TTF'
local font_size = 10
local font_style = 'OUTLINEMONOCHROME'
-- Config end

local config = {
	["Font"] = font,
	["Font size"] = font_size,
	["Font style"] = font_style,
	["Spacing"] = spacing,
	["Width"] = width,
	["Height"] = height,
}
if UIConfig then
	UIConfig["Threat Meter"] = config
end

local backdrop = {
	bgFile = [=[Interface\ChatFrame\ChatFrameBackground]=],
	edgeFile = [=[Interface\ChatFrame\ChatFrameBackground]=], edgeSize = 1,
	insets = {top = 0, left = 0, bottom = 0, right = 0},
}

local anchorframe = CreateFrame("Frame", "Mirror_Timer", UIParent)
anchorframe:SetSize(width, height)
anchorframe:SetPoint(anchor, x, y)
if UIMovableFrames then tinsert(UIMovableFrames, anchorframe) end

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

local mirrorTimers = {}

local CreateMirrorTimer = function()
	local mtimer = CreateFrame("StatusBar", nil, UIParent)
	mtimer:SetWidth(config["Width"])
	mtimer:SetHeight(config["Height"])
	mtimer:SetPoint("TOP", anchorframe, 0, - (#mirrorTimers * (config["Height"] + config["Spacing"])))
	mtimer.bg = CreateBG(mtimer)
	mtimer:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
	mtimer.label = mtimer:CreateFontString(nil, "ARTWORK")
	mtimer.label:SetPoint("LEFT", 2, 0)
	mtimer.label:SetPoint("RIGHT", -2, 0)
	mtimer.label:SetFont(config["Font"], config["Font size"], config["Font style"])
	mtimer.label:SetJustifyH('CENTER')
	mtimer:Hide()
	tinsert(mirrorTimers, mtimer)
	return mtimer
end

local GetMirrorTimer = function(timer)
	for i, v in pairs(mirrorTimers) do
		if v.timer == timer then
			return v
		end
	end
	for i, v in pairs(mirrorTimers) do
		if not v.timer then
			return v
		end
	end
	return CreateMirrorTimer()
end

local OnUpdate = function(self, elapsed)
	if self.paused then return end
	self:SetValue(GetMirrorTimerProgress(self.timer) / 1000)
end

local ShowTimer = function(timer, value, maxvalue, scale, paused, label)
	local mTimer = GetMirrorTimer(timer)
	mTimer.timer = timer
	if paused > 0 then
		mTimer.paused = 1
	else
		mTimer.paused = nil
	end
	mTimer.label:SetText(label)
	local color = MirrorTimerColors[timer]
	mTimer:SetStatusBarColor(color.r, color.g, color.b)
	mTimer:SetMinMaxValues(0, (maxvalue / 1000))
	mTimer:SetValue(value / 1000)
	mTimer:SetScript("OnUpdate", OnUpdate)
	mTimer:Show()
end

local OnEvent = function(self, event, ...)
	if event == "PLAYER_ENTERING_WORLD" then
		for i = 1, MIRRORTIMER_NUMTIMERS do
			local timer, value, maxvalue, scale, paused, label = GetMirrorTimerInfo(i)
			if  timer ~=  "UNKNOWN" then
				ShowTimer(timer, value, maxvalue, scale, paused, label)
			end
		end
	elseif event == "MIRROR_TIMER_START" then
		local timer, value, maxvalue, scale, paused, label = ...
		ShowTimer(timer, value, maxvalue, scale, paused, label)
	elseif event == "MIRROR_TIMER_STOP" then
		local timer = ...
		for i, v in pairs(mirrorTimers) do
			if v.timer == timer then
				v.timer = nil
				v:SetScript("OnUpdate", nil)
				v:Hide()
			end
		end
	elseif event == "MIRROR_TIMER_PAUSE" then
		local duration = ...
		for i, v in pairs(mirrorTimers) do
			if duration > 0 then
				v.paused = 1
			else
				v.paused = nil
			end
		end
	end
end


local addon = CreateFrame("frame")
addon:SetScript('OnEvent', OnEvent)
addon:RegisterEvent("MIRROR_TIMER_START")
addon:RegisterEvent("MIRROR_TIMER_STOP")
addon:RegisterEvent("MIRROR_TIMER_PAUSE")
addon:RegisterEvent("PLAYER_ENTERING_WORLD")
UIParent:UnregisterEvent("MIRROR_TIMER_START")
for i = 1, MIRRORTIMER_NUMTIMERS do
	_G["MirrorTimer"..i]:UnregisterAllEvents()
end
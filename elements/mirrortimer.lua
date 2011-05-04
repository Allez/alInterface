
local config = {
	general = {
		width = {
			order = 1,
			value = 150,
			type = "range",
			min = 50,
			max = 500,
		},
		height = {
			order = 2,
			value = 14,
			type = "range",
			min = 5,
			max = 50,
		},
		spacing = {
			order = 3,
			value = 7,
			type = "range",
			min = 0,
			max = 30,
		},
	},
}

local cfg = {}
UIConfigGUI.mirrortimer = config
UIConfig.mirrortimer = cfg

local anchorframe = CreateFrame("Frame", "Mirror_Timer", UIParent)
anchorframe:SetSize(150, 14)
anchorframe:SetPoint("TOP", 0, -100)
if UIMovableFrames then tinsert(UIMovableFrames, anchorframe) end

local mirrorTimers = {}

local CreateMirrorTimer = function()
	local mtimer = CreateFrame("StatusBar", nil, UIParent)
	mtimer:SetWidth(cfg.general.width)
	mtimer:SetHeight(cfg.general.height)
	mtimer:SetPoint("TOP", anchorframe, 0, - (#mirrorTimers * (cfg.general.height + cfg.general.spacing)))
	mtimer.bg = CreateBG(mtimer)
	mtimer:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
	mtimer.label = CreateFS(mtimer)
	mtimer.label:SetPoint("LEFT", 2, 0)
	mtimer.label:SetPoint("RIGHT", -2, 0)
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
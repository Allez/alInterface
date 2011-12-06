
--	Skin TimerTracker(by Tukz)

local function SkinTimer(bar)
	for i = 1, bar:GetNumRegions() do
		local region = select(i, bar:GetRegions())
		if region:GetObjectType() == "Texture" then
			region:SetTexture(nil)
		elseif region:GetObjectType() == "FontString" then
			region:SetFont(UIConfig.general.fonts.font, UIConfig.general.fonts.size, UIConfig.general.fonts.style)
			region:SetShadowOffset(0, 0)
		end
	end

	bar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
	bar:SetStatusBarColor(0.7, 0, 0)

	CreateBG(bar)
end

local function SkinBlizzTimer(self, event, timerType, timeSeconds, totalTime)
	for _, v in pairs(TimerTracker.timerList) do
		if v["bar"] and not v["bar"].skinned then
			SkinTimer(v["bar"])
			v["bar"].skinned = true
		end
	end
end

local load = CreateFrame("Frame")
load:RegisterEvent("START_TIMER")
load:SetScript("OnEvent", SkinBlizzTimer)
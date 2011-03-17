if select(2, UnitClass("player")) ~= "SHAMAN" then return end

local bar = CreateBar("uiTotemBar")
bar:SetPoint("BOTTOMLEFT", 12, 210)
bar.rows = 1
bar.buttons = {}

if MultiCastActionBarFrame then
	MultiCastActionBarFrame:SetScript("OnUpdate", nil)
	MultiCastActionBarFrame:SetScript("OnShow", nil)
	MultiCastActionBarFrame:SetScript("OnHide", nil)
	MultiCastActionBarFrame:SetParent(bar)
	MultiCastActionBarFrame:ClearAllPoints()
	MultiCastActionBarFrame:SetPoint("BOTTOMLEFT", bar, 0, 0)
	for i = 1, 4 do
		local b = _G["MultiCastSlotButton"..i]
		local b2 = _G["MultiCastActionButton"..i]
		b:ClearAllPoints()
		b:SetAllPoints(b2)
	end
	MultiCastActionBarFrame.SetParent = function() end
	MultiCastActionBarFrame.SetPoint = function() end
	MultiCastRecallSpellButton.SetPoint = function() end
end
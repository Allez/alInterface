if select(2, UnitClass("player")) ~= "SHAMAN" then return end

local bar = CreateBar("uiTotemBar")
bar:SetPoint("BOTTOMLEFT", 12, 210)
bar.rows = 1
bar.buttons = {}
tinsert(bar.buttons, _G["MultiCastSummonSpellButton"])
for i = 1, NUM_MULTI_CAST_BUTTONS_PER_PAGE do
	tinsert(bar.buttons, _G["MultiCastSlotButton"..i])
end
tinsert(bar.buttons, _G["MultiCastRecallSpellButton"])

if MultiCastActionBarFrame then
	MultiCastActionBarFrame:SetScript("OnUpdate", nil)
	MultiCastActionBarFrame:SetScript("OnShow", nil)
	MultiCastActionBarFrame:SetScript("OnHide", nil)
	hooksecurefunc("MultiCastActionButton_Update", function(actionbutton) 
		if not InCombatLockdown() then 
			actionbutton:SetAllPoints(actionbutton.slotButton)
		end
	end)
	hooksecurefunc("MultiCastSummonSpellButton_Update", function(self) 
		if not InCombatLockdown() then 
			SetButtons(bar)
		end
	end)
	local index = 1
	for i = 1, NUM_MULTI_CAST_PAGES do
		for j = 1, NUM_MULTI_CAST_BUTTONS_PER_PAGE do
			_G["MultiCastActionButton"..index]:SetAllPoints(_G["MultiCastSlotButton"..j])
			index = index + 1
		end
	end
	
	MultiCastActionBarFrame.SetParent = function() end
	MultiCastActionBarFrame.SetPoint = function() end
	
	local frame = CreateFrame("Frame")
	frame:RegisterEvent("PLAYER_ENTERING_WORLD")
	frame:SetScript("OnEvent", function(self, event)
		self:UnregisterEvent(event)
		if not InCombatLockdown() then
			MultiCastRecallSpellButton.SetPoint = function() end
		end
	end)
end
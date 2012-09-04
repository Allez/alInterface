local bar = CreateBar("uiClassBar")
bar:SetPoint("BOTTOMLEFT", 12, 210)
bar.rows = 1
bar.buttons = {}
for i = 1, NUM_SHAPESHIFT_SLOTS do
	tinsert(bar.buttons, _G["ShapeshiftButton"..i])
end

hooksecurefunc("ShapeshiftBar_Update", function()
	if GetNumShapeshiftForms() == 1 and not InCombatLockdown() then
		ShapeshiftButton1:SetPoint("BOTTOMLEFT", bar, "BOTTOMLEFT", 0, 0)
	end
end)
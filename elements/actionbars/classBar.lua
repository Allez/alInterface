local bar = CreateBar("uiClassBar")
bar:SetPoint("BOTTOMLEFT", 12, 210)
bar.rows = 1
bar.buttons = {}
for i = 1, NUM_STANCE_SLOTS do
	tinsert(bar.buttons, _G["StanceButton"..i])
end

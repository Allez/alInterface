local bar = CreateBar("uiPetBar")
bar:SetPoint("BOTTOM", 0, 101)
bar.rows = 1
bar.buttons = {}
for i = 1, NUM_PET_ACTION_SLOTS do
	tinsert(bar.buttons, _G["PetActionButton"..i])
end
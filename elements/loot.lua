local addon_name, ns = ...

local config = {
	general = {
		width = {
			order = 1,
			value = 150,
			type = "range",
			min = 50,
			max = 400,
		},
		slotsize = {
			order = 2,
			value = 25,
			type = "range",
			min = 10,
			max = 50,
		},
	},
}

local cfg = {}
UIConfigGUI.loot = config
UIConfig.loot = cfg

local lootSlots = {}
local backdrop = {
	bgFile = [=[Interface\ChatFrame\ChatFrameBackground]=],
	edgeFile = [=[Interface\ChatFrame\ChatFrameBackground]=], edgeSize = 1,
	insets = {top = 0, left = 0, bottom = 0, right = 0},
}

local anchorframe = CreateFrame("Frame", "ItemLoot", UIParent)
anchorframe:SetSize(150, 15)
anchorframe:SetPoint("TOPLEFT", 300, -300)
if UIMovableFrames then tinsert(UIMovableFrames, anchorframe) end

local OnClick = function(self)
	if IsModifiedClick() then
		HandleModifiedItemClick(GetLootSlotLink(self.id))
	else
		StaticPopup_Hide("CONFIRM_LOOT_DISTRIBUTION")
		LootFrame.selectedSlot = self.id
		LootFrame.selectedQuality = self.quality
		LootFrame.selectedItemName = self.text:GetText()
		LootSlot(self.id)
	end
end

local OnEnter = function(self)
	if LootSlotIsItem(self.id) then
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
		GameTooltip:SetLootItem(self.id);
		CursorUpdate(self);
	end
end

local OnLeave = function(self)
	GameTooltip:Hide()
	ResetCursor()
end

local CreateLootSlot = function(self, id)
	local slot = CreateFrame("Button", nil, self)
	slot:SetPoint("TOPLEFT", 3, -20 - (id - 1) * (cfg.general.slotsize + 5))
	slot:SetSize(cfg.general.slotsize, cfg.general.slotsize)
	slot.bg = CreateBG(slot)
	slot.texture = slot:CreateTexture(nil, "BORDER")
	slot.texture:SetAllPoints()
	slot.texture:SetTexCoord(0.07, 0.93, 0.07, 0.93)
	slot.text = CreateFS(slot)
	slot.text:SetPoint("LEFT", slot, "RIGHT", 4, 0)
	slot.text:SetPoint("RIGHT", slot:GetParent(), "RIGHT", -4, 0)
	slot.text:SetJustifyH("LEFT")
	slot.count = CreateFS(slot)
	slot.count:SetPoint("BOTTOMRIGHT", 0, 0)
	slot:SetScript("OnClick", OnClick)
	slot:SetScript("OnEnter", OnEnter)
	slot:SetScript("OnLeave", OnLeave)
	slot:Hide()
	return slot
end

local GetLootSlot = function(self, id)
	if not lootSlots[id] then 
		lootSlots[id] = CreateLootSlot(self, id)
	end
	return lootSlots[id]
end

local UpdateLootSlot = function(self, id)
	local lootSlot = GetLootSlot(self, id)
	local texture, item, quantity, quality, locked = GetLootSlotInfo(id)
	local color = ITEM_QUALITY_COLORS[quality]
	lootSlot.quality = quality
	lootSlot.id = id
	lootSlot.texture:SetTexture(texture)
	lootSlot:SetBackdropBorderColor(color.r, color.g, color.b)
	lootSlot.text:SetText(item)
	lootSlot.text:SetTextColor(color.r, color.g, color.b)
	if quantity > 1 then
		lootSlot.count:SetText(quantity)
		lootSlot.count:Show()
	else
		lootSlot.count:Hide()
	end
	lootSlot:Show()
end

local OnEvent = function(self, event, ...)
	if event == "VARIABLES_LOADED" then
		--local name = ...
		--if name == addon_name then
			self:UnregisterEvent("ADDON_LOADED")
			self:SetWidth(cfg.general.width)
			self.bg = CreateBG(self)
			self:SetPoint("TOP", anchorframe, 0, 0)
			self:SetFrameStrata("HIGH")
			self:SetToplevel(true)
			self.title = CreateFS(self)
			self.title:SetPoint("TOPLEFT", 3, -4)
			self.title:SetPoint("TOPRIGHT", -16, -4)
			self.title:SetJustifyH("LEFT")
			self.button = CreateFrame("Button", nil, self)
			self.button:SetPoint("TOPRIGHT")
			self.button:SetSize(20, 20)
			self.button:SetNormalTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Up")
			self.button:SetPushedTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Down")
			self.button:SetHighlightTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Highlight")
			self.button:SetScript("OnClick", function()
				CloseLoot()
			end)
		--end
	elseif event == "LOOT_OPENED" then
		local autoLoot = ...
		self:Show()
		if UnitExists("target") and UnitIsDead("target") then
			self.title:SetText(UnitName("target"))
		else
			self.title:SetText(ITEMS)
		end
		local numLootItems = GetNumLootItems()
		self:SetHeight(numLootItems * (cfg.general.slotsize + 5) + 20)
		if GetCVar("lootUnderMouse") == "1" then
			local x, y = GetCursorPosition()
			x = x / self:GetEffectiveScale()
			y = y / self:GetEffectiveScale()
			local posX = x - 15
			local posY = y + 32
			if posY < 350 then
				posY = 350
			end
			self:ClearAllPoints()
			self:SetPoint("TOPLEFT", nil, "BOTTOMLEFT", posX, posY)
			self:GetCenter()
			self:Raise()
		end
		for i = 1, numLootItems do
			UpdateLootSlot(self, i)
		end
		if not self:IsShown() then
			CloseLoot(autoLoot == 0)
		end
	elseif event == "LOOT_SLOT_CLEARED" then
		local slotId = ...
		if not self:IsShown() then return end
		if slotId > 0 then
			if lootSlots[slotId] then
				lootSlots[slotId]:Hide()
			end
		end
	elseif event == "LOOT_SLOT_CHANGED" then
		local slotId = ...
		UpdateLootSlot(self, slotId)
	elseif event == "LOOT_CLOSED" then
		StaticPopup_Hide("LOOT_BIND")
		for i, v in pairs(lootSlots) do
			v:Hide()
		end
		self:Hide()
	elseif event == "OPEN_MASTER_LOOT_LIST" then
		ToggleDropDownMenu(1, nil, GroupLootDropDown, lootSlots[LootFrame.selectedSlot], 0, 0)
	elseif event == "UPDATE_MASTER_LOOT_LIST" then
		UIDropDownMenu_Refresh(GroupLootDropDown)
	end
end


local addon = CreateFrame("frame", nil, UIParent)
addon:SetScript('OnEvent', OnEvent)
addon:RegisterEvent("VARIABLES_LOADED")
addon:RegisterEvent("LOOT_OPENED")
addon:RegisterEvent("LOOT_SLOT_CLEARED")
addon:RegisterEvent("LOOT_SLOT_CHANGED")
addon:RegisterEvent("LOOT_CLOSED")
addon:RegisterEvent("OPEN_MASTER_LOOT_LIST")
addon:RegisterEvent("UPDATE_MASTER_LOOT_LIST")
LootFrame:UnregisterAllEvents()
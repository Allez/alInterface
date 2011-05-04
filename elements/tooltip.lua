
local config = {
	general = {
		anchorcursor = {
			order = 1,
			value = false,
		},
	},
}

local cfg = {}
UIConfigGUI.tooltip = config
UIConfig.tooltip = cfg

local anchorframe = CreateFrame("Frame", "Tooltip anchor", UIParent)
anchorframe:SetSize(150, 20)
anchorframe:SetPoint("BOTTOMRIGHT", -12, 180)
if UIMovableFrames then tinsert(UIMovableFrames, anchorframe) end

local backdrop = {
	bgFile = [=[Interface\ChatFrame\ChatFrameBackground]=],
	edgeFile = [=[Interface\ChatFrame\ChatFrameBackground]=], edgeSize = 1,
	insets = {top = 0, left = 0, bottom = 0, right = 0},
}

local tooltips = {
	GameTooltip,
	ItemRefTooltip, 
	ShoppingTooltip1, 
	ShoppingTooltip2, 
	ShoppingTooltip3, 
	WorldMapTooltip, 
--	DropDownList1MenuBackdrop, 
--	DropDownList2MenuBackdrop, 
}

if not IsAddOnLoaded("Aurora") then 
	tinsert(tooltips, DropDownList1MenuBackdrop)
	tinsert(tooltips, DropDownList2MenuBackdrop)
end

local types = {
	rare = " R ",
	elite = " + ",
	worldboss = " B ",
	rareelite = " R+ ",
}

for _, v in pairs(tooltips) do
	v:SetBackdrop(nil)
	v.bg = CreateBG(v)
	v:SetScript("OnShow", function(self)
		self.bg:SetBackdropColor(0, 0, 0, 0.8)
		local item
		if self.GetItem then
			item = select(2, self:GetItem())
		end
		if item then
			local quality = select(3, GetItemInfo(item))
			if quality and quality > 1 then
				local r, g, b = GetItemQualityColor(quality)
				self.bg:SetBackdropBorderColor(r, g, b)
			end
		else
			self.bg:SetBackdropBorderColor(0.4, 0.4, 0.4)
		end
	end)
	v:HookScript("OnHide", function(self)
		self.bg:SetBackdropBorderColor(0.4, 0.4, 0.4, 1)
	end)
end

local hex = function(r, g, b)
	return ('|cff%02x%02x%02x'):format(r * 255, g * 255, b * 255)
end

local truncate = function(value)
	if value >= 1e6 then
		return string.format('%.2fm', value / 1e6)
	elseif value >= 1e4 then
		return string.format('%.1fk', value / 1e3)
	else
		return string.format('%.0f', value)
	end
end

function GameTooltip_UnitColor(unit)
	local r, g, b = 1, 1, 1
	if UnitPlayerControlled(unit) then
		if UnitCanAttack(unit, "player") then
			if UnitCanAttack("player", unit) then
				r = FACTION_BAR_COLORS[2].r
				g = FACTION_BAR_COLORS[2].g
				b = FACTION_BAR_COLORS[2].b
			end
		elseif UnitCanAttack("player", unit) then
			r = FACTION_BAR_COLORS[4].r
			g = FACTION_BAR_COLORS[4].g
			b = FACTION_BAR_COLORS[4].b
		elseif UnitIsPVP(unit) then
			r = FACTION_BAR_COLORS[6].r
			g = FACTION_BAR_COLORS[6].g
			b = FACTION_BAR_COLORS[6].b
		end
	else
		local reaction = UnitReaction(unit, "player")
		if reaction then
			r = FACTION_BAR_COLORS[reaction].r
			g = FACTION_BAR_COLORS[reaction].g
			b = FACTION_BAR_COLORS[reaction].b
		end
	end
	if UnitIsPlayer(unit) then
		local class = select(2, UnitClass(unit))
		if class then
			r = RAID_CLASS_COLORS[class].r
			g = RAID_CLASS_COLORS[class].g
			b = RAID_CLASS_COLORS[class].b
		end
	end
	return r, g, b
end

GameTooltip:HookScript("OnTooltipSetUnit", function(self)
	local unit = select(2, self:GetUnit())
	if unit then
		local unitClassification = types[UnitClassification(unit)] or " "
		local diffColor = GetQuestDifficultyColor(UnitLevel(unit))
		local creatureType = UnitCreatureType(unit) or ""
		local unitName = UnitName(unit)
		local unitLevel = UnitLevel(unit)
		if unitLevel < 0 then unitLevel = '??' end
		if UnitIsPlayer(unit) then
			local unitRace = UnitRace(unit)
			local unitClass = UnitClass(unit)
			local guild, rank = GetGuildInfo(unit)
			if guild then
				GameTooltipTextLeft2:SetFormattedText(hex(0, 1, 1).."%s|r %s", guild, rank)
			end
			for i=2, GameTooltip:NumLines() do
				if _G["GameTooltipTextLeft" .. i]:GetText():find(PLAYER) then
					_G["GameTooltipTextLeft" .. i]:SetText(string.format(hex(diffColor.r, diffColor.g, diffColor.b).."%s|r ", unitLevel) .. unitRace)
					break
				end
			end
		else
			for i=2, GameTooltip:NumLines() do
				if _G["GameTooltipTextLeft" .. i]:GetText():find(LEVEL) or _G["GameTooltipTextLeft" .. i]:GetText():find(creatureType) then
					_G["GameTooltipTextLeft" .. i]:SetText(string.format(hex(diffColor.r, diffColor.g, diffColor.b).."%s|r", unitLevel) .. unitClassification .. creatureType)
					break
				end
			end
		end
		if UnitIsPVP(unit) then
			for i = 2, GameTooltip:NumLines() do
				if _G["GameTooltipTextLeft"..i]:GetText():find(PVP) then
					_G["GameTooltipTextLeft"..i]:SetText(nil)
					break
				end
			end
		end
		if UnitExists(unit.."target") then
			local r, g, b = GameTooltip_UnitColor(unit.."target")
			if UnitName(unit.."target") == UnitName("player") then
				text = hex(1, 0, 0).."<You>|r"
			else
				text = hex(r, g, b)..UnitName(unit.."target").."|r"
			end
			self:AddLine(TARGET..": "..text)
		end
	end
end)

GameTooltipStatusBar.bg = CreateBG(GameTooltipStatusBar)
GameTooltipStatusBar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
GameTooltipStatusBar:ClearAllPoints()
GameTooltipStatusBar:SetPoint("TOPLEFT", GameTooltip, "BOTTOMLEFT", 0, -5)
GameTooltipStatusBar:SetPoint("TOPRIGHT", GameTooltip, "BOTTOMRIGHT", 0, -5)
GameTooltipStatusBar:SetHeight(7)
GameTooltipStatusBar:HookScript("OnValueChanged", function(self, value)
	if not value then
		return
	end
	local min, max = self:GetMinMaxValues()
	if value < min or value > max then
		return
	end
	local unit  = select(2, GameTooltip:GetUnit())
	if unit then
		min, max = UnitHealth(unit), UnitHealthMax(unit)
		if not self.text then
			self.text = self:CreateFontString(nil, "OVERLAY")
			self.text:SetPoint("CENTER", GameTooltipStatusBar, 0, 1)
			self.text:SetFont(UIConfig.general.fonts.font, UIConfig.general.fonts.size, UIConfig.general.fonts.style)
		end
		self.text:Show()
		local hp = truncate(min).." / "..truncate(max)
		self.text:SetText(hp)
	else
		if self.text then self.text:Hide() end
	end
end)


local iconFrame = CreateFrame("Frame", nil, ItemRefTooltip)
iconFrame:SetSize(28, 28)
iconFrame:SetPoint("TOPRIGHT", ItemRefTooltip, "TOPLEFT", -5, 0)
iconFrame.bg = CreateBG(iconFrame)
iconFrame.icon = iconFrame:CreateTexture(nil, "BACKGROUND")
iconFrame.icon:SetAllPoints()
iconFrame.icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)

hooksecurefunc("SetItemRef", function(link, text, button)
	if iconFrame:IsShown() then
		iconFrame:Hide()
	end
	local type, id = string.match(link, "(%l+):(%d+)") 
	if type == "item" then
		iconFrame.icon:SetTexture(select(10, GetItemInfo(id)))
		iconFrame:Show()
	elseif type == "spell" then
		iconFrame.icon:SetTexture(select(3, GetSpellInfo(id)))
		iconFrame:Show()
	elseif type == "achievement" then
		iconFrame.icon:SetTexture(select(10, GetAchievementInfo(id)))
		iconFrame:Show()
	end
end)

hooksecurefunc("GameTooltip_SetDefaultAnchor", function(tooltip, parent)
	if not cfg.general.anchorcursor then
		tooltip:SetOwner(parent, "ANCHOR_NONE")
		tooltip:SetPoint("BOTTOMRIGHT", anchorframe, 0, 0)
	else
		tooltip:SetOwner(parent, "ANCHOR_CURSOR")
	end
	tooltip.default = 1
end)
-- Config start
local font = 'Fonts\\VisitorR.TTF'
local font_size = 10
local font_style = 'OUTLINEMONOCHROME'
local button_size = 25
local spacing = 7
-- Config end

local config = {
	["Button size"] = button_size,
	["Button spacing"] = spacing,
	["Bag bar"] = true,
	["Font"] = font,
	["Font size"] = font_size,
	["Font style"] = font_style,
	["Bank columns"] = 12,
	["Bags columns"] = 8,
}
if UIConfig then
	UIConfig["Bags and bank"] = config
end

local _, ns = ...

local addon = ns.cargBags:NewImplementation("alBags")
local button = addon:GetItemButtonClass()
local container = addon:GetContainerClass()
local bag = addon:GetClass("BagButton", true, "BagButton")
button:Scaffold("Default")

local backdrop = {
	bgFile = [=[Interface\ChatFrame\ChatFrameBackground]=],
	edgeFile = [=[Interface\ChatFrame\ChatFrameBackground]=], edgeSize = 1,
	insets = {top = 0, left = 0, bottom = 0, right = 0},
}

addon:RegisterBlizzard()

local CreateBG = CreateBG or function(parent)
	local bg = CreateFrame("Frame", nil, parent)
	bg:SetPoint("TOPLEFT", -1, 1)
	bg:SetPoint("BOTTOMRIGHT", 1, -1)
	bg:SetFrameLevel(parent:GetFrameLevel() - 1)
	bg:SetBackdrop(backdrop)
	bg:SetBackdropColor(0, 0, 0, 0.5)
	bg:SetBackdropBorderColor(0, 0, 0, 1)
	return bg
end

function addon:OnInit()
	local onlyBags = function(item) return item.bagID >= 0 and item.bagID <= 4 end
	local onlyKeyring =	function(item) return item.bagID == -2 end
	local onlyBank = function(item) return item.bagID == -1 or item.bagID >= 5 and item.bagID <= 11 end

	local main = container:New("Main", {
		Columns = config["Bags columns"],
		Scale = 1,
		Bags = "backpack+bags",
	})
	main:SetFilter(onlyBags, true)
	main:SetPoint("RIGHT", -100, 0)

	local bank = container:New("Bank", {
		Columns = config["Bank columns"],
		Scale = 1,
		Bags = "bankframe+bank",
	})
	bank:SetFilter(onlyBank, true)
	bank:SetPoint("LEFT", 5, 0)
	bank:Hide()
end

function addon:OnBankOpened()
	self:GetContainer("Bank"):Show()
end

function addon:OnBankClosed()
	self:GetContainer("Bank"):Hide()
end

function button:OnCreate()
	self:SetHighlightTexture("")
	self:SetPushedTexture("")
	self:SetNormalTexture("")
	self:SetSize(config["Button size"], config["Button size"])
	self.bg = CreateBG(self)
	self.Icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
	self.Icon:SetPoint("TOPLEFT")
	self.Icon:SetPoint("BOTTOMRIGHT")
	self.Count:SetPoint("BOTTOMRIGHT", -1, 3)
	self.Count:SetFont(config["Font"], config["Font size"], config["Font style"])
	self:HookScript('OnEnter', function()
		self.oldColor = {self.bg:GetBackdropBorderColor()}
		self.bg:SetBackdropBorderColor(1, 1, 1)
	end)
	self:HookScript('OnLeave', function()
		self.bg:SetBackdropBorderColor(unpack(self.oldColor))
	end)
	_G[self:GetName()..'IconQuestTexture']:SetSize(0.01, 0.01)
end

function button:OnUpdate(item)
	if item.questID or item.isQuestItem then
		self.bg:SetBackdropBorderColor(1, 1, 0, 1)
	elseif item.rarity and item.rarity > 1 then
		local r, g, b = GetItemQualityColor(item.rarity)
		self.bg:SetBackdropBorderColor(r, g, b, 1)
	else
		self.bg:SetBackdropBorderColor(0.4, 0.4, 0.4, 1)
	end
end

function container:OnContentsChanged()
	self:SortButtons("bagSlot")
	local width, height = self:LayoutButtons("grid", self.Settings.Columns, config["Button spacing"], 7, -7)
	self:SetSize(width + 14, height + 34)
end

local function highlightFunction(button, match)
	button:SetAlpha(match and 1 or 0.1)
end

function container:OnCreate(name, settings)
	self.Settings = settings

	self.button = CreateFrame("Button", nil, self)
	self.button:SetPoint("TOPRIGHT", 10, 10)
	self.button:SetSize(20, 20)
	self.button:SetNormalTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Up")
	self.button:SetPushedTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Down")
	self.button:SetHighlightTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Highlight")
	self.button:SetScript("OnClick", function()
		addon:Hide()
	end)

	self:EnableMouse(true)
	self:SetMovable(true)
	self:SetMovable(true)
	self:RegisterForClicks("LeftButton", "RightButton")
    self:SetScript("OnMouseDown", function()
    	self:ClearAllPoints() 
		self:StartMoving() 
    end)
	self:SetScript("OnMouseUp",  self.StopMovingOrSizing)

	self.bg = CreateBG(self)

	self:SetParent(addon)
	self:SetFrameStrata("HIGH")

	settings.Columns = settings.Columns or 14

	local infoFrame = CreateFrame("Button", nil, self)
	infoFrame:SetPoint("BOTTOMLEFT", 7, 0)
	infoFrame:SetPoint("BOTTOMRIGHT", -7, 0)
	infoFrame:SetHeight(25)

	local space = self:SpawnPlugin("TagDisplay", "[space:free/max] free", infoFrame)
	space:SetFont(config["Font"], config["Font size"], config["Font style"])
	space:SetPoint("LEFT", infoFrame, "LEFT")
	space.bags = ns.cargBags:ParseBags(settings.Bags)

	local tagDisplay = self:SpawnPlugin("TagDisplay", "[currencies] [ammo] [money]", infoFrame)
	tagDisplay:SetFont(config["Font"], config["Font size"], config["Font style"])
	tagDisplay:SetPoint("RIGHT", infoFrame, "RIGHT", -7, 0)

	if config["Bag bar"] then
		local bagBar = self:SpawnPlugin("BagBar", settings.Bags)
		local width, height = bagBar:LayoutButtons("grid", 1, 7, 7, -7)
		bagBar.highlightFunction = highlightFunction
		bagBar:SetSize(width + 14, height + 14)
		bagBar.bg = CreateBG(bagBar)
		if (name == "Bank") then
			bagBar:SetPoint("TOPLEFT", self, "TOPRIGHT", 5, 0)
		else
			bagBar:SetPoint("TOPRIGHT", self, "TOPLEFT", -5, 0)
		end
	end

	local search = self:SpawnPlugin("SearchBar", infoFrame)
	search.highlightFunction = highlightFunction
end

function bag:OnCreate()
	self:SetHighlightTexture("")
	self:SetPushedTexture("")
	self:SetNormalTexture("")
	self:SetCheckedTexture("")
	self:SetSize(config["Button size"], config["Button size"])
	self.bg = CreateBG(self)
	self.Icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
	self.Icon:SetPoint("TOPLEFT", 1, -1)
	self.Icon:SetPoint("BOTTOMRIGHT", -1, 1)
	self:HookScript('OnEnter', function()
		self.oldColor = {self.bg:GetBackdropBorderColor()}
		self.bg:SetBackdropBorderColor(1, 1, 1)
	end)
	self:HookScript('OnLeave', function()
		self.bg:SetBackdropBorderColor(unpack(self.oldColor))
		self:OnUpdate()
	end)
end

function bag:OnUpdate()
	if self:GetChecked() then
		self.bg:SetBackdropBorderColor(0, 144, 255)
	else
		self.bg:SetBackdropBorderColor(0, 0, 0)
	end
end
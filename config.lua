UIConfig = {
	ActionBars = {
		button_size = 27,
		spacing = 3,
	},
	DamageMeter = {
		anchor = "TOPLEFT",
		x = 12,
		barheight = 14,
		spacing = 1,
		maxbars = 8,
		width = 150,
		maxfights = 10,
		reportstrings = 10,
		texture = "Interface\\TargetingFrame\\UI-StatusBar",
		border_size = 1,
		font = 'Fonts\\VisitorR.TTF',
		font_size = 10,
		hidetitle = false,
	},
}

local UISetup = {}
local lastVisible = nil
local backdrop = {
	bgFile = [=[Interface\ChatFrame\ChatFrameBackground]=],
	edgeFile = [=[Interface\ChatFrame\ChatFrameBackground]=], edgeSize = 1,
	insets = {top = 0, left = 0, bottom = 0, right = 0},
}

local CreateBG = function(parent)
	local bg = CreateFrame('Frame', nil, parent)
	bg:SetPoint('TOPLEFT', parent, 'TOPLEFT', -1, 1)
	bg:SetPoint('BOTTOMRIGHT', parent, 'BOTTOMRIGHT', 1, -1)
	bg:SetFrameLevel(parent:GetFrameLevel() - 1)
	bg:SetBackdrop(backdrop)
	bg:SetBackdropColor(0, 0, 0, 0.5)
	bg:SetBackdropBorderColor(0, 0, 0, 1)
	return bg
end

local SetValue = function(group, option, value)
	if not UISetup[group] then
		UISetup[group] = {}
	end
	UISetup[group][option] = value
end

local CreateConfigFrame = function()
	local main = CreateFrame("Frame", "UIConfigFrame", UIParent)
	local scroll = CreateFrame("ScrollFrame", "UIConfigScrollFrame", main)--, "UIParentScrollFrameTemplate")
	local groups = CreateFrame("Frame", "UIConfigGroupFrame", main)
	local set = CreateFrame("Button", "UIConfigSetFrame", main)
	local cancel = CreateFrame("Button", "UIConfigCancelFrame", main)

	main:SetSize(800, 600)
	main:SetPoint("CENTER")
	main.bg = CreateBG(main)
	scroll:SetSize(150, 550)
	scroll:SetPoint("BOTTOMLEFT", 12, 12)
	scroll:SetScrollChild(groups)
	scroll.bg = CreateBG(scroll)
	groups:SetAllPoints(scroll)

	set.bg = CreateBG(set)
	set.label = set:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	set.label:SetPoint("CENTER")
	set.label:SetText(ACCEPT)
	set:SetSize(50, 20)
	set:SetPoint("TOPRIGHT", main, "BOTTOMRIGHT", 0, -5)
	set:SetScript("OnClick", function()
		for group, options in pairs(UISetup) do
			for option, value in pairs(options) do
				UIConfig[group][option] = value
			end
		end
		ReloadUI()
	end)
	cancel.bg = CreateBG(cancel)
	cancel.label = cancel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	cancel.label:SetPoint("CENTER")
	cancel.label:SetText(CANCEL)
	cancel:SetSize(50, 20)
	cancel:SetPoint("RIGHT", set, "LEFT", -5, 0)
	cancel:SetScript("OnClick", function()
		wipe(UISetup)
		_G["UIConfigFrame"]:Hide()
	end)

	local offset = 0
	for group, options in pairs(UIConfig) do
		local button = CreateFrame("Button", "UIConfigGroup"..group, groups)
		button:SetSize(148, 20)
		button:SetPoint("TOP", 0, -offset-1)
		local label = button:CreateFontString(nil, "OVERLAY")
		label:SetPoint("CENTER")
		label:SetFont(GameFontNormal:GetFont(), 14)
		label:SetText(group)
		local settings = CreateFrame("Frame", "UIConfigSettings"..group, main)
		settings:SetSize(600, 550)
		settings:SetPoint("BOTTOMRIGHT", -12, 12)
		settings.bg = CreateBG(settings)
		settings:Hide()
		button:SetScript("OnMouseUp", function()
			if lastVisible then
				lastVisible:Hide()
			end
			settings:Show()
			lastVisible = settings
		end)
		offset = offset + 21
		local offsetgroup = 5
		for option, value in pairs(options) do
			if type(value) == "boolean" then
				local check = CreateFrame("CheckButton", "UIConfigSettings"..group..option, settings, "InterfaceOptionsCheckButtonTemplate")
				_G[check:GetName().."Text"]:SetText(option)
				check:SetChecked(value)
				check:SetScript("OnClick", function(self) SetValue(group, option, self:GetChecked() and true or false) end)
				check:SetPoint("TOPLEFT", 5, -(offsetgroup))
			end
			if type(value) == "number" or type(value) == "string" then
				local label = settings:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
				label:SetText(option)
				label:SetWidth(200)
				label:SetHeight(20)
				label:SetJustifyH("LEFT")
				label:SetPoint("TOPLEFT", 5, -(offsetgroup))
				local editbox = CreateFrame("EditBox", nil, settings)
				editbox:SetAutoFocus(false)
				editbox:SetMultiLine(false)
				editbox:SetWidth(300)
				editbox:SetHeight(20)
				editbox:SetMaxLetters(255)
				editbox:SetTextInsets(3, 0, 0, 0)
				editbox:SetFontObject(GameFontHighlight)
				editbox:SetPoint("LEFT", label, "RIGHT", 5, 0)
				editbox:SetText(value)
				editbox:SetBackdrop(backdrop)
				editbox:SetBackdropColor(0, 0, 0, 0)
				editbox:SetBackdropBorderColor(0.2, 0.2, 0.2, 1)
				local okbutton = CreateFrame("Button", nil, settings)
				okbutton:SetHeight(editbox:GetHeight())
				okbutton:SetWidth(55)
				okbutton:SetBackdrop(backdrop)
				okbutton:SetBackdropColor(0, 0, 0, 0)
				okbutton:SetBackdropBorderColor(0.2, 0.2, 0.2, 1)
				okbutton:SetPoint("LEFT", editbox, "RIGHT", 5, 0)
				--okbutton:Hide()
				local oktext = okbutton:CreateFontString(nil, "OVERLAY", "GameFontNormal")
				oktext:SetText(ACCEPT)
				oktext:SetPoint("CENTER")
 
				editbox:SetScript("OnEscapePressed", function(self) okbutton:Hide() self:ClearFocus() self:SetText(value) end)
				editbox:SetScript("OnChar", function(self) okbutton:Show() end)
				if type(value) == "number" then
					editbox:SetScript("OnEnterPressed", function(self) okbutton:Hide() self:ClearFocus() SetValue(group,option,tonumber(self:GetText())) end)
					okbutton:SetScript("OnMouseDown", function(self) editbox:ClearFocus() self:Hide() SetValue(group,option,tonumber(editbox:GetText())) end)
				else
					editbox:SetScript("OnEnterPressed", function(self) okbutton:Hide() self:ClearFocus() SetValue(group,option,tostring(self:GetText())) end)
					okbutton:SetScript("OnMouseDown", function(self) editbox:ClearFocus() self:Hide() SetValue(group,option,tostring(editbox:GetText())) end)
				end
			end
			offsetgroup = offsetgroup + 25
		end
	end
end


SlashCmdList["UICONFIG"] = CreateConfigFrame
SLASH_UICONFIG1 = "/uiconfig"

local addon_name, ns = ...

UIConfig = {}
UISetup = {}

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

local CreateFS = function(frame, fsize, fstyle)
	local fstring = frame:CreateFontString(nil, 'OVERLAY', 'GameFontHighlight')
	fstring:SetFont('Fonts\\VisitorR.TTF', fsize, fstyle)
	fstring:SetShadowColor(0, 0, 0, 1)
	fstring:SetShadowOffset(0, 0)
	return fstring
end

local SetValue = function(group, option, value)
	if not UISetup[group] then
		UISetup[group] = {}
	end
	UISetup[group][option] = value
end

local CreateConfigFrame = function()
	if _G["UIConfigFrame"] then
		_G["UIConfigFrame"]:Show()
		return
	end

	local main = CreateFrame("Frame", "UIConfigFrame", UIParent)
	local scroll = CreateFrame("ScrollFrame", "UIConfigScrollFrame", main)
	local groups = CreateFrame("Frame", "UIConfigGroupFrame", main)
	local set = CreateFrame("Button", "UIConfigSetFrame", main)
	local cancel = CreateFrame("Button", "UIConfigCancelFrame", main)
	local title = CreateFrame("Frame", "UIConfigTitleFrame", main)

	main:SetSize(640, 480)
	main:SetPoint("CENTER")
	main.bg = CreateBG(main)
	scroll:SetSize(150, 420)
	scroll:SetPoint("BOTTOMLEFT", 12, 12)
	scroll:SetScrollChild(groups)
	scroll.bg = CreateBG(scroll)
	groups:SetAllPoints(scroll)
	title:SetPoint("TOPLEFT", 12, -12)
	title:SetPoint("BOTTOMRIGHT", scroll, "TOPRIGHT", 0, 12)
	title.bg = CreateBG(title)
	title.label = CreateFS(title, 20, 'OUTLINEMONOCHROME')
	title.label:SetPoint("CENTER")
	title.label:SetText("ALLEZ UI")

	set.bg = CreateBG(set)
	set.label = set:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	set.label:SetPoint("CENTER")
	set.label:SetText(ACCEPT)
	set:SetSize(50, 20)
	set:SetPoint("TOPRIGHT", main, "BOTTOMRIGHT", 0, -5)
	set:SetScript("OnClick", function()
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
		settings:SetPoint("BOTTOMRIGHT", -12, 12)
		settings:SetPoint("TOPLEFT", scroll, "TOPRIGHT", 20, 0)
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
				label:SetWidth(140)
				label:SetHeight(20)
				label:SetJustifyH("LEFT")
				label:SetPoint("TOPLEFT", 5, -(offsetgroup))
				local editbox = CreateFrame("EditBox", nil, settings)
				editbox:SetAutoFocus(false)
				editbox:SetMultiLine(false)
				editbox:SetWidth(200)
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

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:SetScript("OnEvent", function(self, event, addon)
	self:UnregisterEvent(event)
	if UISetup then
		for group, options in pairs(UISetup) do
			for option, value in pairs(options) do
				if UIConfig and UIConfig[group] then
					UIConfig[group][option] = value
				end
			end
		end
	end
end)

SlashCmdList["UICONFIG"] = CreateConfigFrame
SLASH_UICONFIG1 = "/uiconfig"
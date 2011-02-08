
local addon_name, ns = ...

UIConfig = {}
UISetup = {}

local lastVisible = nil

local backdrop = {
	bgFile = [=[Interface\ChatFrame\ChatFrameBackground]=],
	edgeFile = [=[Interface\ChatFrame\ChatFrameBackground]=], edgeSize = 1,
	insets = {top = 0, left = 0, bottom = 0, right = 0},
}

local CreateBG = CreateBG or function(parent)
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
	local reset = CreateFrame("Button", "UIConfigResetFrame", main)
	local title = CreateFrame("Frame", "UIConfigTitleFrame", main)

	main:SetSize(640, 480)
	main:SetPoint("CENTER")
	main:SetFrameStrata("HIGH")
	main:SetToplevel(true)
	main.bg = CreateBG(main)
	scroll:SetSize(150, 390)
	scroll:SetPoint("BOTTOMLEFT", 12, 42)
	scroll:SetScrollChild(groups)
	scroll.bg = CreateBG(scroll)
	groups:SetAllPoints(scroll)
	title:SetPoint("TOPLEFT", 12, -12)
	title:SetPoint("BOTTOMRIGHT", scroll, "TOPRIGHT", 0, 12)
	title.bg = CreateBG(title)
	title.label = CreateFS(title, 20, 'OUTLINEMONOCHROME')
	title.label:SetPoint("CENTER")
	title.label:SetText("Allez UI")

	set.bg = CreateBG(set)
	set.label = set:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	set.label:SetPoint("CENTER")
	set.label:SetText(ACCEPT)
	set:SetSize(50, 20)
	set:SetPoint("BOTTOMRIGHT", -12, 12)
	set:SetScript("OnClick", function()
		ReloadUI()
	end)
	cancel.bg = CreateBG(cancel)
	cancel.label = cancel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	cancel.label:SetPoint("CENTER")
	cancel.label:SetText(CANCEL)
	cancel:SetSize(50, 20)
	cancel:SetPoint("RIGHT", set, "LEFT", -12, 0)
	cancel:SetScript("OnClick", function()
		_G["UIConfigFrame"]:Hide()
	end)
	reset.bg = CreateBG(reset)
	reset.label = reset:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	reset.label:SetPoint("CENTER")
	reset.label:SetText(RESET)
	reset:SetSize(50, 20)
	reset:SetPoint("RIGHT", cancel, "LEFT", -12, 0)
	reset:SetScript("OnClick", function()
		wipe(UISetup)
		ReloadUI()
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
		
		local scrollsettings = CreateFrame("ScrollFrame", "UIConfigScrollSettings"..group, main, "UIPanelScrollFrameTemplate")
		scrollsettings:SetPoint("BOTTOMRIGHT", -12, 42)
		scrollsettings:SetPoint("TOPLEFT", scroll, "TOPRIGHT", 20, 0)
		local settings = CreateFrame("Frame", "UIConfigSettings"..group, scrollsettings)
		settings:SetPoint("TOPLEFT")
		settings:SetSize(scrollsettings:GetWidth(), 100)
		scrollsettings:SetScrollChild(settings)
		scrollsettings:Hide()
		scrollsettings.ScrollBar:SetPoint("TOPRIGHT", -22, -16)
		scrollsettings.ScrollBar:SetPoint("BOTTOMRIGHT", -22, 16)
		scrollsettings.bg = CreateBG(scrollsettings)
		button:SetScript("OnMouseUp", function()
			if lastVisible then
				lastVisible:Hide()
			end
			scrollsettings:Show()
			lastVisible = scrollsettings
		end)
		offset = offset + 21
		local offsetgroup = 5
		for option, value in pairs(options) do
			if type(value) == "boolean" then
				local check = CreateFrame("CheckButton", "UIConfigSettings"..group..option, settings, "InterfaceOptionsCheckButtonTemplate")
				_G[check:GetName().."Text"]:SetText(option)
				check:SetChecked(value)
				check:SetScript("OnClick", function(self)
					SetValue(group, option, self:GetChecked() and true or false)
				end)
				check:SetPoint("TOPLEFT", 5, -offsetgroup)
			end
			if type(value) == "number" or type(value) == "string" then
				local label = settings:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
				label:SetText(option)
				label:SetWidth(140)
				label:SetHeight(20)
				label:SetJustifyH("LEFT")
				label:SetPoint("TOPLEFT", 5, -offsetgroup)
				local editbox = CreateFrame("EditBox", nil, settings)
				editbox:SetAutoFocus(false)
				editbox:SetMultiLine(false)
				editbox:SetWidth(250)
				editbox:SetHeight(20)
				editbox:SetMaxLetters(255)
				editbox:SetTextInsets(3, 0, 0, 0)
				editbox:SetFontObject(GameFontHighlight)
				editbox:SetPoint("LEFT", label, "RIGHT", 5, 0)
				editbox:SetText(value)
				editbox:SetBackdrop(backdrop)
				editbox:SetBackdropColor(0, 0, 0, 0)
				editbox:SetBackdropBorderColor(0.2, 0.2, 0.2, 1)
				editbox:SetScript("OnChar", function(self)
					if type(value) == "number" then
						SetValue(group,option,tonumber(self:GetText()))
					else
						SetValue(group,option,tostring(self:GetText()))
					end
				end)
			end
			if type(value) == "table" then
				local label = settings:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
				label:SetText(option)
				label:SetWidth(140)
				label:SetHeight(20)
				label:SetJustifyH("LEFT")
				label:SetPoint("TOPLEFT", 5, -offsetgroup)
				local button = CreateFrame("Button", nil, settings)
				button:SetSize(50, 20)
				button:SetPoint("LEFT", label, "RIGHT", 5, 0)
				button.bg = CreateBG(button)
				button.bg:SetBackdropBorderColor(unpack(value))
				button.label = button:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
				button.label:SetText(COLOR)
				button.label:SetPoint("CENTER")
				local r, g, b, a = unpack(value)
				button:SetScript("OnClick", function(self) 
					if ColorPickerFrame:IsShown() then return end
					
					local function myColorCallback(restore)
						local newR, newG, newB, newA
						if restore then
							newR, newG, newB, newA = unpack(restore)
						else
							newA, newR, newG, newB = OpacitySliderFrame:GetValue(), ColorPickerFrame:GetColorRGB()
						end
						r, g, b, a = newR, newG, newB, newA
						SetValue(group,option,{r, g, b, a})
						self.bg:SetBackdropBorderColor(r, g, b, a)
					end
					
					ColorPickerFrame:SetColorRGB(r,g,b)
					ColorPickerFrame.hasOpacity, ColorPickerFrame.opacity = (a ~= nil), a
					ColorPickerFrame.previousValues = {r,g,b,a}
					ColorPickerFrame.func, ColorPickerFrame.opacityFunc, ColorPickerFrame.cancelFunc = myColorCallback, myColorCallback, myColorCallback
					ColorPickerFrame:Hide()
					ColorPickerFrame:Show()
				end)
			end
			offsetgroup = offsetgroup + 25
		end
	end
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("VARIABLES_LOADED")
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
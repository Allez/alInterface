
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

local CreateCheckBox = function(parent)
	local widget = CreateFrame("Button", nil, parent)
	widget:SetSize(200, 20)
	widget.check = CreateFrame("CheckButton", nil, widget, "InterfaceOptionsCheckButtonTemplate")
	widget.check:SetPoint("LEFT")
	widget.label = widget:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	widget.label:SetJustifyH("LEFT")
	widget.label:SetPoint("LEFT", widget.check, "RIGHT", 3, 0)
	widget.label:SetPoint("RIGHT", 0, 0)
	widget.SetChecked = function(checked)
		widget.check:SetChecked(checked)
	end
	widget.SetCallback = function(func)
		widget.Callback = func
	end
	widget:SetScript("OnClick", function(self)
		self.Callback(self.check:GetChecked() and true or false)
	end)
end

local CreateColorPicker = function(parent)
	local widget = CreateFrame("Button", nil, parent)
	widget:SetSize(200, 20)
	widget.color = widget:CreateTexture(nil, "OVERLAY")
	widget.color:SetSize(20, 20)
	widget.color:SetTexture("Interface\\ChatFrame\\ChatFrameColorSwatch")
	widget.color:SetPoint("LEFT")
	widget.label = widget:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	widget.label:SetJustifyH("LEFT")
	widget.label:SetPoint("RIGHT", 0, 0)
	widget.SetColor = function(...)
		widget.color:SetVertexColor(...)
		widget.value = {...}
	end
	widget.SetCallback = function(func)
		widget.Callback = func
	end
	widget:SetScript("OnClick", function(self) 
		if ColorPickerFrame:IsShown() then return end
		local r, g, b, a = unpack(self.value)

		local myColorCallback = function(restore)
			local newR, newG, newB, newA
			if restore then
				newR, newG, newB, newA = unpack(restore)
			else
				newA, newR, newG, newB = OpacitySliderFrame:GetValue(), ColorPickerFrame:GetColorRGB()
			end
			self.Callback(newR, newG, newB, newA)
			self.color:SetVertexColor(newR, newG, newB, newA)
		end

		ColorPickerFrame.func, ColorPickerFrame.opacityFunc, ColorPickerFrame.cancelFunc = 
			myColorCallback, myColorCallback, myColorCallback
		ColorPickerFrame:SetColorRGB(r, g, b)
		ColorPickerFrame.hasOpacity, ColorPickerFrame.opacity = (a ~= nil), a
		ColorPickerFrame.previousValues = {r, g, b, a}
		ColorPickerFrame:Hide()
		ColorPickerFrame:Show()
	end)
end

local CreateEditBox = function(parent)
	local widget = CreateFrame("Frame", nil, parent)
	widget:SetSize(200, 40)
	widget.editbox = CreateFrame("EditBox", nil, widget)
	widget.editbox:SetAutoFocus(false)
	widget.editbox:SetMultiLine(false)
	widget.editbox:SetHeight(20)
	widget.editbox:SetMaxLetters(255)
	widget.editbox:SetTextInsets(3, 0, 0, 0)
	widget.editbox:SetFontObject(GameFontHighlight)
	widget.editbox:SetPoint("BOTTOMLEFT", 0, 0)
	widget.editbox:SetPoint("BOTTOMRIGHT", 0, 0)
	widget.editbox:SetText(value)
	widget.editbox:SetBackdrop(backdrop)
	widget.editbox:SetBackdropColor(0, 0, 0, 0)
	widget.editbox:SetBackdropBorderColor(0.2, 0.2, 0.2, 1)
	widget.label = widget:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	widget.label:SetHeight(20)
	widget.label:SetJustifyH("LEFT")
	widget.label:SetPoint("TOPLEFT", 3, 0)
	widget.SetCallback = function(func)
		widget.Callback = func
	end
	widget.editbox:SetScript("OnTextChanged", function(self)
		widget:Callback(self:GetText())
	end)
end

local CreateSlider = function(parent)
	local widget = CreateFrame("Frame", nil, parent)
	widget:SetSize(200, 40)
	widget.label = widget:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	widget.label:SetHeight(20)
	widget.label:SetJustifyH("CENTER")
	widget.label:SetPoint("TOP")
	widget.slider = CreateFrame("Slider", nil, widget)
	widget.slider:SetOrientation("HORIZONTAL")
	widget.slider:SetHeight(15)
	widget.slider:SetHitRectInsets(0, 0, -10, 0)
	widget.slider:SetThumbTexture("Interface\\Buttons\\UI-SliderBar-Button-Horizontal")
	widget.slider:SetPoint("TOP", widget.label, "BOTTOM")
	widget.slider:SetPoint("LEFT", 3, 0)
	widget.slider:SetPoint("RIGHT", -3, 0)
	widget.slider:SetValue(0)
	widget.left = widget:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	widget.left:SetPoint("TOPLEFT")
	widget.right = widget:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	widget.right:SetPoint("TOPRIGHT")
	widget.editbox = CreateFrame("EditBox", nil, widget)
	widget.editbox:SetAutoFocus(false)
	widget.editbox:SetMultiLine(false)
	widget.editbox:SetSize(50, 14)
	widget.editbox:SetFontObject(GameFontHighlightSmall)
	widget.editbox:SetPoint("TOP", widget.slider, "BOTTOM")
	widget.editbox:SetJustifyH("CENTER")
	widget.editbox:EnableMouse(true)
	widget.editbox:SetBackdrop(backdrop)
	widget.editbox:SetBackdropColor(0, 0, 0, 0)
	widget.editbox:SetBackdropBorderColor(0.2, 0.2, 0.2, 1)
	widget.SetValue = function(value)
		widget.slider:SetValue(value)
	end
	widget.SetSliderValues = function(...)
		widget.slider:SetSliderValues(...)
	end
	widget.SetCallback = function(func)
		widget.Callback = func
	end
	widget.slider:SetScript("OnValueChanged", function(self)
		widget.editbox:SetText(self:GetValue())
	end)
	widget.editbox:SetScript("OnTextChanged", function(self)
		widget:Callback(self:GetText())
	end)
end

local PanelLayout = function(frame)
	local width = frame:GetWidth()
	local height = frame:GetHeight()
	local totalwidth = 0
	local row, col = 1, 1
	for i, widget in pairs(frame.widgets) do
		if i == 1 then
			widget:SetPoint("TOPLEFT", 10, -20)
		else
			if totalwidth + widget:GetWidth() < width then
				widget:SetPoint("LEFT", frame.widgets[i-1], "RIGHT", 10, 0)
			else
				widget:SetPoint("TOPLEFT", 10, -20*i)
				totalwidth = 0
			end
		end
		totalwidth = totalwidth + widget:GetWidth()
	end
end

local CreateOptionsPanel = function(button)
	local frame = CreateFrame("ScrollFrame", "$parentScroll", button, "UIPanelScrollFrameTemplate")
	frame:EnableMouseWheel(true)
	frame.ScrollBar:ClearAllPoints()
	frame.ScrollBar:SetPoint("TOPRIGHT", -3, -16)
	frame.ScrollBar:SetPoint("BOTTOMRIGHT", -3, 16)
	frame.ScrollBar:SetMinMaxValues(0, 1000)
	frame.ScrollBar:SetValueStep(1)
	frame.ScrollBar:SetValue(0)
	frame.content = CreateFrame("Frame", "$parentContent", frame)
	frame.content:SetPoint("TOPLEFT")
	frame.content:SetPoint("TOPRIGHT")
	frame.content:SetHeight(100)
	frame:SetScrollChild(frame.content)
	return frame
end

local ShowPanel = function(self)
	if lastVisible then
		lastVisible:Hide()
	end
	self.panel:Show()
	lastVisible = self.panel
end

local CreateConfigFrame = function()
	if UIConfigFrame then
		UIConfigFrame:Show()
	end

	local offset = 0
	for element, settings in pairs(UIConfig) do
		local button = CreateFrame("Button", "$parent"..element, UIConfigFrameElements, "UIConfigGroupButtonTemplate")
		button:SetPoint("TOP", 0, -offset-1)
		button.label:SetJustifyH("LEFT")
		button.label:SetText(element)
		
		button.panel = CreateOptionsPanel(button)
		button.panel:SetPoint("BOTTOMRIGHT", UIConfigFrame, "BOTTOMRIGHT", -12, 42)
		button.panel:SetPoint("TOPLEFT", UIConfigFrameElements, "TOPRIGHT", 20, 0)
		button:SetScript("OnClick", ShowPanel)
		CreateBG(button.panel)
		offset = offset + button:GetHeight()
		for group, options in pairs(settings) do
			local panel = CreateFrame("Frame", element..group, button.panel.content)
			panel:SetSize(settings:GetWidth(), 100)
			panel:SetPoint("TOP", 0, -subgroupoffset-25)
			CreateBG(panel)
			panel.title = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
			panel.title:SetPoint("TOPLEFT", 0, 20)
			panel.title:SetText(subgroup)
			panel.widgets = {}
			for option, value in pairs(options) do
				if type(value) == "boolean" then
					local button = CreateCheckBox(panel)
					button.label:SetText(option)
					button:SetChecked(value)
					button:SetCallback(function(checked)
						SetValue(group, option, checked)
					end)
					tinsert(panel.widgets, button)
				end
				if type(value) == "number" or type(value) == "string" then
					local editbox = CreateEditBox(panel)
					editbox.label:SetText(option)
					editbox:SetCallback(function(value)
						if type(value) == "number" then
							SetValue(group,option,tonumber(value))
						else
							SetValue(group,option,tostring(value))
						end
					end)
					tinsert(panel.widgets, editbox)
				end
				if type(value) == "table" then
					local button = CreateColorPicker(panel)
					button.label:SetText(option)
					button:SetColor(unpack(value))
					button:SetCallback(function(...)
						local color = {...}
						SetValue(group, option, color)
					end)
					tinsert(panel.widgets, button)
				end
			end
			PanelLayout(panel)
		end
	end
end

local toggle = CreateFrame("Button", "C", UIParent)
toggle:SetSize(18, 18)
toggle:SetNormalTexture("Interface\\Addons\\alInterface\\media\\icon-config")
toggle:SetPoint("TOPRIGHT", Minimap, "BOTTOMRIGHT", 0, -7)
toggle:SetFrameStrata("LOW")
toggle:SetFrameLevel(0)
toggle.bg = CreateBG(toggle)
toggle:SetScript("OnClick", function(self)
	CreateConfigFrame()
end)
tinsert(UIMovableFrames, toggle)

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
local addon_name, ns = ...

local realm = GetCVar("realmName")
local name  = UnitName("player")

UIConfigGUI = {}
UIConfig = {}
UISetup5 = {}
UISetupAll = {}
UIProfiles = {}

local lastVisible = nil
local created = false

local SetValue = function(element, group, option, value)
	if value == UIConfig[element][group][option] then return end
	if not UISetup5[element] then
		UISetup5[element] = {}
	end
	if not UISetup5[element][group] then
		UISetup5[element][group] = {}
	end
	UISetup5[element][group][option] = value
end

UISetValue = SetValue

local CreateCheckBox = function(parent)
	local widget = CreateFrame("Button", nil, parent)
	widget:SetSize(190, 20)
	widget.check = CreateFrame("CheckButton", nil, widget, "InterfaceOptionsCheckButtonTemplate")
	widget.check:SetPoint("LEFT")
	widget.label = widget:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	widget.label:SetJustifyH("LEFT")
	widget.label:SetPoint("LEFT", widget.check, "RIGHT", 3, 0)
	widget.label:SetPoint("RIGHT", 0, 0)
	widget.SetChecked = function(self, checked)
		widget.check:SetChecked(checked)
	end
	widget.SetCallback = function(self, func)
		widget.Callback = func
	end
	widget.check:SetScript("OnClick", function(self)
		widget.Callback(self:GetChecked() and true or false)
	end)
	return widget
end

local CreateColorPicker = function(parent)
	local widget = CreateFrame("Button", nil, parent)
	widget:SetSize(190, 20)
	widget.color = widget:CreateTexture(nil, "OVERLAY")
	widget.color:SetSize(20, 20)
	widget.color:SetTexture("Interface\\ChatFrame\\ChatFrameColorSwatch")
	widget.color:SetPoint("LEFT")
	widget.label = widget:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	widget.label:SetJustifyH("LEFT")
	widget.label:SetPoint("RIGHT", 0, 0)
	widget.label:SetPoint("LEFT", widget.color, "RIGHT", 5, 0)
	widget.SetColor = function(self, ...)
		widget.color:SetVertexColor(...)
		widget.value = {...}
	end
	widget.SetCallback = function(self, func)
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
	return widget
end

local dropcount = 1
local CreateDropDown = function(parent)
	local widget = CreateFrame("Frame", nil, parent)
	widget:SetSize(190, 50)
	widget.label = widget:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	widget.label:SetHeight(20)
	widget.label:SetJustifyH("LEFT")
	widget.label:SetPoint("TOPLEFT", 3, 0)
	widget.button = CreateFrame("Button", "Dropdown"..dropcount, widget, "UIDropDownMenuTemplate")
	widget.button:ClearAllPoints()
	widget.button:SetPoint("TOPLEFT", widget.label, "BOTTOMLEFT", -20, 0)
	local initialize = function(self, level)
		local info = UIDropDownMenu_CreateInfo()
		for i, v in pairs(widget.items) do
			info = UIDropDownMenu_CreateInfo()
			info.text = v
			info.value = v
			info.func = function(self)
				UIDropDownMenu_SetSelectedID(widget.button, self:GetID())
				widget:Callback(v)
			end
			UIDropDownMenu_AddButton(info, level)
		end
	end
	widget.SetItems = function(self, items)
		widget.items = items
		UIDropDownMenu_Initialize(widget.button, initialize)
		UIDropDownMenu_SetWidth(widget.button, widget:GetWidth()-20)
		UIDropDownMenu_SetButtonWidth(widget.button, widget:GetWidth()-20)
		UIDropDownMenu_JustifyText(widget.button, "LEFT")
	end
	widget.SetValue = function(self, value)
		for i, v in pairs(self.items) do
			if v == value then
				UIDropDownMenu_SetSelectedID(self.button, i)
			end
		end
	end
	widget.SetCallback = function(self, func)
		widget.Callback = func
	end
	dropcount = dropcount + 1
	return widget
end

local CreateEditBox = function(parent)
	local widget = CreateFrame("Frame", nil, parent)
	widget:SetSize(190, 50)
	widget.editbox = CreateFrame("EditBox", nil, widget)
	widget.editbox:SetAutoFocus(false)
	widget.editbox:SetMultiLine(false)
	widget.editbox:SetHeight(20)
	widget.editbox:SetMaxLetters(255)
	widget.editbox:SetTextInsets(3, 0, 0, 0)
	widget.editbox:SetFontObject(GameFontHighlight)
	widget.editbox:SetPoint("BOTTOMLEFT", 0, 0)
	widget.editbox:SetPoint("BOTTOMRIGHT", 0, 0)
	widget.editbox:SetBackdrop({
		edgeFile = [=[Interface\ChatFrame\ChatFrameBackground]=],
		edgeSize = 1,
		insets = { left = 1, right = 1, top = 1, bottom = 1}
	})
	widget.editbox:SetBackdropColor(0, 0, 0, 0)
	widget.editbox:SetBackdropBorderColor(0.2, 0.2, 0.2, 1)
	widget.label = widget:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	widget.label:SetHeight(20)
	widget.label:SetJustifyH("LEFT")
	widget.label:SetPoint("TOPLEFT", 3, 0)
	widget.SetCallback = function(self, func)
		widget.editbox:SetScript("OnTextChanged", function(self)
			func(self:GetText())
		end)
	end
	return widget
end

local CreateSlider = function(parent)
	local widget = CreateFrame("Frame", nil, parent)
	widget:SetSize(190, 50)
	widget.label = widget:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	widget.label:SetHeight(20)
	widget.label:SetJustifyH("CENTER")
	widget.label:SetPoint("TOP")
	widget.slider = CreateFrame("Slider", nil, widget)
	widget.slider:SetOrientation("HORIZONTAL")
	widget.slider:SetHeight(15)
	widget.slider:SetBackdrop({
		bgFile = "Interface\\Buttons\\UI-SliderBar-Background",
		edgeFile = "Interface\\Buttons\\UI-SliderBar-Border",
		tile = true, tileSize = 8, edgeSize = 8,
		insets = { left = 3, right = 3, top = 6, bottom = 6 }
	})
	widget.slider:SetThumbTexture("Interface\\Buttons\\UI-SliderBar-Button-Horizontal")
	widget.slider:SetPoint("TOP", widget.label, "BOTTOM")
	widget.slider:SetPoint("LEFT", 3, 0)
	widget.slider:SetPoint("RIGHT", -3, 0)
	widget.slider:SetValue(0)
	widget.left = widget:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	widget.left:SetPoint("TOPLEFT", 0, -10)
	widget.right = widget:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	widget.right:SetPoint("TOPRIGHT", 0, -10)
	widget.editbox = CreateFrame("EditBox", nil, widget)
	widget.editbox:SetAutoFocus(false)
	widget.editbox:SetMultiLine(false)
	widget.editbox:SetSize(50, 14)
	widget.editbox:SetFontObject(GameFontHighlightSmall)
	widget.editbox:SetPoint("TOP", widget.slider, "BOTTOM")
	widget.editbox:SetJustifyH("CENTER")
	widget.editbox:EnableMouse(true)
	widget.editbox:SetBackdrop({
		edgeFile = [=[Interface\ChatFrame\ChatFrameBackground]=],
		edgeSize = 1,
		insets = { left = 1, right = 1, top = 1, bottom = 1}
	})
	widget.editbox:SetBackdropColor(0, 0, 0, 0)
	widget.editbox:SetBackdropBorderColor(0.2, 0.2, 0.2, 1)
	widget.SetValue = function(self, value)
		widget.slider:SetValue(value)
	end
	widget.SetSliderValues = function(self, minv, maxv, step)
		widget.slider:SetMinMaxValues(minv, maxv)
		widget.slider:SetValueStep(step)
		widget.left:SetText(minv)
		widget.right:SetText(maxv)
	end
	widget.SetCallback = function(self, func)
		widget.editbox:SetScript("OnTextChanged", function(self)
			func(self:GetText())
		end)
	end
	widget.slider:SetScript("OnValueChanged", function(self)
		widget.editbox:SetText(self:GetValue())
	end)
	return widget
end

local PanelLayout = function(frame)
	local width = frame:GetWidth()
	local height = frame:GetHeight()
	local totalwidth = 0
	local totalheight = 0
	local row = 0
	local first
	local offset = 0
	for i, widget in ipairs(frame.widgets) do
		if i == 1 then
			widget:SetPoint("TOPLEFT", 10, -5)
			row = widget:GetHeight()
			offset = row/2
			first = widget
		else
			if totalwidth + widget:GetWidth() < width then
				widget:SetPoint("BOTTOMLEFT", frame.widgets[i-1], "BOTTOMRIGHT", 10, 0)
				row = math.max(row, widget:GetHeight())
				offset = math.max(offset, row/2)
			else
				widget:SetPoint("TOPLEFT", frame.widgets[i-2], "BOTTOMLEFT", 0, -10)
				--widget:SetPoint("TOPLEFT", 10, -totalheight-first:GetHeight()-offset)
				totalheight = totalheight + row + 10
				first = widget
				row = widget:GetHeight()
				offset = row/2
				totalwidth = 0
			end
		end
		totalwidth = totalwidth + widget:GetWidth()
	end
	totalheight = totalheight + row + 10
	frame:SetHeight(totalheight)
end

local CreateOptionsPanel = function(button)
	local frame = CreateFrame("ScrollFrame", "$parentScroll", button, "UIPanelScrollFrameTemplate")
	frame:EnableMouseWheel(true)
	frame.ScrollBar:ClearAllPoints()
	frame.ScrollBar:SetPoint("TOPRIGHT", -3, -16)
	frame.ScrollBar:SetPoint("BOTTOMRIGHT", -3, 16)
	frame.ScrollBar:SetMinMaxValues(0, 1000)
	frame.ScrollBar:SetValueStep(1)
	frame.ScrollBar:SetValue(1)
	frame.content = CreateFrame("Frame", "$parentContent", frame)
	frame.content:SetPoint("TOPLEFT")
	frame.content:SetPoint("TOPRIGHT")
	frame.content:SetWidth(430)
	frame.content:SetHeight(100)
	frame:SetScrollChild(frame.content)
	frame:Hide()
	return frame
end

local ShowPanel = function(self)
	if lastVisible then
		lastVisible.panel:Hide()
		lastVisible:UnlockHighlight()
	end
	self.panel:Show()
	self:LockHighlight()
	lastVisible = self
end



UIConfigFrame_Create = function(self)
	if created then
		UIConfigFrame:Show()
		return
	end
	local offset = 0
	for element, settings in pairs(UIConfigGUI) do
		local button = CreateFrame("Button", "$parent"..element, UIConfigFrameElements, "UIConfigGroupButtonTemplate")
		button:SetPoint("TOP", 0, -offset-1)
		button.label:SetText(L[element] or element)
		button.panel = CreateOptionsPanel(button)
		button.panel:SetPoint("BOTTOMRIGHT", UIConfigFrame, "BOTTOMRIGHT", -12, 42)
		button.panel:SetPoint("TOPLEFT", UIConfigFrameElements, "TOPRIGHT", 20, 0)
		button:GetHighlightTexture():SetVertexColor(0.3, 0.3, 0.79)
		button:HookScript("OnClick", ShowPanel)
		CreateBG(button.panel)
		offset = offset + button:GetHeight()
		button.panel.groups = {}
		for group, options in pairs(settings) do
			local panel = CreateFrame("Frame", element..group, button.panel.content)
			panel:SetSize(410, 100)
			tinsert(button.panel.groups, panel)
			CreateBG(panel)
			panel.title = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
			panel.title:SetPoint("BOTTOMLEFT", panel, "TOPLEFT", 0, 5)
			panel.title:SetText(L[group] or group)
			panel.widgets = {}
			for option, value in pairs(options) do
				if type(value.value) == "boolean" then
					local button = CreateCheckBox(panel)
					button.label:SetText(L[option] or option)
					button:SetChecked(value.value)
					button:SetCallback(function(checked)
						SetValue(element, group, option, checked)
					end)
					panel.widgets[value.order] = button
				elseif type(value.value) == "table" then
					local button = CreateColorPicker(panel)
					button.label:SetText(L[option] or option)
					button:SetColor(unpack(value.value))
					button:SetCallback(function(...)
						local color = {...}
						SetValue(element, group, option, color)
					end)
					panel.widgets[value.order] = button
				elseif value.type == "select" then
					local button = CreateDropDown(panel)
					button.label:SetText(L[option] or option)
					button:SetItems(value.select)
					button:SetValue(value.value)
					button:SetCallback(function(self, val)
						SetValue(element, group, option, val)
					end)
					panel.widgets[value.order] = button
				elseif value.type == "range" then
					local slider = CreateSlider(panel)
					slider.label:SetText(L[option] or option)
					slider:SetSliderValues(value.min, value.max, value.step or 1)
					slider:SetValue(value.value)
					slider:SetCallback(function(val)
						SetValue(element, group, option, tonumber(val))
					end)
					panel.widgets[value.order] = slider
				elseif type(value.value) == "string" then
					local editbox = CreateEditBox(panel)
					editbox.label:SetText(L[option] or option)
					editbox.editbox:SetText(value.value)
					editbox:SetCallback(function(val)
						if type(value) == "number" then
							SetValue(element, group, option,tonumber(val))
						else
							SetValue(element, group, option,tostring(val))
						end
					end)
					panel.widgets[value.order] = editbox
				end
			end
			PanelLayout(panel)
		end
		local contHeight = 0
		for i, v in pairs(button.panel.groups) do
			if i == 1 then
				v:SetPoint("TOP", 0, -30)
			else
				v:SetPoint("TOP", button.panel.groups[i-1], "BOTTOM", 0, -30)
			end
			contHeight = contHeight + v:GetHeight() + 30
		end
		button.panel.content:SetHeight(contHeight)
	end
	created = true
	UIConfigFrame:Show()
end

local toggle = CreateFrame("Button", "C", UIParent)
toggle:SetSize(18, 18)
toggle:SetNormalTexture("Interface\\Addons\\alInterface\\media\\icon-config")
toggle:SetPoint("TOPRIGHT", Minimap, "BOTTOMRIGHT", 0, -7)
toggle:SetFrameStrata("LOW")
toggle:SetFrameLevel(0)
toggle.bg = CreateBG(toggle)
toggle:SetScript("OnClick", function(self)
	UIConfigFrame_Create()
end)
tinsert(UIMovableFrames, toggle)

local frame = CreateFrame("Frame")
frame:RegisterEvent("VARIABLES_LOADED")
frame:RegisterEvent("PLAYER_REGEN_DISABLED")
frame:SetScript("OnEvent", function(self, event)
	if event == "VARIABLES_LOADED" then
		for element, settings in pairs(UIConfigGUI) do
			for group, options in pairs(settings) do
				UIConfig[element][group] = {}
				for option, value in pairs(options) do
					UIConfig[element][group][option] = value.value
				end
			end
		end
		for element, settings in pairs(UISetup5) do
			for group, options in pairs(settings) do
				for option, value in pairs(options) do
					if UIConfig and UIConfig[element][group] then
						UIConfig[element][group][option] = value
						UIConfigGUI[element][group][option].value = value
					end
				end
			end
		end
	elseif event == "PLAYER_REGEN_DISABLED" then
		print(ERR_NOT_IN_COMBAT)
		UIConfigFrame:Hide()
	end
end)

SlashCmdList["UICONFIG"] = function()
	UIConfigFrame_Create()
end
SLASH_UICONFIG1 = "/uiconfig"
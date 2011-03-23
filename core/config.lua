
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
				widget:SetPoint("TOPLEFT", frame.widgets[i-1], "TOPRIGHT", 10, 0)
			else
				widget:SetPoint("TOPLEFT", 10, -20*i)
			end
		end
		totalwidth = totalwidth + widget:GetWidth()
	end
end

local CreateConfigFrame = function()
	if _G["UIConfigFrame"] then
		_G["UIConfigFrame"]:Show()
		return
	end

	local offset = 0
	for group, subgroups in pairs(UIConfig) do
		local button = CreateFrame("Button", "UIConfigGroup"..group, groups)
		button:SetSize(148, 20)
		button:SetPoint("TOP", 0, -offset-1)
		local label = button:CreateFontString(nil, "OVERLAY")
		label:SetPoint("CENTER")
		label:SetFont(GameFontNormal:GetFont(), 14)
		label:SetText(group)
		
		local scrollsettings = CreateFrame("ScrollFrame", "UIConfigScroll"..group, main, "UIPanelScrollFrameTemplate")
		scrollsettings:SetPoint("BOTTOMRIGHT", -12, 42)
		scrollsettings:SetPoint("TOPLEFT", groups, "TOPRIGHT", 20, 0)
		scrollsettings.bg = CreateBG(scrollsettings)
		local settings = CreateFrame("Frame", "UIConfigSettings"..group, scrollsettings)
		settings:SetPoint("TOPLEFT")
		settings:SetSize(scrollsettings:GetWidth(), 100)
		scrollsettings:SetScrollChild(settings)
		scrollsettings:Hide()
		scrollsettings.ScrollBar:SetPoint("TOPRIGHT", -22, -16)
		scrollsettings.ScrollBar:SetPoint("BOTTOMRIGHT", -22, 16)
		button:SetScript("OnMouseUp", function()
			if lastVisible then
				lastVisible:Hide()
			end
			scrollsettings:Show()
			lastVisible = scrollsettings
		end)
		offset = offset + 21
		local offsetgroup = 5
		local subgroupoffset = 0
		for subgroup, options in pairs(subgroups) do
			local panel = CreateFrame("Frame", group..subgroup, settings)
			panel:SetSize(settings:GetWidth(), 100)
			panel:SetPoint("TOP", 0, -subgroupoffset-25)
			CreateBG(panel)
			panel.title = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
			panel.title:SetPoint("TOPLEFT", 0, 20)
			panel.title:SetText(subgroup)
			panel.widgets = {}
			for option, value in pairs(options) do
				if type(value) == "boolean" then
					local check = CreateFrame("CheckButton", "UIConfigSettings"..group..option, panel, "InterfaceOptionsCheckButtonTemplate")
					_G[check:GetName().."Text"]:SetText(option)
					check:SetChecked(value)
					check:SetScript("OnClick", function(self)
						SetValue(group, option, self:GetChecked() and true or false)
					end)
					check:SetPoint("TOPLEFT", 5, -offsetgroup)
					tinsert(panel.widgets, check)
				end
				if type(value) == "number" or type(value) == "string" then
					local label = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
					label:SetText(option)
					label:SetWidth(140)
					label:SetHeight(20)
					label:SetJustifyH("LEFT")
					label:SetPoint("TOPLEFT", 5, -offsetgroup)
					local editbox = CreateFrame("EditBox", nil, panel)
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
					local label = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
					label:SetText(option)
					label:SetWidth(140)
					label:SetHeight(20)
					label:SetJustifyH("LEFT")
					label:SetPoint("TOPLEFT", 5, -offsetgroup)
					local button = CreateFrame("Button", nil, panel)
					button:SetSize(50, 20)
					button:SetPoint("LEFT", label, "RIGHT", 5, 0)
					button.bg = CreateBG(button)
					button.bg:SetBackdropBorderColor(unpack(value))
					button.label = button:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
					button.label:SetText(COLOR)
					button.label:SetPoint("CENTER")
					button.option = option
					button:SetScript("OnClick", function(self) 
						if ColorPickerFrame:IsShown() then return end
						local r, g, b, a = unpack(value)

						local function myColorCallback(restore)
							local newR, newG, newB, newA
							if restore then
								newR, newG, newB, newA = unpack(restore)
							else
								newA, newR, newG, newB = OpacitySliderFrame:GetValue(), ColorPickerFrame:GetColorRGB()
							end
							SetValue(group, self.option, {newR, newG, newB, newA})
							self.bg:SetBackdropBorderColor(newR, newG, newB, newA)
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
				PanelLayout(panel)
				offsetgroup = offsetgroup + 25
			end
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
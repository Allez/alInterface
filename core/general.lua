local addon_name, ns = ...

if GetLocale() == "ruRU" then
	UI_FONT = "Interface\\Addons\\"..addon_name.."\\media\\VisitorR.TTF"
	UI_FONT_SIZE = 10
	NORMAL_FONT = "Interface\\Addons\\"..addon_name.."\\media\\myriad.ttf"
else
	UI_FONT = "Interface\\Addons\\"..addon_name.."\\media\\visitor1.TTF"
	UI_FONT_SIZE = 9
	NORMAL_FONT = "Interface\\Addons\\"..addon_name.."\\media\\myriad.ttf"
end

local config = {
	fonts = {
		font = {
			order = 1,
			value = UI_FONT,
		},
		size = {
			order = 2,
			value = UI_FONT_SIZE,
			type = "range",
			min = 8,
			max = 20,
		},
		style = {
			order = 3,
			value = "OUTLINEMONOCHROME",
			type = "select",
			select = {"OUTLINEMONOCHROME", "OUTLINE", "THICKOUTLINE", "NONE"},
		},
		shadow = {
			order = 4,
			value = false,
		},
		normalfont = {
			order = 5,
			value = NORMAL_FONT,
		},
	},
}

local cfg = {}
UIConfigGUI.general = config
UIConfig.general = cfg
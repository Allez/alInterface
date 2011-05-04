local addon_name, ns = ...

if GetLocale() == "ruRU" then
	UI_FONT = "Interface\\Addons\\"..addon_name.."\\media\\VisitorR.TTF"
else
	UI_FONT = "Interface\\Addons\\"..addon_name.."\\media\\visitor1.TTF"
end

local config = {
	fonts = {
		font = {
			order = 1,
			value = UI_FONT,
		},
		size = {
			order = 2,
			value = 10,
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
	},
}

local cfg = {}
UIConfigGUI.general = config
UIConfig.general = cfg
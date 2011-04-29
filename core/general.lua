local addon_name, ns = ...

local config = {
	fonts = {
		font = {
			order = 1,
			value = "Interface\\Addons\\"..addon_name.."\\media\\VisitorR.TTF",
		},
	},
}

local cfg = {}
UIConfigGUI.general = config
UIConfig.general = cfg
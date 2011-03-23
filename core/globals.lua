
UI_FONT_SIZE = 10
UI_PIXEL_FONT = "Interface\\Addons\\"..addon_name.."\\media\\VisitorR.ttf"
UI_TEXTURE = "Interface\\Addons\\"..addon_name.."\\media\\UI-StatusBar"
UI_TEXTURE_UF = "Interface\\Addons\\"..addon_name.."\\media\\statusbarTex"
UI_TEXTURE_GLOW = "Interface\\Addons\\"..addon_name.."\\media\\glowTex"

CreateBG = function(parent, noparent)
	local bg = CreateFrame('Frame', nil, noparent and UIParent or parent)
	bg:SetPoint('TOPLEFT', parent, 'TOPLEFT', -2, 2)
	bg:SetPoint('BOTTOMRIGHT', parent, 'BOTTOMRIGHT', 2, -2)
	bg:SetFrameLevel(parent:GetFrameLevel()-1 > 0 and parent:GetFrameLevel()-1 or 0)
	bg:SetBackdrop({
		bgFile = [=[Interface\ChatFrame\ChatFrameBackground]=],
		edgeFile = [=[Interface\ChatFrame\ChatFrameBackground]=],
		edgeSize = 1,
		insets = { left = 1, right = 1, top = 1, bottom = 1}
	})
	bg:SetBackdropColor(0, 0, 0, .65) 
	bg:SetBackdropBorderColor(.35, .3, .3, 1)
	bg.border = CreateFrame("Frame", nil, bg)
	bg.border:SetPoint("TOPLEFT", 1, -1)
	bg.border:SetPoint("BOTTOMRIGHT", -1, 1)
	bg.border:SetFrameLevel(bg:GetFrameLevel())
	bg.border:SetBackdrop({
		edgeFile = [=[Interface\ChatFrame\ChatFrameBackground]=],
		edgeSize = 1,
		insets = { left = 1, right = 1, top = 1, bottom = 1}
	})
	bg.border:SetBackdropBorderColor(0, 0, 0, 1)
	bg.border2 = CreateFrame("Frame", nil, bg)
	bg.border2:SetPoint("TOPLEFT", -1, 1)
	bg.border2:SetPoint("BOTTOMRIGHT", 1, -1)
	bg.border2:SetFrameLevel(bg:GetFrameLevel())
	bg.border2:SetBackdrop({
		edgeFile = [=[Interface\ChatFrame\ChatFrameBackground]=],
		edgeSize = 1,
		insets = { left = 1, right = 1, top = 1, bottom = 1}
	})
	bg.border2:SetBackdropBorderColor(0, 0, 0, 0.9)
	return bg
end

CreateFS = function(frame, fsize, fstyle, sfont)
	local fstring = frame:CreateFontString(nil, 'OVERLAY')
	fstring:SetFont(sfont or config["Default font"], fsize, fstyle)
	fstring:SetShadowColor(0, 0, 0, 1)
	fstring:SetShadowOffset(0, 0)
	return fstring
end

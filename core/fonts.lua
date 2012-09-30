
--	Based on tekticles

local addon_name, ns = ...

local SetFont = function(obj, font, size, style, r, g, b, sr, sg, sb, sox, soy)
	obj:SetFont(font, size, style)
	if sr and sg and sb then obj:SetShadowColor(sr, sg, sb) end
	if sox and soy then obj:SetShadowOffset(sox, soy) end
	if r and g and b then obj:SetTextColor(r, g, b)
	elseif r then obj:SetAlpha(r) end
end

local UIFonts = CreateFrame("Frame", nil, UIParent)
UIFonts:RegisterEvent("ADDON_LOADED")
UIFonts:SetScript("OnEvent", function(self, event, addon)
	if addon ~= addon_name or addon == "tekticles" then return end

	local NORMAL = UI_NORMAL_FONT

	UIDROPDOWNMENU_DEFAULT_TEXT_HEIGHT = 12
	CHAT_FONT_HEIGHTS = {11, 12, 13, 14, 15, 16, 17, 18, 19, 20}

	UNIT_NAME_FONT = NORMAL
	NAMEPLATE_FONT = NORMAL
	STANDARD_TEXT_FONT = NORMAL

	-- Base fonts
	SetFont(AchievementFont_Small, NORMAL, 11, nil, nil, nil, nil, 0, 0, 0, 1, -1)
	SetFont(InvoiceFont_Med, NORMAL, 13, nil, 0.15, 0.09, 0.04)
	SetFont(InvoiceFont_Small, NORMAL, 11, nil, 0.15, 0.09, 0.04)
	SetFont(MailFont_Large, NORMAL, 15, nil, 0.15, 0.09, 0.04, 0.54, 0.4, 0.1, 1, -1)
	SetFont(NumberFont_OutlineThick_Mono_Small, NORMAL, 12, "OUTLINE")
	SetFont(NumberFont_Outline_Huge, NORMAL, 30, "THICKOUTLINE", 30)
	SetFont(NumberFont_Outline_Large, NORMAL, 17, "OUTLINE")
	SetFont(NumberFont_Outline_Med, NORMAL, 15, "OUTLINE")
	SetFont(NumberFont_Shadow_Med, NORMAL, 14)
	SetFont(NumberFont_Shadow_Small, NORMAL, 12)
	SetFont(QuestFont_Large, NORMAL, 16)
	SetFont(QuestFont_Shadow_Huge, NORMAL, 19, nil, nil, nil, nil, 0.54, 0.4, 0.1)
	SetFont(QuestFont_Shadow_Small, NORMAL, 15)
	SetFont(QuestFont_Super_Huge, NORMAL, 20, nil, nil, nil, nil, 0, 0, 0, 1, -1)
	SetFont(ReputationDetailFont, NORMAL, 11, nil, nil, nil, nil, 0, 0, 0, 1, -1)
	SetFont(SpellFont_Small, NORMAL, 11)
	SetFont(SystemFont_InverseShadow_Small, NORMAL, 11)
	SetFont(SystemFont_Large, NORMAL, 17)
	SetFont(SystemFont_Med1, NORMAL, 13)
	SetFont(SystemFont_Med2, NORMAL, 14, nil, 0.15, 0.09, 0.04)
	SetFont(SystemFont_Med3, NORMAL, 15)
	SetFont(SystemFont_OutlineThick_Huge2, NORMAL, 22, "THICKOUTLINE")
	SetFont(SystemFont_OutlineThick_Huge4, NORMAL, 27, "THICKOUTLINE")
	SetFont(SystemFont_OutlineThick_WTF, NORMAL, 31, "THICKOUTLINE", nil, nil, nil, 0, 0, 0, 1, -1)
	SetFont(SystemFont_Outline_Small, NORMAL, 13, "OUTLINE")
	SetFont(SystemFont_Shadow_Huge1, NORMAL, 20)
	SetFont(SystemFont_Shadow_Huge3, NORMAL, 25)
	SetFont(SystemFont_Shadow_Large, NORMAL, 17)
	SetFont(SystemFont_Shadow_Med1, NORMAL, 13)
	SetFont(SystemFont_Shadow_Med2, NORMAL, 13)
	SetFont(SystemFont_Shadow_Med3, NORMAL, 15)
	SetFont(SystemFont_Shadow_Outline_Huge2, NORMAL, 22, "OUTLINE")
	SetFont(SystemFont_Shadow_Small, NORMAL, 11)
	SetFont(SystemFont_Small, NORMAL, 12)
	SetFont(SystemFont_Tiny, NORMAL, 11)
	SetFont(GameTooltipHeader, NORMAL, 14, nil, nil, nil, nil, 0, 0, 0, 1, -1)
	SetFont(Tooltip_Med, NORMAL, 12, nil, nil, nil, nil, 0, 0, 0, 1, -1)
	SetFont(Tooltip_Small, NORMAL, 11, nil, nil, nil, nil, 0, 0, 0, 1, -1)
	SetFont(GameTooltipTextSmall, NORMAL, 12, nil, nil, nil, nil, 0, 0, 0, 1, -1)
	SetFont(FriendsFont_Small, NORMAL, 11)
	SetFont(FriendsFont_Normal, NORMAL, 12)
	SetFont(FriendsFont_Large, NORMAL, 15)
	SetFont(FriendsFont_UserText, NORMAL, 11)
	SetFont(ZoneTextString, NORMAL, 32, "OUTLINE")
	SetFont(SubZoneTextString, NORMAL, 25, "OUTLINE")
	SetFont(PVPInfoTextString, NORMAL, 22, "THINOUTLINE")
	SetFont(PVPArenaTextString, NORMAL, 22, "THINOUTLINE")
	SetFont(CoreAbilityFont, NORMAL, 32, nil, 1, 0.82, 0, 0, 0, 0, 1, -1)

	-- Derived fonts
	SetFont(BossEmoteNormalHuge, NORMAL, 27, "THICKOUTLINE")
	SetFont(ErrorFont, NORMAL, 16, nil, 60)
	SetFont(QuestFontNormalSmall, NORMAL, 13, nil, nil, nil, nil, 0.54, 0.4, 0.1)
	SetFont(WorldMapTextFont, NORMAL, 31, "THICKOUTLINE", 40, nil, nil, 0, 0, 0, 1, -1)
	SetFont(HelpFrameKnowledgebaseNavBarHomeButtonText, NORMAL, 13, nil, nil, nil, nil, 0, 0, 0, 1, -1)

	-- Channel list
	for i = 1, MAX_CHANNEL_BUTTONS do
		local f = _G["ChannelButton"..i.."Text"]
		f:SetFontObject(GameFontNormalSmallLeft)
	end

	-- Player title
	for _, butt in pairs(PaperDollTitlesPane.buttons) do butt.text:SetFontObject(GameFontHighlightSmallLeft) end
	
	-- Registering fonts in LibSharedMedia
	local LSM = LibStub and LibStub:GetLibrary("LibSharedMedia-3.0", true)
	local LOCALE_MASK = 0
	if GetLocale() == "koKR" then
		LOCALE_MASK = 1
	elseif GetLocale() == "ruRU" then
		LOCALE_MASK = 2
	elseif GetLocale() == "zhCN" then
		LOCALE_MASK = 4
	elseif GetLocale() == "zhTW" then
		LOCALE_MASK = 8
	else
		LOCALE_MASK = 128
	end

	if LSM then
		LSM:Register(LSM.MediaType.FONT, "Myriad", UIConfig.general.fonts.normalfont, LOCALE_MASK)
		LSM:Register(LSM.MediaType.FONT, "Visitor", UIConfig.general.fonts.font, LOCALE_MASK)
		--LSM:Register(LSM.MediaType.STATUSBAR, "Smooth", C.media.texture)
	end
end)

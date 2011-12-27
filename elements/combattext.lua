-- Based on LightCT by ALZA

local config = {
	general = {
		outgoingdamage = {
			order = 1,
			value = true,
		},
		outgoinghealing = {
			order = 2,
			value = true,
		},
	},
}

local cfg = {}
UIConfigGUI.combattext = config
UIConfig.combattext = cfg

local frames = {}

for i = 1, 4 do
	local f = CreateFrame("ScrollingMessageFrame", "CombatText_"..i, UIParent)
	f:SetFont(GameFontNormal:GetFont(), 16, "OUTLINE")
	f:SetShadowColor(0, 0, 0, 1)
	f:SetFadeDuration(0.4)
	f:SetTimeVisible(3)
	f:SetMaxLines(100)
	f:SetSpacing(2)

	if i == 1 then
		f:SetJustifyH("RIGHT")
		f:SetPoint("BOTTOM", UIParent, "BOTTOM", -145, 370)
		f:SetSize(84, 140)
	elseif i == 2 then
		f:SetJustifyH("LEFT")
		f:SetPoint("BOTTOM", UIParent, "BOTTOM", -235, 370)
		f:SetSize(84, 140)
	elseif i == 3 then
		f:SetJustifyH("CENTER")
		f:SetPoint("CENTER", UIParent, "CENTER", 0, 235)
		f:SetSize(140, 84)
	elseif i == 4 then
		f:SetJustifyH("RIGHT")
		f:SetPoint("CENTER", UIParent, "CENTER", 235, 120)
		f:SetSize(84, 140)
	end

	frames[i] = f
	if UIMovableFrames then tinsert(UIMovableFrames, f) end
end

local tbl = {
	["DAMAGE"] =            {frame = 1, prefix =  "-", 	arg2 = true, 	r = 1, 		g = 0.1, 	b = 0.1},
	["DAMAGE_CRIT"] =       {frame = 1, prefix = "c-", 	arg2 = true, 	r = 1, 		g = 0.1, 	b = 0.1},
	["SPELL_DAMAGE"] =      {frame = 1, prefix =  "-", 	arg2 = true, 	r = 0.79, 	g = 0.3, 	b = 0.85},
	["SPELL_DAMAGE_CRIT"] = {frame = 1, prefix = "c-", 	arg2 = true, 	r = 0.79, 	g = 0.3, 	b = 0.85},
	["HEAL"] =              {frame = 2, prefix =  "+", 	arg3 = true, 	r = 0.1, 	g = 1, 		b = 0.1},
	["HEAL_CRIT"] =         {frame = 2, prefix = "c+", 	arg3 = true, 	r = 0.1, 	g = 1, 		b = 0.1},
	["PERIODIC_HEAL"] =     {frame = 2, prefix =  "+", 	arg3 = true, 	r = 0.1, 	g = 1, 		b = 0.1},
	["MISS"] =              {frame = 1, prefix = "Miss", 			r = 1, 		g = 0.1, 	b = 0.1},
	["SPELL_MISS"] =        {frame = 1, prefix = "Miss", 			r = 0.79, 	g = 0.3, 	b = 0.85},
	["SPELL_REFLECT"] =     {frame = 1, prefix = "Reflect", 		r = 1, 		g = 1, 		b = 1},
	["DODGE"] =             {frame = 1, prefix = "Dodge", 			r = 1, 		g = 0.1, 	b = 0.1},
	["PARRY"] =             {frame = 1, prefix = "Parry", 			r = 1, 		g = 0.1, 	b = 0.1},
	["BLOCK"] =             {frame = 1, prefix = "Block", 	spec = true,	r = 1, 		g = 0.1, 	b = 0.1},
	["RESIST"] =            {frame = 1, prefix = "Resist", 	spec = true, 	r = 1, 		g = 0.1, 	b = 0.1},
	["SPELL_RESIST"] =      {frame = 1, prefix = "Resist", 	spec = true, 	r = 0.79, 	g = 0.3, 	b = 0.85},
	["ABSORB"] =            {frame = 1, prefix = "Absorb", 	spec = true, 	r = 1, 		g = 0.1, 	b = 0.1},
	["SPELL_ABSORBED"] =    {frame = 1, prefix = "Absorb", 	spec = true, 	r = 0.79, 	g = 0.3, 	b = 0.85},
}


local info
local template = "-%s (%s)"
local timer = 0
local queue = {}
local dcolor = {
	[1]  = {1.0, 1.0, 0.0}, -- physical
	[2]  = {1.0, 0.9, 0.5}, -- holy
	[4]  = {1.0, 0.5, 0.0}, -- fire
	[8]  = {0.3, 1.0, 0.3}, -- nature
	[16] = {0.5, 1.0, 1.0}, -- frost
	[32] = {0.5, 0.5, 1.0}, -- shadow
	[64] = {1.0, 0.5, 1.0}, -- arcane
}
local filterGuard = COMBATLOG_OBJECT_CONTROL_PLAYER + COMBATLOG_OBJECT_TYPE_GUARDIAN


local OnUpdate = function(self, elapsed)
	timer = timer + elapsed
	if timer > 1 then
		local ctime = GetTime()
		for i, v in pairs(queue) do
			if not v.delay or ctime - v.start > 2 then
				local msg
				local icon = GetSpellTexture(i)
				if v.count == 1 then
					msg = v.value
					if v.critical then msg = "|cffff2222*|r"..msg.."|cffff2222*|r" end
				else
					msg = v.value.."|cffffffff x "..v.count.."|r"
				end
				queue[i] = nil
				frames[4]:AddMessage(msg.." |T"..icon..":16:16:0:0:64:64:5:59:5:59|t", unpack(v.color))
			end
		end
		timer = 0
	end
end

local OnEvent = function(self, event, ...)
	if event == "COMBAT_TEXT_UPDATE" then
		local subev, arg2, arg3 = ...
		info = tbl[subev]
		if info then
			local msg = info.prefix or ""
			if info.spec then
				if arg3 then
					msg = template:format(arg2, arg3)
				end
			else
				if info.arg2 then msg = msg..arg2 end
				if info.arg3 then msg = msg..arg3 end
			end
			frames[info.frame]:AddMessage(msg, info.r, info.g, info.b)
		end
	elseif event == "PLAYER_REGEN_ENABLED" then
		frames[3]:AddMessage(LEAVING_COMBAT, 0.15, 1, 0.15)
	elseif event == "PLAYER_REGEN_DISABLED" then
		frames[3]:AddMessage(ENTERING_COMBAT, 1, 0.15, 0.15) 
	elseif event == "COMBAT_LOG_EVENT_UNFILTERED" then
		if not cfg.general.outgoingdamage and not cfg.general.outgoinghealing then
			self:UnregisterEvent(event)
			self:SetScript("OnUpdate", nil)
			return
		end
		local timestamp, eventType, _, sourceGUID, sourceName, sourceFlags, _, destGUID, destName, destFlags = ...
		if bit.band(sourceFlags, COMBATLOG_OBJECT_AFFILIATION_MINE) == 0 or sourceGUID == destGUID then return end
		if cfg.general.outgoingdamage then
			if eventType=="SWING_DAMAGE" then
				local amount, _, _, _, _, absorbed, critical = select(12, ...)
				if not amount then return end
				local msg = amount
				local icon
				if critical then msg = "|cffff2222*|r"..msg.."|cffff2222*|r" end
				if bit.band(sourceFlags, filterGuard) == filterGuard or sourceGUID == UnitGUID("pet") then
					icon = PET_ATTACK_TEXTURE
				else
					icon = GetSpellTexture(6603)
				end
				frames[4]:AddMessage(msg.." |T"..icon..":16:16:0:0:64:64:5:59:5:59|t", 1, 1, 1)
			elseif eventType=="RANGE_DAMAGE" or eventType=="SPELL_DAMAGE" or eventType=="SPELL_PERIODIC_DAMAGE" or eventType=="DAMAGE_SHIELD" then
				local spellId, _, spellSchool, amount, _, _, _, _, absorbed, critical = select(12, ...)
				if not amount then return end
				if queue[spellId] then
					queue[spellId].count = queue[spellId].count + 1
					queue[spellId].value = queue[spellId].value + amount
				else
					queue[spellId] = {
						count = 1,
						value = amount,
						start = GetTime(),
						color = dcolor[spellSchool] or dcolor[1],
						critical = critical,
						delay = eventType == "SPELL_PERIODIC_DAMAGE",
					}
				end
			elseif eventType=="SWING_MISSED" then
				local missType = select(12, ...)
				local icon
				if bit.band(sourceFlags, filterGuard) == filterGuard or sourceGUID == UnitGUID("pet") then
					icon = PET_ATTACK_TEXTURE
				else
					icon = GetSpellTexture(6603)
				end
				frames[4]:AddMessage(missType.." |T"..icon..":16:16:0:0:64:64:5:59:5:59|t", 1, 1, 1)
			elseif eventType=="RANGE_MISSED" or eventType=="SPELL_MISSED" then
				local spellId, _, _, missType = select(12, ...)
				local icon = GetSpellTexture(spellId)
				frames[4]:AddMessage(missType.." |T"..icon..":16:16:0:0:64:64:5:59:5:59|t", 1, 1, 1)
			end
		end
		if cfg.general.outgoinghealing then
			if eventType=="SPELL_HEAL" or eventType=="SPELL_PERIODIC_HEAL" then
				local spellId, _, _, amount, _, _, _, _, absorbed, critical = select(12, ...)
				if not amount then return end
				if queue[spellId] then
					queue[spellId].count = queue[spellId].count + 1
					queue[spellId].value = queue[spellId].value + amount
				else
					queue[spellId] = {
						count = 1,
						value = amount,
						start = GetTime(),
						color = {0.15, 1, 0.15},
						critical = critical,
						delay = eventType == "SPELL_PERIODIC_HEAL",
					}
				end
			end
		end
	end
end

local addon = CreateFrame("Frame")
addon:RegisterEvent("COMBAT_TEXT_UPDATE")
addon:RegisterEvent("PLAYER_REGEN_ENABLED")
addon:RegisterEvent("PLAYER_REGEN_DISABLED")
addon:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
addon:SetScript("OnEvent", OnEvent)
addon:SetScript("OnUpdate", OnUpdate)

CombatText:SetScript("OnUpdate", nil)
CombatText:SetScript("OnEvent", nil)
CombatText:UnregisterAllEvents()
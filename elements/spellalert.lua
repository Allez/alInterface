
local addon_name, ns = ...

local show = {
	["none"] = true, 
	["pvp"] = true, 
	["arena"] = true,
}

local spells = {
	[GetSpellInfo(23920)] = true, -- Spell reflection
	[GetSpellInfo(49039)] = true, -- Lichborne
	[GetSpellInfo(54428)] = true, -- Divine Plea
	[GetSpellInfo(29166)] = true, -- Innervate
	[GetSpellInfo(16190)] = true, -- Mana Tide Totem
	[GetSpellInfo(31224)] = true, -- Cloak of Shadows
	[GetSpellInfo(48707)] = true, -- Anti-Magic Shell
	[GetSpellInfo(8143)]  = true, -- Tremor Totem
	[GetSpellInfo(45438)] = true, -- Ice Block
	[GetSpellInfo(642)]   = true, -- Divine Shield
	[GetSpellInfo(19263)] = true, -- Deterrence
}

local cfg = {}
local config = {
	general = {
		enabled = {
			order = 1,
			value = true,
		},
	},
	showin = {
		world = {
			order = 1,
			value = true,
		},
		bg = {
			order = 2,
			value = true,
		},
		arena = {
			order = 3,
			value = true,
		},
	},
}

UIConfigGUI.spellalert = config
UIConfig.spellalert = cfg

local frame = CreateFrame("Frame")
frame:RegisterEvent("VARIABLES_LOADED")
frame:SetScript("OnEvent", function(self, event)
	show = {
		["none"] = cfg.showin.world, 
		["pvp"] = cfg.showin.bg, 
		["arena"] = cfg.showin.arena,
	}
end)

local OnUpdate = function(self)
	local elapsed = GetTime() - self.start
	if elapsed < self.hold then
		self:SetAlpha(1.0)
		return
	end
	if elapsed < self.hold + self.fadeOut then
		self:SetAlpha(1.0 - ((elapsed - self.hold) / self.fadeOut))
		return
	end
	self:Hide()
end

local ShowAlert = function(frame, text, color)
	frame.start = GetTime()
	frame.hold = 1
	frame.fadeOut = 2
	frame.text:SetText(text)
	frame.text:SetTextColor(unpack(color))
	frame:Show()
end

local OnEvent = function(self, event, ...)
	if event == "PLAYER_ENTERING_WORLD" then
		self:UnregisterEvent(event)
		self:SetSize(150, 30)
		self:SetPoint('CENTER', 0, 150)
		self.text = CreateFS(self, 25, "OUTLINE", UI_NORMAL_FONT)
		self.text:SetPoint('CENTER')
		tinsert(UIMovableFrames, self)
		return
	end
	if event == "COMBAT_LOG_EVENT_UNFILTERED" then
		if not cfg.general.enabled then
			self:UnregisterAllEvents()
			return
		end
		local timestamp, eventType, _, sourceGUID, sourceName, sourceFlags, _, _, _, _, _, spellID, spellName = ...
		if spells[spellName] and show[select(2, IsInInstance())] and bit.band(sourceFlags, COMBATLOG_OBJECT_REACTION_HOSTILE) == COMBATLOG_OBJECT_REACTION_HOSTILE then
			if eventType == "SPELL_CAST_SUCCESS" then			
				ShowAlert(self, spellName.." up!", {0.9, 0.1, 0.1})
				PlaySoundFile("Interface\\AddOns\\"..addon_name.."\\media\\pulse.ogg")
			elseif eventType == "SPELL_AURA_REMOVED" then
				ShowAlert(self, spellName.." down.", {0.1, 0.9, 0.1});
			end
		end
	end
end

local frame = CreateFrame("frame", "Spell Alert", UIParent)
frame:SetScript('OnEvent', OnEvent)
frame:SetScript('OnUpdate', OnUpdate)
frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:Hide()

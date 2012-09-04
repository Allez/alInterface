local _, ns = ...
local oUF = ns.oUF

local function GetAuras()
	return {
		-- Spell Name			Priority (higher = more priority)
		-- Crowd Controls
		-- Death Knight
		[GetSpellInfo(47481)] = 4,	-- Gnaw (Pet)
		[GetSpellInfo(91797)] = 4,	-- Monstrous Blow (Pet - mutant)
		[GetSpellInfo(108194)] = 4,	-- Asphyxiate
		[GetSpellInfo(115001)] = 4,	-- Remorseless Winter
		-- Druid
		[GetSpellInfo(33786)] = 4,	-- Cyclone
		[GetSpellInfo(2637)] = 4,	-- Hibernate
		[GetSpellInfo(5211)] = 4,	-- Mighty Bash
		[GetSpellInfo(102795)] = 4,	-- Bear Hug
		[GetSpellInfo(22570)] = 4,	-- Maim
		[GetSpellInfo(9005)] = 4,	-- Pounce
		[GetSpellInfo(99)] = 4,		-- Disorienting Roar
		-- Hunter
		[GetSpellInfo(24394)] = 4,	-- Intimidation
		[GetSpellInfo(3355)] = 4,	-- Freezing Trap
		[GetSpellInfo(19503)] = 4,	-- Scatter Shot
		[GetSpellInfo(19386)] = 4,	-- Wyvern Sting
		[GetSpellInfo(50519)] = 4,	-- Sonic Blast (Bat)
		[GetSpellInfo(90337)] = 4,	-- Bad Manner (Monkey)
		-- Mage
		[GetSpellInfo(44572)] = 4,	-- Deep Freeze
		[GetSpellInfo(118)] = 4,	-- Polymorph
		[GetSpellInfo(82691)] = 4,	-- Ring of Frost
		[GetSpellInfo(31661)] = 4,	-- Dragon's Breath
		[GetSpellInfo(118271)] = 4,	-- Combustion Impact
		-- Monk
		[GetSpellInfo(113656)] = 4,	-- Fists of Fury
		[GetSpellInfo(119381)] = 4,	-- Leg Sweep
		[GetSpellInfo(115078)] = 4,	-- Paralysis
		[GetSpellInfo(119392)] = 4,	-- Charging Ox Wave
		[GetSpellInfo(122242)] = 4,	-- Clash
		-- Paladin
		[GetSpellInfo(853)] = 4,	-- Hammer of Justice
		[GetSpellInfo(105593)] = 4,	-- Fist of Justice
		[GetSpellInfo(20066)] = 4,	-- Repentance
		-- Priest
		[GetSpellInfo(64044)] = 4,	-- Psychic Horror
		[GetSpellInfo(605)] = 4,	-- Dominate Mind
		[GetSpellInfo(8122)] = 4,	-- Psychic Scream
		-- Rogue
		[GetSpellInfo(408)] = 4,	-- Kidney Shot
		[GetSpellInfo(1833)] = 4,	-- Cheap Shot
		[GetSpellInfo(6770)] = 4,	-- Sap
		[GetSpellInfo(2094)] = 4,	-- Blind
		[GetSpellInfo(1776)] = 4,	-- Gouge
		-- Shaman
		[GetSpellInfo(51514)] = 4,	-- Hex
		[GetSpellInfo(118905)] = 4,	-- Static Charge
		-- Warlock
		[GetSpellInfo(30283)] = 4,	-- Shadowfury
		[GetSpellInfo(89766)] = 4,	-- Axe Toss (Felguard)
		[GetSpellInfo(5782)] = 4,	-- Fear
		[GetSpellInfo(5484)] = 4,	-- Howl of Terror
		[GetSpellInfo(6789)] = 4,	-- Mortal Coil
		[GetSpellInfo(6358)] = 4,	-- Seduction (Succubus)
		-- Warrior
		[GetSpellInfo(107570)] = 4,	-- Storm Bolt
		[GetSpellInfo(46968)] = 4,	-- Shockwave
		[GetSpellInfo(5246)] = 4,	-- Intimidating Shout

		-- Silences
		[GetSpellInfo(47476)] = 4,	-- Strangulate
		[GetSpellInfo(81261)] = 4,	-- Solar Beam
		[GetSpellInfo(34490)] = 4,	-- Silencing Shot
		[GetSpellInfo(44957)] = 4,	-- Nether Shock (Nether Ray)
		[GetSpellInfo(102051)] = 4,	-- Frostjaw
		[GetSpellInfo(55021)] = 4,	-- Improved Counterspell
		[GetSpellInfo(31935)] = 4,	-- Avenger's Shield
		[GetSpellInfo(15487)] = 4,	-- Silence
		[GetSpellInfo(1330)] = 4,	-- Garrote - Silence
		[GetSpellInfo(24259)] = 4,	-- Spell Lock (Felhunter)

		-- Roots
		[GetSpellInfo(339)] = 3,	-- Entangling Roots
		[GetSpellInfo(122)] = 3,	-- Frost Nova
		[GetSpellInfo(87194)] = 3,	-- Glyph of Mind Blast
		[GetSpellInfo(33395)] = 3,	-- Freeze
		[GetSpellInfo(111340)] = 3,	-- Ice Ward
		[GetSpellInfo(45334)] = 3,	-- Immobilized
		[GetSpellInfo(19185)] = 3,	-- Entrapment
		[GetSpellInfo(50245)] = 3,	-- Pin (Crab)
		[GetSpellInfo(54706)] = 3,	-- Venom Web Spray (Silithid)
		[GetSpellInfo(4167)] = 3,	-- Web (Spider)
		[GetSpellInfo(63685)] = 3,	-- Freeze (Frozen Power)

		-- Immunities
		[GetSpellInfo(45438)] = 2,	-- Ice Block
		[GetSpellInfo(642)] = 2,	-- Divine Shield
		[GetSpellInfo(46924)] = 2,	-- Bladestorm
		[GetSpellInfo(19263)] = 2,	-- Deterrence

		-- Disarms
		[GetSpellInfo(676)] = 1,	-- Disarm
		[GetSpellInfo(51722)] = 1,	-- Dismantle
		[GetSpellInfo(50541)] = 1,	-- Clench (Scorpid)

		-- Buffs
		[GetSpellInfo(33206)] = 1,	-- Pain Suppression
		[GetSpellInfo(1022)] = 1,	-- Hand of Protection
		[GetSpellInfo(6940)] = 1,	-- Hand of Sacrifice
		[GetSpellInfo(1044)] = 1,	-- Hand of Freedom
		[GetSpellInfo(29166)] = 1,	-- Innervate
		[GetSpellInfo(54428)] = 1,	-- Divine Plea
		[GetSpellInfo(31821)] = 1,	-- Devotion Aura
		[GetSpellInfo(96267)] = 1,	-- Glyph of Inner Focus
		[GetSpellInfo(8178)] = 1,	-- Grounding Totem
		[GetSpellInfo(49016)] = 1,	-- Unholy Frenzy

		-- Defense abilities
		[GetSpellInfo(871)] = 1,	-- Shield Wall
		[GetSpellInfo(48707)] = 1,	-- Anti-Magic Shell
		[GetSpellInfo(31224)] = 1,	-- Cloak of Shadows
		[GetSpellInfo(48792)] = 1,	-- Icebound Fortitude
		
	}
end

local function Update(object, event, unit)

	if object.unit ~= unit  then return end

	local auraList = GetAuras()
	local priority = 0
	local auraName, auraIcon, auraExpTime
	local index = 1

	--Buffs
	while ( true ) do
		local name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable = UnitAura(unit, index, "HELPFUL")
		if ( not name ) then break end
		
		if ( auraList[name] and auraList[name] >= priority ) then
			priority = auraList[name]
			auraName = name
			auraIcon = icon
			auraExpTime = expirationTime
		end
		
		index = index+1
	end
	
	index = 1
	
	--Debuffs 
	while ( true ) do
		local name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable = UnitAura(unit, index, "HARMFUL")
		if ( not name ) then break end
		
		if ( auraList[name] and auraList[name] >= priority ) then
			priority = auraList[name]
			auraName = name
			auraIcon = icon
			auraExpTime = expirationTime
		end
		
		index = index+1	
	end
	
	if ( auraName ) then -- If an aura is found, display it and set the time left!
		--frame.portrait:SetAlpha(0)
		object.AuraTracker.icon:SetTexture(auraIcon)
		--object.AuraTracker.text:SetFormattedText("%.1f", (auraExpTime-GetTime()))
		object.AuraTracker.timeleft = (auraExpTime-GetTime())
		object.AuraTracker.active = true
--	elseif ( not auraName and frame.CCFrame.auraActive ) then -- No aura found and one is shown? Kill it since it's no longer active!

	elseif ( not auraName ) then -- No aura found and one is shown? Kill it since it's no longer active!
		--frame.portrait:SetAlpha(1)
		object.AuraTracker.icon:SetTexture("")
		object.AuraTracker.text:SetText("")
		object.AuraTracker.active = false
	end
end

local function Enable(object)
	-- if we're not highlighting this unit return
	if not object.AuraTracker then return end

	-- make sure aura scanning is active for this object
	object:RegisterEvent("UNIT_AURA", Update)

	return true
end

local function Disable(object)
	if object.AuraTracker then
		object:UnregisterEvent("UNIT_AURA", Update)
	end
end

oUF:AddElement('AuraTracker', Update, Enable, Disable)

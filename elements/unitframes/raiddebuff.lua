local _, ns = ...
local ORD = ns.oUF_RaidDebuffs or oUF_RaidDebuffs

if not ORD then return end

ORD.ShowDispelableDebuff = true
ORD.FilterDispellableDebuff = true
ORD.MatchBySpellName = false
ORD.SHAMAN_CAN_DECURSE = true

local debuffFilter = {
-- "Vault of Archavon"
	--Koralon
	67332,66684,--Flaming Cinder (10, 25)

	--Toravon the Ice Watcher
	72004,72098,72120,72121,--Frostbite

	--Toravon the Ice Watcher
	72004,72098,72120,72121,--Frostbite

-- "Naxxramas"
	--Trash
	55314,--Strangulate

	--Anub'Rekhan
	28786, 54022,--Locust Swarm (N, H)

	--Grand Widow Faerlina
	28796, 54098,--Poison Bolt Volley (N, H)
	28794, 54099,--Rain of Fire (N, H)

	--Maexxna
	28622,--Web Wrap (NH)
	54121, 28776,--Necrotic Poison (N, H)

	--Noth the Plaguebringer
	29213, 54835,--Curse of the Plaguebringer (N, H)
	29214, 54836,--Wrath of the Plaguebringer (N, H)
	29212,--Cripple (NH)

	--Heigan the Unclean
	29998, 55011,--Decrepit Fever (N, H)
	29310,--Spell Disruption (NH)

	--Grobbulus
	28169,--Mutating Injection (NH)

	--Gluth
	54378,--Mortal Wound (NH)
	29306,--Infected Wound (NH)

	--Thaddius
	28084, 28085,--Negative Charge (N, H)
	28059, 28062,--Positive Charge (N, H)

	--Instructor Razuvious
	55550,--Jagged Knife (NH)

	--Sapphiron
	28522,--Icebolt (NH)
	28542, 55665,--Life Drain (N, H)

	--Kel'Thuzad
	28410,--Chains of Kel'Thuzad (H)
	27819,--Detonate Mana (NH)
	27808,--Frost Blast (NH)

-- "The Eye of Eternity"
	--Malygos
	56272, 60072,--Arcane Breath (N, H)
	57407, 60936,--Surge of Power (N, H)

-- "The Obsidian Sanctum"
	--Trash
	39647,--Curse of Mending
	58936,--Rain of Fire

	--Sartharion
	60708,--Fade Armor (N, H)
	57491,--Flame Tsunami (N, H)

-- "Ulduar"
	--Trash
	62310, 62928,--Impale (N, H)
	63612, 63673,--Lightning Brand (N, H)
	63615,--Ravage Armor (NH)
	62283, 62438,--Iron Roots (N, H)
	63169, 63549,--Petrify Joints (N, H)

	--Razorscale
	64771,--Fuse Armor (NH)

	--Ignis the Furnace Master
	62548, 63476,--Scorch (N, H)
	62680, 63472,--Flame Jet (N, H)
	62717, 63477,--Slag Pot (N, H)

	--XT-002
	63024, 64234,--Gravity Bomb (N, H)
	63018, 65121,--Light Bomb (N, H)

	--The Assembly of Iron
	61888, 64637,--Overwhelming Power (N, H)
	62269, 63490,--Rune of Death (N, H)
	61903, 63493,--Fusion Punch (N, H)
	61912, 63494,--Static Disruption(N, H)

	--Kologarn
	64290, 64292,--Stone Grip (N, H)
	63355, 64002,--Crunch Armor (N, H)
	62055,--Brittle Skin (NH)

	--Hodir
	62469,--Freeze (NH)
	61969, 61990,--Flash Freeze (N, H)
	62188,--Biting Cold (NH)

	--Thorim
	62042,--Stormhammer (NH)
	62130,--Unbalancing Strike (NH)
	62526,--Rune Detonation (NH)
	62470,--Deafening Thunder (NH)
	62331, 62418,--Impale (N, H)

	--Freya
	62532,--Conservator's Grip (NH)
	62589, 63571,--Nature's Fury (N, H)
	62861, 62930,--Iron Roots (N, H)

	--Mimiron
	63666,--Napalm Shell (N)
	65026,--Napalm Shell (H)
	62997,--Plasma Blast (N)
	64529,--Plasma Blast (H)
	64668,--Magnetic Field (NH)

	--General Vezax
	63276,--Mark of the Faceless (NH)
	63322,--Saronite Vapors (NH)

	--Yogg-Saron
	63147,--Sara's Anger(NH)
	63134,--Sara's Blessing(NH)
	63138,--Sara's Fervor(NH)
	63830,--Malady of the Mind (H)
	63802,--Brain Link(H)
	63042,--Dominate Mind (H)
	64152,--Draining Poison (H)
	64153,--Black Plague (H)
	64125, 64126,--Squeeze (N, H)
	64156,--Apathy (H)
	64157,--Curse of Doom (H)
	--63050,--Sanity(NH)

	--Algalon
	64412,--Phase Punch

-- "Trial of the Crusader"
	--Gormok the Impaler
	66331, 67477, 67478, 67479,--Impale(10, 25, 10H, 25H)
	66406,--Snobolled!

	--Acidmaw --Dreadscale
	66819, 67609, 67610, 67611,--Acidic Spew (10, 25, 10H, 25H)
	66821, 67635, 67636, 67637,--Molten Spew (10, 25, 10H, 25H)
	66823, 67618, 67619, 67620,--Paralytic Toxin (10, 25, 10H, 25H)
	66869,--Burning Bile

	--Icehowl
	66770, 67654, 67655, 67656,--Ferocious Butt(10, 25, 10H, 25H)
	66689, 67650, 67651, 67652,--Arctic Breathe(10, 25, 10H, 25H)
	66683,--Massive Crash

	--Lord Jaraxxus
	66532, 66963, 66964, 66965,--Fel Fireball (10, 25, 10H, 25H)
	66237, 67049, 67050, 67051,--Incinerate Flesh (10, 25, 10H, 25H)
	66242, 67059, 67060, 67061,--Burning Inferno (10, 25, 10H, 25H)
	66197, 68123, 68124, 68125,--Legion Flame (10, 25, 10H, 25H)
	66199, 68126, 68127, 68128,--Legion Flame (Patch?: 10, 25, 10H, 25H)
	66877, 67070, 67071, 67072,--Legion Flame (Patch Icon?: 10, 25, 10H, 25H)
	66283,--Spinning Pain Spike
	66209,--Touch of Jaraxxus(H)
	66211,--Curse of the Nether(H)
	66333, 66334, 66335, 66336, 68156,--Mistress' Kiss (10H, 25H)

	--Faction Champions
	65812, 68154, 68155, 68156,--Unstable Affliction (10, 25, 10H, 25H)
	65801,--Polymorph
	65543,--Psychic Scream
	66054,--Hex
	65809,--Fear

	--The Twin Val'kyr
	67176,--Dark Essence
	67223,--Light Essence
	67282, 67283,--Dark Touch
	67297, 67298,--Light Touch
	67309, 67310, 67311, 67312,--Twin Spike (10, 25, 10H, 25H)

	--Anub'arak
	67574,--Pursued by Anub'arak
	66013, 67700, 68509, 68510,--Penetrating Cold (10, 25, 10H, 25H)
	67847, 67721,--Expose Weakness
	66012,--Freezing Slash
	67863,--Acid-Drenched Mandibles(25H)

-- "Icecrown Citadel"
	--Lord Marrowgar
	70823,--Coldflame
	69065,--Impaled
	70835,--Bone Storm

	--Lady Deathwhisper
	72109,--Death and Decay
	71289,--Dominate Mind
	71204,--Touch of Insignificance
	67934,--Frost Fever
	71237,--Curse of Torpor
	72491,71951,72490,72491,72492,--Necrotic Strike

	--Gunship Battle
	69651,--Wounding Strike

	--Deathbringer Saurfang
	72293,--Mark of the Fallen Champion
	72442,--Boiling Blood
	72449,--Rune of Blood
	72769,--Scent of Blood (heroic)

	--Festergut
	69290,71222,73033,73034,--Blighted Spore
	69248,72274,--Vile Gas?
	71218,72272,72273,73020,73019,69240,--Vile Gas?
	72219,72551,72552,72553,--Gastric Bloat
	69278,69279,71221, -- Gas Spore

	--Rotface
	69674,71224,73022,73023,--Mutated Infection
	69508,--Slime Spray
	30494,69774,69776,69778,71208,--Sticky Ooze

	--Professor Putricide
	70672,72455,72832,72833,--Gaseous Bloat
	72549,--Malleable Goo
	72454,--Mutated Plague
	70341,--Slime Puddle (Spray)
	70342,70346,72869,72868,--Slime Puddle (Pool)
	70911,72854,72855,72856,--Unbound Plague
	69774,72836,72837,72838,--Volatile Ooze Adhesive

	--Blood Prince Council
	71807,72796,72797,72798,--Glittering Sparks
	71911,71822,--Shadow Resonance

	--Blood-Queen Lana'thel
	71623,71624,71625,71626,72264,72265,72266,72267,--Delirious Slash
	70949,--Essence of the Blood Queen (hand icon)
	70867,70871,70872,70879,70950,71473,71525,71530,71531,71532,71533,--Essence of the Blood Queen (bite icon)
	72151,72648,72650,72649,--Frenzied Bloodthirst (bite icon)
	71474,70877,--Frenzied Bloodthirst (red bite icon)
	71340,71341,--Pact of the Darkfallen
	72985,--Swarming Shadows (pink icon)
	71267,71268,72635,72636,72637,--Swarming Shadows (black purple icon)
	71264,71265,71266,71277,72638,72639,72640,72890,--Swarming Shadows (swirl icon)
	70923,70924,73015,--Uncontrollable Frenzy

	--Valithria Dreamwalker
	70873,--Emerald Vigor
	70744,71733,72017,72018,--Acid Burst
	70751,71738,72021,72022,--Corrosion
	70633,71283,72025,72026,--Gut Spray

	--Sindragosa
	70106,--Chilled to the Bone
	69766,--Instability
	69762,--Unchained Magic
	70126,--Frost Beacon
	71665,--Asphyxiation
	70127,72528,72529,72530,--Mystic Buffet

	--Lich King
	70541,73779,73780,73781,--Infest
	70337,70338,73785,73786,73787,73912,73913,73914,--Necrotic Plague
	72133,73788,73789,73790,--Pain and Suffering
	68981,--Remorseless Winter
	69242,--Soul Shriek

	--Trash
	71089,--Bubbling Pus
	69483,--Dark Reckoning
	71163,--Devour Humanoid
	71127,--Mortal Wound
	70435,71154,--Rend Flesh
	
-- "The Ruby Sanctum"
	--Baltharus the Warborn
	74502,--Enervating Brand

	--General Zarithrian
	74367,--Cleave Armor

	--Saviana Ragefire
	74452,--Conflagration

	--Halion
	74562,--Fiery Combustion
	74567,--Mark of Combustion
	
-- "Blackwing Descent"
	-- Magmaw
	89773, -- Mangle
	94679, -- Parasitic Infection

	-- Omnitron Defense System
	79889, -- Lightning Conductor
	80161, -- Chemical Cloud
	80011, -- Soaked in Poison
	91535, -- Flamethrower
	91829, -- Fixate
	92035, -- Acquiring Target

	--Maloriak
	92991, -- Rend
	78225, -- Acid Nova
	92910, -- Debilitating Slime
	77786, -- Consuming Flames
	91829, -- Fixate
	77760, -- Biting Chill
	77699, -- Flash Freeze

	-- Atramedes
	78092, -- Tracking
	77840, -- Searing
	78353, -- Roaring Flame
	78897, -- Noisy

	-- Chimaeron
	89084, -- Low Health
	82934, -- Mortality
	88916, -- Caustic Slime
	82881, -- Break

	-- Nefarian
	94075, -- Magma
	77827, -- Tail Lash

-- "The Bastion of Twilight"
	-- Halfus Wyrmbreaker
	83908, -- Malevolent Strike
	83603, -- Stone Touch

	-- Valiona & Theralion
	86788, -- Blackout
	95639, -- Engulfing Magic
	86360, -- Twilight Shift

	-- Ascendant Council
	82762, -- Waterlogged
	83099, -- Lightning Rod
	82285, -- Elemental Stasis
	82660, -- Burning Blood
	82665, -- Heart of Ice

	-- Cho'gall
	93187, -- Corrupted Blood
	82523, -- Gall's Blast
	82518, -- Cho's Blast
	93134, -- Debilitating Beam

-- "Throne of the Four Winds"
	-- Conclave of Wind
	84645, -- Wind Chill
	86107, -- Ice Patch
	86082, -- Permafrost
	84643, -- Hurricane
	86281, -- Toxic Spores
	85573, -- Deafening Winds
	85576, -- Withering Winds

	-- Al'Akir
	88290, -- Acid Rain
	87873, -- Static Shock
	88427, -- Electrocute
	89668, -- Lightning Rod
}

ORD:RegisterDebuffs(debuffFilter)
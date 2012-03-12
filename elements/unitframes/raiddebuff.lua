local _, ns = ...
ns.raid_debuffs = {}

for k, v in ipairs {
-- "Vault of Archavon"
	--Koralon
	67332,--Flaming Cinder (10, 25)

	--Toravon the Ice Watcher
	72004,--Frostbite

-- "Naxxramas"
	--Trash
	55314,--Strangulate

	--Anub'Rekhan
	28786,--Locust Swarm (N, H)

	--Grand Widow Faerlina
	28796,--Poison Bolt Volley (N, H)
	28794,--Rain of Fire (N, H)

	--Maexxna
	28622,--Web Wrap (NH)
	54121,--Necrotic Poison (N, H)

	--Noth the Plaguebringer
	29213,--Curse of the Plaguebringer (N, H)
	29214,--Wrath of the Plaguebringer (N, H)
	29212,--Cripple (NH)

	--Heigan the Unclean
	29998,--Decrepit Fever (N, H)
	29310,--Spell Disruption (NH)

	--Grobbulus
	28169,--Mutating Injection (NH)

	--Gluth
	54378,--Mortal Wound (NH)
	29306,--Infected Wound (NH)

	--Thaddius
	28084,--Negative Charge (N, H)
	28059,--Positive Charge (N, H)

	--Instructor Razuvious
	55550,--Jagged Knife (NH)

	--Sapphiron
	28522,--Icebolt (NH)
	28542,--Life Drain (N, H)

	--Kel'Thuzad
	28410,--Chains of Kel'Thuzad (H)
	27819,--Detonate Mana (NH)
	27808,--Frost Blast (NH)

-- "The Eye of Eternity"
	--Malygos
	56272,--Arcane Breath (N, H)
	57407,--Surge of Power (N, H)

-- "The Obsidian Sanctum"
	--Trash
	39647,--Curse of Mending
	58936,--Rain of Fire

	--Sartharion
	60708,--Fade Armor (N, H)
	57491,--Flame Tsunami (N, H)

-- "Ulduar"
	--Trash
	62310,--Impale (N, H)
	63612,--Lightning Brand (N, H)
	63615,--Ravage Armor (NH)
	62283,--Iron Roots (N, H)
	63169,--Petrify Joints (N, H)

	--Razorscale
	64771,--Fuse Armor (NH)

	--Ignis the Furnace Master
	62548,--Scorch (N, H)
	62680,--Flame Jet (N, H)
	62717,--Slag Pot (N, H)

	--XT-002
	63024,--Gravity Bomb (N, H)
	63018,--Light Bomb (N, H)

	--The Assembly of Iron
	61888,--Overwhelming Power (N, H)
	62269,--Rune of Death (N, H)
	61903,--Fusion Punch (N, H)
	61912,--Static Disruption(N, H)

	--Kologarn
	64290,--Stone Grip (N, H)
	63355,--Crunch Armor (N, H)
	62055,--Brittle Skin (NH)

	--Hodir
	62469,--Freeze (NH)
	61969,--Flash Freeze (N, H)
	62188,--Biting Cold (NH)

	--Thorim
	62042,--Stormhammer (NH)
	62130,--Unbalancing Strike (NH)
	62526,--Rune Detonation (NH)
	62470,--Deafening Thunder (NH)
	62331,--Impale (N, H)

	--Freya
	62532,--Conservator's Grip (NH)
	62589,--Nature's Fury (N, H)
	62861,--Iron Roots (N, H)

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
	64125,--Squeeze (N, H)
	64156,--Apathy (H)
	64157,--Curse of Doom (H)
	--63050,--Sanity(NH)

	--Algalon
	64412,--Phase Punch

-- "Trial of the Crusader"
	--Gormok the Impaler
	66331,--Impale
	66406,--Snobolled!

	--Acidmaw --Dreadscale
	66819,--Acidic Spew
	66821,--Molten Spew
	66823,--Paralytic Toxin
	66869,--Burning Bile

	--Icehowl
	66770,--Ferocious Butt
	66689,--Arctic Breathe
	66683,--Massive Crash

	--Lord Jaraxxus
	66532,--Fel Fireball 
	66237,--Incinerate Flesh 
	66242,--Burning Inferno
	66197,--Legion Flame
	66199,--Legion Flame
	66877,--Legion Flame
	66283,--Spinning Pain Spike
	66209,--Touch of Jaraxxus(H)
	66211,--Curse of the Nether(H)
	66333, 66334, 66335, 66336, 68156,--Mistress' Kiss (10H, 25H)

	--Faction Champions
	65812,--Unstable Affliction
	65801,--Polymorph
	65543,--Psychic Scream
	66054,--Hex
	65809,--Fear

	--The Twin Val'kyr
	67176,--Dark Essence
	67223,--Light Essence
	67282,--Dark Touch
	67297,--Light Touch
	67309,--Twin Spike

	--Anub'arak
	67574,--Pursued by Anub'arak
	66013,--Penetrating Cold (10, 25, 10H, 25H)
	67847,--Expose Weakness
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
	72491,--Necrotic Strike

	--Gunship Battle
	69651,--Wounding Strike

	--Deathbringer Saurfang
	72293,--Mark of the Fallen Champion
	72442,--Boiling Blood
	72449,--Rune of Blood
	72769,--Scent of Blood (heroic)

	--Festergut
	69290,--Blighted Spore
	69248,--Vile Gas?
	71218,--Vile Gas?
	72219,--Gastric Bloat
	69278, -- Gas Spore

	--Rotface
	69674,--Mutated Infection
	69508,--Slime Spray
	69774,--Sticky Ooze

	--Professor Putricide
	70672,--Gaseous Bloat
	72549,--Malleable Goo
	72454,--Mutated Plague
	70341,--Slime Puddle (Spray)
	70342,--Slime Puddle (Pool)
	70911,--Unbound Plague
	69774,--Volatile Ooze Adhesive

	--Blood Prince Council
	71807,--Glittering Sparks
	71911,--Shadow Resonance

	--Blood-Queen Lana'thel
	71623,--Delirious Slash
	70949,--Essence of the Blood Queen (hand icon)
	70867,--Essence of the Blood Queen (bite icon)
	72151,--Frenzied Bloodthirst (bite icon)
	71474,--Frenzied Bloodthirst (red bite icon)
	71340,--Pact of the Darkfallen
	72985,--Swarming Shadows (pink icon)
	71267,--Swarming Shadows (black purple icon)
	71264,--Swarming Shadows (swirl icon)
	70923,--Uncontrollable Frenzy

	--Valithria Dreamwalker
	70873,--Emerald Vigor
	70744,--Acid Burst
	70751,--Corrosion
	70633,--Gut Spray

	--Sindragosa
	70106,--Chilled to the Bone
	69766,--Instability
	69762,--Unchained Magic
	70126,--Frost Beacon
	71665,--Asphyxiation
	70127,--Mystic Buffet

	--Lich King
	70541,--Infest
	70337,--Necrotic Plague
	72133,--Pain and Suffering
	68981,--Remorseless Winter
	69242,--Soul Shriek

	--Trash
	71089,--Bubbling Pus
	69483,--Dark Reckoning
	71163,--Devour Humanoid
	71127,--Mortal Wound
	70435,--Rend Flesh
	
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
-- Firelands
	-- Beth'tilac
	99506,	-- Widows Kiss
	97202,	-- Fiery Web Spin
	49026,	-- Fixate
	97079,	-- Seeping Venom
	-- Lord Rhyolith
	98492,	-- Eruption
	-- Alysrazor
	101296,	-- Fieroblast
	100723,	-- Gushing Wound
	99389,	-- Imprinted
	101729,	-- Blazing Claw
	100640,	-- Harsh Winds
	100555,	-- Smouldering Roots
	-- Shannox
	99837,	-- Crystal Prison
	99937,	-- Jagged Tear
	-- Baleroc
	99403,	-- Tormented
	99256,	-- Torment
	99252,	-- Blaze of Glory
	99516,	-- Countdown
	-- Majordomo Staghelm
	98450,	-- Searing Seeds
	-- Ragnaros
	99399,	-- Burning Wound
	100293,	-- Lava Wave
	98313,	-- Magma Blast
	100675,	-- Dreadflame
	99145,	-- Blazing Heat
	100249,	-- Combustion
	99613,	-- Molten Blast
	-- Trash
	99532,	-- Melt Armor
-- Other
	67479,	-- Impale
	5782,	-- Fear
	84853,	-- Dark Pool
	91325,	-- Shadow Vortex
-- Dragon Soul
	-- Morchok
	103687, -- Crush Armor
	-- Hagara the Stormbinder
	104451,  -- Ice Tomb
	105285,  -- Target (next Ice Lance)
	105316,  -- Ice Lance
	105289,  -- Shattered Ice
	105259,  -- Watery Entrenchment	
	105465,  -- Lightning Storm
	105369,  -- Lightning Conduit
	-- Warmaster Blackhorn
	109204, -- Twilight Barrage
	108046, -- Shockwave
	108043, -- Devastate
	107567, -- Brutal strike
	107558, -- Degeneration
	110214, -- Consuming Shroud
	-- Ultraxion
	110068, -- Fading light 
	106108, -- Heroic will
	106415, -- Twilight burst
	105927, -- Faded Into Twilight
	106369, -- Twilight shift
	-- Yor'sahj the Unsleeping
	104849, -- Void bolt
	109389, -- Deep Corruption
	-- Warlord Zon'ozz
	103434, -- Disrupting shadows
	110306, -- Black Blood of Go'rath
	-- Spine of Deathwing
	105563, -- Grasping Tendrils
	105490, -- Fiery Grip
	105479, -- Searing Plasma
	106199, -- Blood corruption: death
	106200, -- Blood corruption: earth
	106005, -- Degradation
	-- Madness of Deathwing
	109603, -- Tetanus
	109632, -- Impale
	106794, -- Shrapnel
	106385, -- Crush
	105841, -- Degenerative bite
	105445, -- Blistering heat
} do
    local spell = GetSpellInfo(v)
    if spell then
        ns.raid_debuffs[spell] = k+10
    end
end

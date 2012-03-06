--[[
    Copyright (c) 2010-2011 yaroot(@gmail.com)

    You can do whatever you want with this file, and if you find it
    useful, you can buy me a beer if we meet someday.
--]]

--[=[
    .icon                   [texture]
    .count                  [fontstring]
    .cd                     [cooldown]

    .ShowBossDebuff         [boolean]
    .BossDebuffPriority     [number]

    .ShowDispelableDebuff   [boolean]
    .DispelPriority         [table]     { [type] = prio }
    .DispelFilter           [table]     { [type] = true }
    .DebuffTypeColor        [table]     { [type] = { r, g, b } }

    .Debuffs                [table]     { [name(string)|id(number)] = prio(number) }
    .MatchBySpellName       [boolean]

    .SetDebuffTypeColor     [function]  function(r, g, b) end
--]=]


local _, ns = ...
local oUF = ns.oUF or oUF
assert(oUF, 'oUF RaidDebuffs: unable to locate oUF')

local bossDebuffPrio = 9999999
local invalidPrio = -1
local auraFilters = {
    ['HARMFUL'] = true,
}

local debuffTypeColor = {
    ['none'] = {0, 0, 0},
}
for k, v in next, DebuffTypeColor do
    if(k ~= '' and k ~= 'none') then
        debuffTypeColor[k] = { v.r, v.g, v.b }
    end
end

local dispelPrio = {
    ['Magic']   = 4,
    ['Curse']   = 3,
    ['Disease'] = 2,
    ['Poison']  = 1,
}

local dispelFilter = ({
    PIREST = { Magic = true, Disease = true, },
    SHAMAN = { Magic = true, Curse = true, },
    PALADIN = { Magic = false, Poison = true, Disease = true, },
    MAGE = { Curse = true, },
    DRUID = { Magic = true, Curse = true, Poison = true, },
})[select(2, UnitClass'player')]

local UpdateDebuffFrame = function(rd)
    if(rd.PreUpdate) then
        rd:PreUpdate()
    end

    if(rd.index and rd.type and rd.filter) then
        local name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId, canApplyAura, isBossDebuff, value1, value2, value3 = UnitAura(rd.__owner.unit, rd.index, rd.filter)

        if(rd.icon) then
            rd.icon:SetTexture(icon)
            rd.icon:Show()
        end

        if(rd.count) then
            if count and (count > 0) then
                rd.count:SetText(count)
                rd.count:Show()
            else
                rd.count:Hide()
            end
        end

        if(rd.cd) then
            if(duration and (duration > 0)) then
                rd.cd:SetCooldown(expirationTime - duration, duration)
                rd.cd:Show()
            else
                rd.cd:Hide()
            end
        end

        if(rd.SetDebuffTypeColor) then
            local colors = rd.DebuffTypeColor or debuffTypeColor
            local c = colors[debuffType] or colors.none or debuffTypeColor.none
            rd:SetDebuffTypeColor(unpack(c))
        end

        if(not rd:IsShown()) then
            rd:Show()
        end
    else
        if(rd:IsShown()) then
            rd:Hide()
        end
    end

    if(rd.PostUpdate) then
        rd:PostUpdate()
    end
end

local Update = function(self, event, unit)
    if(unit ~= self.unit) then return end
    local rd = self.RaidDebuffs
    rd.priority = invalidPrio

    for filter in next, (rd.Filters or auraFilters) do
        local i = 0
        while(true) do
            i = i + 1
            local name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId, canApplyAura, isBossDebuff, value1, value2, value3 = UnitAura(unit, i, filter)
            if (not name) then break end

            if(rd.ShowBossDebuff and isBossDebuff) then
                local prio = rd.BossDebuffPriority or bossDebuffPrio
                if(prio and prio > rd.priority) then
                    rd.priority = prio
                    rd.index = i
                    rd.type = 'Boss'
                    rd.filter = filter
                end
            end

            if(rd.ShowDispelableDebuff and debuffType) then
                local disPrio = rd.DispelPriority or dispelPrio
                local disFilter = rd.DispelFilter or dispelFilter
                local prio

                if(rd.FilterDispelableDebuff and disFilter) then
                    prio = disFilter[debuffType] and disPrio[debuffType]
                else
                    prio = disPrio[debuffType]
                end

                if(prio and (prio > rd.priority)) then
                    rd.priority = prio
                    rd.index = i
                    rd.type = 'Dispel'
                    rd.filter = filter
                end
            end

            local prio = rd.Debuffs and rd.Debuffs[rd.MatchBySpellName and name or spellId]
            if(prio and (prio > rd.priority)) then
                rd.priority = prio
                rd.index = i
                rd.type = 'Custom'
                rd.filter = filter
            end
        end
    end

    if(rd.priority == invalidPrio) then
        rd.index = nil
        rd.filter = nil
        rd.type = nil
    end

    return (rd.OverrideUpdateFrame or UpdateDebuffFrame) ( rd )
end

local f

local searchFor = function(spell, i)
    local spellName = GetSpellInfo(spell)
    local found
    for j = 1, GetNumSpellTabs() do
        for k = 1, GetNumTalents(j) do
            local talentName, _, _, _, rank = GetTalentInfo(j, k)
            if(talentName and talentName == spellName) then
                return rank and rank > 0
            end
        end
    end
end

local talentTbl = ({
    PALADIN = {
        [53551] = 'Magic',
    },
    SHAMAN = {
        [77130] = 'Magic',
    },
    DRUID = {
        [88423] = 'Magic',
    },
})[select(2, UnitClass'player')]

local spellCheck = function()
    local _, class = UnitClass'player'
    if(talentTbl) then
        for k, v in next, talentTbl do
            dispelFilter[v] = searchFor(k)
        end
    end
end

local Path = function(self, ...)
    return (self.RaidDebuffs.Override or Update) (self, ...)
end

local ForceUpdate = function(element)
    return Path(element.__owner, 'ForceUpdate', element.__owner.unit)
end

local Enable = function(self)
    local rd = self.RaidDebuffs
    if(rd) then
        self:RegisterEvent('UNIT_AURA', Path)
        rd.ForceUpdate = ForceUpdate
        rd.__owner = self

        if(talentTbl and (not f) and (not rd.DispelFilter) and (not rd.Override)) then
            f = CreateFrame'Frame'
            f:SetScript('OnEvent', spellCheck)
            f:RegisterEvent('PLAYER_TALENT_UPDATE')
            f:RegisterEvent('CHARACTER_POINTS_CHANGED')
            spellCheck()
        end

        return true
    end
end

local Disable = function(self)
    if(self.RaidDebuffs) then
        self:UnregisterEvent('UNIT_AURA', Path)
        self.RaidDebuffs:Hide()
        self.RaidDebuffs.__owner = nil
    end
end

oUF:AddElement('RaidDebuffs', Update, Enable, Disable)
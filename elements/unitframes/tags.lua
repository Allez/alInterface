local _, ns = ...
oUF = ns.oUF or oUF

local format = string.format
local gsub = string.gsub

local hex = function(r, g, b)
	if type(r) == 'table' then
		if r.r then r, g, b = r.r, r.g, r.b else r, g, b = unpack(r) end
	end
	return ('|cff%02x%02x%02x'):format(r * 255, g * 255, b * 255)
end

local truncate = function(value)
	if(value >= 1e6) then
		return ('%.2fm'):format(value / 1e6):gsub('%.?0+([km])$', '%1')
	elseif(value >= 1e4) then
		return ('%.1fk'):format(value / 1e3):gsub('%.?0+([km])$', '%1')
	else
		return value
	end
end

local utf8sub = function(string, i, dots)
	local bytes = string:len()
	if (bytes <= i) then
		return string
	else
		local len, pos = 0, 1
		while(pos <= bytes) do
			len = len + 1
			local c = string:byte(pos)
			if (c > 0 and c <= 127) then
				pos = pos + 1
			elseif (c >= 192 and c <= 223) then
				pos = pos + 2
			elseif (c >= 224 and c <= 239) then
				pos = pos + 3
			elseif (c >= 240 and c <= 247) then
				pos = pos + 4
			end
			if (len == i) then break end
		end

		if (len == i and pos <= bytes) then
			return string:sub(1, pos - 1)..(dots and "..." or "")
		else
			return string
		end
	end
end

local getClassColor = function(unit)
	local t
	if UnitIsTapped(unit) and not UnitIsTappedByPlayer(unit) then
		t = oUF.colors.tapped
	elseif UnitIsPlayer(unit) then
		local _, class = UnitClass(unit)
		t = oUF.colors.class[class]
	elseif UnitReaction(unit, 'player') then
		t = oUF.colors.reaction[UnitReaction(unit, "player")]
	end
	return t
end


oUF.TagEvents['allez:health'] = "UNIT_HEALTH UNIT_MAXHEALTH"
oUF.Tags['allez:health'] = function(unit)
	local min, max = UnitHealth(unit), UnitHealthMax(unit)
	local status = not UnitIsConnected(unit) and 'Offline' or UnitIsGhost(unit) and 'Ghost' or UnitIsDead(unit) and 'Dead'
	return status and status or min ~= max and ('|cffff8080%s|r %d|cff0090ff%%|r'):format(truncate(min), min / max * 100) or max
end

oUF.TagEvents['raidname'] = 'UNIT_NAME_UPDATE UNIT_REACTION UNIT_FACTION UNIT_HEALTH'
oUF.Tags['raidname'] = function(unit)
	local unitname = not UnitIsConnected(unit) and 'Off' or UnitIsGhost(unit) and 'Ghost' or UnitIsDead(unit) and 'Dead' or utf8sub(UnitName(unit), 4, false)
	return unitname
end

oUF.TagEvents['raidnameclass'] = 'UNIT_NAME_UPDATE UNIT_REACTION UNIT_FACTION UNIT_HEALTH'
oUF.Tags['raidnameclass'] = function(unit)
	local unitname = not UnitIsConnected(unit) and 'Off' or UnitIsGhost(unit) and 'Ghost' or UnitIsDead(unit) and 'Dead' or utf8sub(UnitName(unit), 4, false)
	return ('%s%s|r'):format(hex(getClassColor(unit) or {1, 1, 1}), unitname or '')
end

oUF.TagEvents['allez:name'] = 'UNIT_NAME_UPDATE UNIT_REACTION UNIT_FACTION UNIT_HEALTH'
oUF.Tags['allez:name'] = function(unit)
	return ('%s%s|r'):format(hex(getClassColor(unit) or {1, 1, 1}), UnitName(unit) or '')
end

oUF.TagEvents['allez:power'] = "UNIT_POWER UNIT_MAXPOWER"
oUF.Tags['allez:power'] = function(unit)
	local _, str = UnitPowerType(unit)
	return UnitPower(unit)--('%s%d|r'):format(hex(colors.power[str] or {1, 1, 1}), UnitPower(unit) or '')
end

oUF.TagEvents['allez:druid'] = "UNIT_POWER UPDATE_SHAPESHIFT_FORM"
oUF.Tags['allez:druid'] = function(unit)
	local min, max = UnitPower(unit, 0), UnitPowerMax(unit, 0)
	if UnitPowerType(unit) ~= 0 and min ~= max then
		return ('|cff0090ff%d%%|r '):format(min / max * 100)
	end
end

oUF.TagEvents['allez:level'] = "UNIT_LEVEL PLAYER_LEVEL_UP"
oUF.Tags['allez:level'] = function(unit)
	local level = UnitLevel(unit)
	local diffColor = level < 0 and {r = 1, g = 0, b = 0} or GetQuestDifficultyColor(UnitLevel(unit))
	return ('%s%s|r'):format(hex(diffColor), oUF.Tags['smartlevel'](unit))
end

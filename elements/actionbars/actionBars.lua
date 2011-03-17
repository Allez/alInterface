
local defaults = {
	[1] = {pos = {"BOTTOM", 0, 11}, rows = 1},
	[2] = {pos = {"BOTTOM", 0, 41}, rows = 1},
	[3] = {pos = {"BOTTOM", 0, 71}, rows = 1},
	[4] = {pos = {"RIGHT", -11, 0}, rows = 12},
	[5] = {pos = {"RIGHT", -41, 0}, rows = 12},
}

local GetButton = function(id)
	if id <= 12 then
		return _G['ActionButton' .. id]
	elseif id <= 24 then
		return _G['MultiBarBottomLeftButton' .. (id-12)]
	elseif id <= 36 then
		return _G['MultiBarBottomRightButton' .. (id-24)]
	elseif id <= 48 then
		return _G['MultiBarRightButton' .. (id-36)]
	elseif id <= 60 then
		return _G['MultiBarLeftButton' .. (id-48)]
	end
end

local Page = {
	["DRUID"] = "[bonusbar:1,nostealth] 7; [bonusbar:1,stealth] 8; [bonusbar:2] 8; [bonusbar:3] 9; [bonusbar:4] 10;",
	["WARRIOR"] = "[bonusbar:1] 7; [bonusbar:2] 8; [bonusbar:3] 9;",
	["PRIEST"] = "[bonusbar:1] 7;",
	["ROGUE"] = "[bonusbar:1] 7; [bonusbar:2] 7;",
	["DEFAULT"] = "[bonusbar:5] 11; [bar:2] 2; [bar:3] 3; [bar:4] 4; [bar:5] 5; [bar:6] 6;",
}

local GetBar = function()
	local condition = Page["DEFAULT"]
	local class = select(2, UnitClass('player'))
	local page = Page[class]
	if page then
		condition = condition.." "..page
	end
	condition = condition.." 1"
	return condition
end

local SetPaging = function(bar)
	bar:RegisterEvent("PLAYER_LOGIN")
	bar:RegisterEvent("PLAYER_TALENT_UPDATE")
	bar:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
	bar:SetScript("OnEvent", function(self, event, ...)
		if event == "PLAYER_LOGIN" then
			local button
			for i = 1, NUM_ACTIONBAR_BUTTONS do
				button = _G["ActionButton"..i]
				self:SetFrameRef("ActionButton"..i, button)
			end	
			self:Execute([[
				buttons = table.new()
				for i = 1, 12 do
					table.insert(buttons, self:GetFrameRef("ActionButton"..i))
				end
			]])
			self:SetAttribute("_onstate-page", [[ 
				for i, button in ipairs(buttons) do
					button:SetAttribute("actionpage", tonumber(newstate))
				end
			]])
			RegisterStateDriver(self, "page", GetBar())
		else
			if not InCombatLockdown() then
				RegisterStateDriver(self, "page", GetBar())
			end
		end
	end)
end

for i = 1, 5 do
	local bar = CreateBar("uiActionBar"..i)
	bar:SetPoint(unpack(defaults[i].pos))
	bar.id = i
	bar.split = i==3
	bar.rows = defaults[i].rows
	if i == 1 then SetPaging(bar) end
	bar.buttons = {}
	for n = 1, 12 do
		tinsert(bar.buttons, GetButton((i-1)*12+n))
	end
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:SetScript("OnEvent", function(self, event)
	self:UnregisterEvent(event)
	for i = 1, 12 do
		local button = GetButton(i)
		button:SetAttribute("showgrid", 1)
		button:SetParent(UIParent)
		ActionButton_ShowGrid(button)
	end
end)
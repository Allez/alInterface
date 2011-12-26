
UISavedPositions = {}
UIMovableFrames = {}

local moving = false
local movers = {}

local SetPosition = function(mover)
	local ap, _, rp, x, y = mover:GetPoint()
	UISavedPositions[mover.frame:GetName()] = {ap, "UIParent", rp, x, y}
end

local OnDragStart = function(self)
	self:StartMoving()
	self.frame:ClearAllPoints()
	self.frame:SetAllPoints(self)
end

local OnDragStop = function(self)
	self:StopMovingOrSizing()
	SetPosition(self)
end

local CreateMover = function(frame)
	local mover = CreateFrame("Frame", nil, UIParent)
	mover:SetBackdrop({
		bgFile = [=[Interface\ChatFrame\ChatFrameBackground]=],
		--edgeFile = [=[Interface\ChatFrame\ChatFrameBackground]=], edgeSize = 1,
		insets = {top = -2, left = -2, bottom = -2, right = -2},
	})
	mover:SetBackdropColor(0.2, 0.2, 0.5, 0.7)
	mover:SetAllPoints(frame)
	mover:SetFrameStrata("TOOLTIP")
	mover:EnableMouse(true)
	mover:SetMovable(true)
	mover:RegisterForDrag("LeftButton")
	mover:SetScript("OnDragStart", OnDragStart)
	mover:SetScript("OnDragStop", OnDragStop)
	mover.frame = frame
	mover.name = mover:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	mover.name:SetFont(GameFontNormal:GetFont())
	mover.name:SetPoint("CENTER")
	mover.name:SetTextColor(1, 1, 1)
	mover.name:SetText(frame:GetName())
	movers[frame:GetName()] = mover
end

local GetMover = function(frame)
	if movers[frame:GetName()] then
		return movers[frame:GetName()]
	else
		return CreateMover(frame)
	end
end

StaticPopupDialogs["MOVE_UI"] = {
	text = "Reload UI to save changes?", 
	button1 = ACCEPT, 
	button2 = CANCEL,
	OnAccept = ReloadUI,
	timeout = 0, 
	whileDead = 1,
	hideOnEscape = 1, 
}

local InitMove = function(msg)
	if InCombatLockdown() then print(ERR_NOT_IN_COMBAT) return end
	if msg and msg == 'reset' then
		UISavedPositions = {}
		ReloadUI()
		return
	end
	if not moving then
		for i, v in pairs(UIMovableFrames) do
			local mover = GetMover(v)
			if mover then mover:Show() end
		end
		moving = true
	else
		for i, v in pairs(movers) do
			v:Hide()
		end
		moving = false
		StaticPopup_Show("MOVE_UI")
	end
end

local RestoreUI = function(self)
	if InCombatLockdown() then
		if not self.shedule then self.shedule = CreateFrame("Frame", nil, self) end
		self.shedule:RegisterEvent("PLAYER_REGEN_ENABLED")
		self.shedule:SetScript("OnEvent", function(self)
			RestoreUI(self:GetParent())
			self:UnregisterEvent("PLAYER_REGEN_ENABLED")
			self:SetScript("OnEvent", nil)
		end)
		return
	end
	for frame_name, point in pairs(UISavedPositions) do
		if _G[frame_name] then
			_G[frame_name]:ClearAllPoints()
			_G[frame_name]:SetPoint(unpack(point))
		end
	end
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("PLAYER_REGEN_DISABLED")
frame:SetScript("OnEvent", function(self, event)
	if event == "PLAYER_ENTERING_WORLD" then
		self:UnregisterEvent(event)
		RestoreUI(self)
	elseif event == "PLAYER_REGEN_DISABLED" and moving then
		print(ERR_NOT_IN_COMBAT)
		for i, v in pairs(movers) do
			v:Hide()
		end
		moving = false
	end
end)

SlashCmdList["MoveUI"] = InitMove
SLASH_MoveUI1 = "/moveui"
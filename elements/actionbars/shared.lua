
local config = {
	general = {
		buttonsize = {
			order = 1,
			value = 23,
			type = "range",
			min = 12,
			max = 70,
		},
		spacing = {
			order = 2,
			value = 7,
			type = "range",
			min = 0,
			max = 30,
		},
		hidemacro = {
			order = 3,
			value = true,
		},
		hidehotkey = {
			order = 4,
			value = false,
		},
	},
	colors = {
		checked = {
			order = 1,
			type = "color",
			value = {0, 144, 255},
		},
		equipped = {
			order = 2,
			type = "color",
			value = {0, 0.5, 0},
		},
		hover = {
			order = 3,
			type = "color",
			value = {144, 255, 0},
		},
		outofmana = {
			order = 4,
			type = "color",
			value = {0.1, 0.3, 1},
		},
		outofrange = {
			order = 5,
			type = "color",
			value = {0.8, 0.1, 0.1},
		},
		unusable = {
			order = 6,
			type = "color",
			value = {0.4, 0.4, 0.4},
		},
	},
}

local cfg = {}
UIConfigGUI.actionbars = config
UIConfig.actionbars = cfg

local bars = {}

SetButtons = function(bar)
	local size = bar.bsize or cfg.general.buttonsize
	local spacing = cfg.general.spacing
	local cols = math.ceil(#bar.buttons/bar.rows)
	for i, button in pairs(bar.buttons) do
		local row = math.ceil(bar.rows * i / #bar.buttons)
		local col = (i - 1) % cols + 1
		button:ClearAllPoints()
		button:SetWidth(size)
		button:SetHeight(size)
		button:SetPoint("TOPLEFT", bar, "TOPLEFT", (size+spacing)*(col-1), -(size+spacing)*(row-1))
	end
	bar:SetWidth((size+spacing)*cols-spacing)
	bar:SetHeight((size+spacing)*bar.rows-spacing)
end

CreateBar = function(name)
	local bar = CreateFrame("Frame", name, UIParent, "SecureHandlerStateTemplate")
	bar:SetBackdrop({
		bgFile = [=[Interface\ChatFrame\ChatFrameBackground]=],
		insets = {top = 0, left = 0, bottom = 0, right = 0},
	})
	bar:SetBackdropColor(0, 0, 0, 0)
	tinsert(bars, bar)
	if UIMovableFrames then tinsert(UIMovableFrames, bar) end
	return bar
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:SetScript("OnEvent", function(self, event)
	self:UnregisterEvent(event)
	for _, bar in pairs(bars) do
		SetButtons(bar)
	end
end)

for _, v in pairs({
	MultiBarBottomLeft,
	MultiBarBottomRight,
	MultiBarLeft,
	MultiBarRight,
	PetActionBarFrame,
	ShapeshiftBarFrame,
	ExtraActionBarFrame,
	MultiCastActionBarFrame,
}) do
	v:SetParent(UIParent)
	v:SetWidth(0.01)
end

for _, obj in pairs({
	SlidingActionBarTexture0,
	SlidingActionBarTexture1,
	BonusActionBarFrameTexture0,
	BonusActionBarFrameTexture1,
	BonusActionBarFrame,
	ShapeshiftBarLeft,
	ShapeshiftBarRight,
	ShapeshiftBarMiddle,
	MainMenuBar,
	VehicleMenuBar,
	PossessBarFrame,
}) do
	if obj:GetObjectType() == 'Texture' then
		obj:SetTexture("")
	else
		obj:SetScale(0.001)
		obj:SetAlpha(0)
	end
end

SlashCmdList["alBars"] = function(msg)
	if not move then
		for _, bar in pairs(bars) do
			bar.strata = bar:GetFrameStrata()
			bar:SetFrameStrata("TOOLTIP")
			bar:SetBackdropColor(0, 0.9, 0, 0.4)
			bar:EnableMouse(true)
			
		end
		move = true
	else
		for _, bar in pairs(bars) do
			bar:EnableMouse(false)
			bar:SetFrameStrata(bar.strata)
			bar:SetBackdropColor(0, 0, 0, 0)
			
		end
		move = false
	end
end
SLASH_alBars1 = "/ab"
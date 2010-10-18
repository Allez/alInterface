if not IsAddOnLoaded("DBM-Core") then return end

local backdrop = {
	bgFile = [=[Interface\ChatFrame\ChatFrameBackground]=],
	edgeFile = [=[Interface\ChatFrame\ChatFrameBackground]=], edgeSize = 1,
	insets = {top = 0, left = 0, bottom = 0, right = 0},
}

local CreateBG = function(parent)
	local bg = CreateFrame("Frame", nil, parent)
	bg:SetPoint("TOPLEFT", parent, "TOPLEFT", -1, 1)
	bg:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", 1, -1)
	bg:SetFrameLevel(parent:GetFrameLevel() - 1)
	bg:SetBackdrop(backdrop)
	bg:SetBackdropColor(0, 0, 0, 0.4)
	bg:SetBackdropBorderColor(0, 0, 0, 1)
	return bg
end

local SkinBars = function(self)
	for bar in self:GetBarIterator() do
		if not bar.injected then
			bar.ApplyStyle=function()
				local frame = bar.frame
				local tbar = _G[frame:GetName().."Bar"]
				local spark = _G[frame:GetName().."BarSpark"]
				local texture = _G[frame:GetName().."BarTexture"]
				local icon1 = _G[frame:GetName().."BarIcon1"]
				local icon2 = _G[frame:GetName().."BarIcon2"]
				local name = _G[frame:GetName().."BarName"]
				local timer = _G[frame:GetName().."BarTimer"]

				if icon1 then
					icon1:SetSize(15, 15)
				end

				if icon2 then
					icon2:SetSize(15, 15)
				end

				if not frame.styled then
					frame:SetScale(1)
					frame:SetSize(150, 15)
					frame.background = CreateBG(frame)
					frame.styled=true
				end

				if not tbar.styled then
					tbar:SetAllPoints(frame)
					frame.styled=true
				end

				if not spark.killed then
					spark:SetAlpha(0)
					spark:SetTexture(nil)
					spark.killed=true
				end

				if not icon1.styled then
					icon1:SetTexCoord(0.07, 0.93, 0.07, 0.93)
					icon1.frame = CreateFrame("Frame", nil, tbar)
					icon1.frame:SetFrameStrata("BACKGROUND")
					icon1.frame:SetAllPoints(icon1)
					icon1.frame.background = CreateBG(icon1.frame)
					icon1.styled=true
				end

				if not icon2.styled then
					icon2:SetTexCoord(0.07, 0.93, 0.07, 0.93)
					icon2.frame = CreateFrame("Frame", nil, tbar)
					icon2.frame:SetFrameStrata("BACKGROUND")
					icon2.frame:SetAllPoints(icon2)
					icon2.frame.background = CreateBG(icon2.frame)
					icon2.styled=true
				end

				if not texture.styled then
					texture:SetTexture("Interface\\TargetingFrame\\UI-StatusBar")
					texture.styled=true
				end

				if not name.styled then
					name:SetFont('Fonts\\VisitorR.TTF', 10, "OUTLINEMONOCHROME")
					name:SetShadowOffset(0, 0)
					name.SetFont = function() end
					name.styled=true
				end

				if not timer.styled then	
					timer:SetFont('Fonts\\VisitorR.TTF', 10, "OUTLINEMONOCHROME")
					timer:SetShadowOffset(0, 0)
					timer.SetFont = function() end
					timer.styled=true
				end

				frame:Show()
				bar:Update(0)
				bar.injected=true
			end
			bar:ApplyStyle()
		end
	end
end

local UploadDBM = function()
	DBM_SavedOptions.Enabled = true
	DBM_SavedOptions.ShowMinimapButton = false
	DBM_SavedOptions.WarningIconLeft = false
	DBM_SavedOptions.WarningIconRight = false
	DBM_SavedOptions.RangeFrameX = 244
	DBM_SavedOptions.RangeFramePoint = "LEFT"
	DBM_SavedOptions.ShowSpecialWarnings = true

	DBT_SavedOptions["DBM"].Scale = 1
	DBT_SavedOptions["DBM"].HugeScale = 1
	DBT_SavedOptions["DBM"].BarXOffset = 0
	DBT_SavedOptions["DBM"].BarYOffset = 5
	DBT_SavedOptions["DBM"].Font = 'Fonts\\VisitorR.TTF'
	DBT_SavedOptions["DBM"].FontSize = 10
	DBT_SavedOptions["DBM"].Width = 150
	DBT_SavedOptions["DBM"].TimerX = 28
	DBT_SavedOptions["DBM"].TimerY = 250
	DBT_SavedOptions["DBM"].TimerPoint = "BOTTOMLEFT"
	DBT_SavedOptions["DBM"].FillUpBars = true
	DBT_SavedOptions["DBM"].IconLeft = true
	DBT_SavedOptions["DBM"].ExpandUpwards = true
	DBT_SavedOptions["DBM"].Texture = "Interface\\TargetingFrame\\UI-StatusBar"
	DBT_SavedOptions["DBM"].IconRight = false
	DBT_SavedOptions["DBM"].HugeBarXOffset = 0
	DBT_SavedOptions["DBM"].HugeBarsEnabled = false
end

hooksecurefunc(DBT, "CreateBar", SkinBars)

local frame = CreateFrame("Frame")
frame:RegisterEvent('PLAYER_LOGIN')
frame:SetScript('OnEvent', function(self, event)
	UploadDBM()
end)

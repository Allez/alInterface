if not IsAddOnLoaded("DBM-Core") then return end

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
					icon1:SetPoint("RIGHT", frame, "LEFT", -3, 0)
				end

				if icon2 then
					icon2:SetSize(15, 15)
					icon2:SetPoint("LEFT", frame, "RIGHT", 5, 0)
				end

				if not frame.styled then
					frame:SetScale(1)
					frame:SetHeight(15)
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
					CreateFS(nil, nil, nil, nil, name)
					name.SetFont = function() end
					name.styled=true
				end

				if not timer.styled then	
					CreateFS(nil, nil, nil, nil, timer)
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

hooksecurefunc(DBT, "CreateBar", SkinBars)


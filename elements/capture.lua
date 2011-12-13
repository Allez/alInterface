
-- Skin Capture Bar

local anchorframe = CreateFrame("Frame", "Capture Bar", UIParent)
anchorframe:SetSize(130, 15)
anchorframe:SetPoint("TOP", 0, -130)
if UIMovableFrames then tinsert(UIMovableFrames, anchorframe) end

local CaptureUpdate = function()
	for i = 1, NUM_EXTENDED_UI_FRAMES do
		local bar = _G["WorldStateCaptureBar"..i]

		if bar and bar:IsVisible() then
			bar:ClearAllPoints()
			if i == 1 then
				bar:SetPoint("TOP", anchorframe, "TOP")
			else
				bar:SetPoint("TOPLEFT", _G["WorldStateCaptureBar"..i-1], "BOTTOMLEFT", 0, -7)
			end

			if not bar.skinned then
				local name = bar:GetName()

				left = _G[name.."LeftBar"]
				right = _G[name.."RightBar"]
				middle = _G[name.."MiddleBar"]
				_G[name.."LeftLine"]:SetAlpha(0)
				_G[name.."RightLine"]:SetAlpha(0)
				_G[name.."LeftIconHighlight"]:SetAlpha(0)
				_G[name.."RightIconHighlight"]:SetAlpha(0)
				left:SetTexture("Interface\\TargetingFrame\\UI-StatusBar")
				right:SetTexture("Interface\\TargetingFrame\\UI-StatusBar")
				middle:SetTexture("Interface\\TargetingFrame\\UI-StatusBar")

				select(4, bar:GetRegions()):Hide()
				
				left:SetVertexColor(0.2, 0.6, 1)
				right:SetVertexColor(0.9, 0.2, 0.2)
				middle:SetVertexColor(0.8, 0.8, 0.8)

				bar.bg = CreateBG(bar)
				bar.bg:SetPoint("TOPLEFT", _G[name.."LeftBar"], -2, 2)
				bar.bg:SetPoint("BOTTOMRIGHT", _G[name.."RightBar"], 2, -2)

				bar.skinned = true
			end
		end
	end
end
hooksecurefunc("UIParent_ManageFramePositions", CaptureUpdate)


-- Skin Capture Bar

local CaptureUpdate = function()
	if not NUM_EXTENDED_UI_FRAMES then return end
	for i = 1, NUM_EXTENDED_UI_FRAMES do
		local bar = _G["WorldStateCaptureBar"..i]

		if bar and bar:IsVisible() and not bar.skinned then
			local name = bar:GetName()

			_G[name.."LeftLine"]:SetAlpha(0)
			_G[name.."RightLine"]:SetAlpha(0)
			_G[name.."LeftIconHighlight"]:SetAlpha(0)
			_G[name.."RightIconHighlight"]:SetAlpha(0)
			_G[name.."LeftBar"]:SetTexture("Interface\\TargetingFrame\\UI-StatusBar")
			_G[name.."RightBar"]:SetTexture("Interface\\TargetingFrame\\UI-StatusBar")
			_G[name.."MiddleBar"]:SetTexture("Interface\\TargetingFrame\\UI-StatusBar")

			select(4, bar:GetRegions()):Hide()

			CreateBG(bar)
			bar.skinned = true
		end
	end
end
hooksecurefunc("UIParent_ManageFramePositions", CaptureUpdate)

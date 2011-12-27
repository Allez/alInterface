
local bar = CreateBar("uiExtraBar")
bar:SetPoint("BOTTOM", 0, 290)
bar.rows = 1
bar.buttons = {}
tinsert(bar.buttons, _G["ExtraActionButton1"])

-- hook the texture, idea by roth via WoWInterface forums
local texture = ExtraActionButton1.style
local disableTexture = function(style, texture)
	if string.sub(texture,1,9) == "Interface" then
		style:SetTexture("")
	end
end
texture:SetTexture("")
hooksecurefunc(texture, "SetTexture", disableTexture)

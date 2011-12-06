local GetFormattedTime = function(s)
	if s >= 86400 then
		return format('%dd', floor(s/86400 + 0.5))
	elseif s >= 3600 then
		return format('%dh', floor(s/3600 + 0.5))
	elseif s >= 60 then
		return format('%dm', floor(s/60 + 0.5))
	end
	return floor(s + 0.5)
end

local anchorframe = CreateFrame("Frame", "PlayerBuffs", UIParent)
anchorframe:SetSize(100, 26)
anchorframe:SetPoint("TOPRIGHT", -155, -11)
if UIMovableFrames then tinsert(UIMovableFrames, anchorframe) end

for _, frame in pairs({
	"BuffFrame",
	"TemporaryEnchantFrame",
	"ConsolidatedBuffs",
}) do
	_G[frame]:SetPoint("TOPRIGHT", anchorframe)
	_G[frame]:SetHeight(26)
end

ConsolidatedBuffs.SetPoint = function() end

local frame = CreateFrame("Frame")
frame:RegisterEvent("VARIABLES_LOADED")
frame:SetScript("OnEvent", function(self, event)
	for i = 1, 3 do
		_G["TempEnchant"..i].bg = CreateBG(_G["TempEnchant"..i])
		_G["TempEnchant"..i]:SetSize(26, 26)	
		_G["TempEnchant"..i.."Border"]:Hide()
		_G["TempEnchant"..i.."Icon"]:SetTexCoord(0.07, 0.93, 0.07, 0.93)
		_G["TempEnchant"..i.."Icon"]:SetPoint("TOPLEFT", _G["TempEnchant"..i])
		_G["TempEnchant"..i.."Icon"]:SetPoint("BOTTOMRIGHT", _G["TempEnchant"..i])
		_G["TempEnchant"..i.."Duration"]:ClearAllPoints()
		_G["TempEnchant"..i.."Duration"]:SetPoint("CENTER")
		_G["TempEnchant"..i.."Duration"]:SetFont(UIConfig.general.fonts.font, UIConfig.general.fonts.size, UIConfig.general.fonts.style)
		_G["TempEnchant"..i.."Duration"]:SetShadowOffset(0, 0)
	end
end)

local setStyle = function(bname)
	local buff     = _G[bname]
	local icon     = _G[bname.."Icon"]
	local border   = _G[bname.."Border"]
	local duration = _G[bname.."Duration"]
	local count    = _G[bname.."Count"]
	if icon and not buff.bg then
		buff.bg = CreateBG(buff)

		buff:SetHeight(26)
		buff:SetWidth(26)

		icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
		icon:SetPoint("TOPLEFT", buff, 0, 0)
		icon:SetPoint("BOTTOMRIGHT", buff, 0, 0)

		duration:ClearAllPoints()
		duration:SetPoint("CENTER", 2, 0)
		duration:SetFont(UIConfig.general.fonts.font, UIConfig.general.fonts.size, UIConfig.general.fonts.style)
		duration:SetShadowOffset(0, 0)

		count:ClearAllPoints()
		count:SetPoint("BOTTOMRIGHT", 1, 1)
		count:SetFont(UIConfig.general.fonts.font, UIConfig.general.fonts.size, UIConfig.general.fonts.style)
		count:SetShadowOffset(0, 0)
	end
	if border then border:Hide() end
end

local UpdateDuration = function(auraButton, timeLeft)
	local duration = auraButton.duration
	if SHOW_BUFF_DURATIONS == "1" and timeLeft then
		duration:SetFormattedText(GetFormattedTime(timeLeft))
		if timeLeft < BUFF_DURATION_WARNING_TIME then
			duration:SetVertexColor(1, 1, 0)
		else
			duration:SetVertexColor(1, 1, 1)
		end
		duration:Show()
	else
		duration:Hide()
	end
end

local UpdateBuffAnchors = function()
	local buff, previousBuff, aboveBuff
	local numBuffs = 0
	local slack = BuffFrame.numEnchants
	if BuffFrame.numConsolidated > 0 then
		slack = slack + 1
	end

	for i = 1, BUFF_ACTUAL_DISPLAY do
		buff = _G["BuffButton"..i]
		setStyle("BuffButton"..i)
		if buff.consolidated then	
			if buff.parent == BuffFrame then
				buff:SetParent(ConsolidatedBuffsContainer)
				buff.parent = ConsolidatedBuffsContainer
			end
		else
			numBuffs = numBuffs + 1
			index = numBuffs + slack
			if buff.parent ~= BuffFrame then
				buff.count:SetFontObject(NumberFontNormal)
				buff:SetParent(BuffFrame)
				buff.parent = BuffFrame
			end
			buff:ClearAllPoints()
			if index > 1 and mod(index, 8) == 1 then
				-- New row
				if index == 8 + 1 then
					buff:SetPoint("TOP", ConsolidatedBuffs, "BOTTOM", 2, -7)
				else
					buff:SetPoint("TOP", aboveBuff, "BOTTOM", 0, -7)
				end
				aboveBuff = buff
			elseif index == 1 then
				buff:SetPoint("TOPRIGHT", BuffFrame, "TOPRIGHT", 0, 0)
			else
				if numBuffs == 1 then
					if BuffFrame.numEnchants > 0 then
						buff:SetPoint("TOPRIGHT", "TemporaryEnchantFrame", "TOPLEFT", 0, 0)
					else
						buff:SetPoint("TOPRIGHT", ConsolidatedBuffs, "TOPLEFT", -7, 0)
					end
				else
					buff:SetPoint("TOPRIGHT", previousBuff, "TOPLEFT", -7, 0)
				end
			end
			previousBuff = buff
		end
	end
end

local function UpdateDebuffAnchors(buttonName, index)
	_G[buttonName..index]:Hide()
end

hooksecurefunc("BuffFrame_UpdateAllBuffAnchors", UpdateBuffAnchors)
hooksecurefunc("DebuffButton_UpdateAnchors", UpdateDebuffAnchors)
hooksecurefunc("AuraButton_UpdateDuration", UpdateDuration)
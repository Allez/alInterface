if not IsAddOnLoaded("Aurora") then return end

local F, C = unpack(Aurora)

F.CreateBG = function(frame)
	local f = frame
	if frame:GetObjectType() == "Texture" then f = frame:GetParent() end
	return CreateBG(f)
end

F.CreateSD = function(parent, size, r, g, b, alpha, offset)
	return
end

F.CreateBD = function(f, a)
	f:SetBackdrop({
		bgFile = "", 
		edgeFile = "", 
		edgeSize = 1, 
	})
	CreateBG(f)
end
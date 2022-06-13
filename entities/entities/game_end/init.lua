

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/hunter/plates/plate.mdl");
	self:SetMaterial("models/props_lab/warp_sheet")
end

function ENT:AcceptInput(inp, act, call)
	print(inp,act, call)
	if (string.lower(inp)=="endgame") then 
		print("CAL")
		hook.Run("EndGame", act)
	end
end



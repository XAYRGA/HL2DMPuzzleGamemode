
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()

	self:SetModel("models/hunter/plates/plate.mdl");
	self:SetMaterial("models/props_lab/warp_sheet")
	self.Entity:SetSolid(0)

	
end

function ENT:AcceptInput(  inputName,  activator, called, data ) 
	if string.lower(inputName) == "command" then
		MsgC(Color(255,0,0),tostring(self) .. "[CLIENTCOMMAND] ")
		Msg(activator)
		if data then 
			MsgC(Color(255,255,0), data .. "\n")
		end
		MsgN("")
		local cxtab = {}
		cxtab = string.Explode(" ",data)
		if (hook.Run("OnPointClientCommand",activator,data)!=true) then 
			activator:ConCommand(data)
		end
	end
end



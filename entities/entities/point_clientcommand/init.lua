

ENT.Type 			= "point"

ENT.PrintName 		= "Client Comand"
ENT.Author 			= "Freezebug"
ENT.Purpose			= "Map Compatability"
ENT.Instructions	= "https://www.xayr.ga/"

ENT.Spawnable = false
ENT.AdminSpawnable = false


local Aliases = {
	["sv_cheats 1"] = "puzzles_cheats_on",
	["sv_cheats 0"] = "puzzles_cheats_off"
}


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
		if (Aliases[data or ""]!=nil) then 
			data = Aliases[data]
		end 

		local cxtab = {}
		cxtab = string.Explode(" ",data)
		if (hook.Run("OnPointClientCommand",activator,data)!=true) then 
			if (IsValid(activator)) then 
				activator:ConCommand(data)
			else 
				MsgC(Color(255,0,0),"Clientcommand with no activator!\n")
			end
		end
	end
end



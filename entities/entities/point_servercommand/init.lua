
ENT.Type 			= "point"

ENT.PrintName 		= "Server Command"
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
		MsgC(Color(255,0,0),tostring(self) .. "[SERVERCOMMAND] ")
		if data then 
			MsgC(Color(255,255,0), data .. "\n")
		end
		if (Aliases[data or ""]!=nil) then 
			data = Aliases[data]
		end 
		local cxtab = {}
		cxtab = string.Explode(" ",data)
		RunConsoleCommand(unpack(cxtab))
	end
end



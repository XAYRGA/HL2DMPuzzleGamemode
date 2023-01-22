local cvar = CreateConVar( "pz_item_respawn_silent", "0", { FCVAR_SERVER_CAN_EXECUTE } , "Respawn time for all respawnables")

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self.WeaponEntity = nil
	self.LastSpawn = 0
	self:SetModel("models/hunter/plates/plate.mdl");
	self:SetMaterial("models/props_lab/warp_sheet")
	self.Entity:SetSolid(0)
	self.OriginalPos =  	self.OriginalPos  or Vector(0,0,0)
	self.OriginalAngles = 	self.OriginalAngles or Angle(0,0,0)
	
end

function ENT:Think()
	if not self.WepClass then print("ERROR!: Spawning node was created, but no weapon for it to spawn was set.") self.Entity:Remove() return end 
	if (CurTime() > (self.LastSpawn + 1.5)) then
		if ((!self.WeaponEntity or !IsValid(self.WeaponEntity)) or (IsValid(self.WeaponEntity) and self.WeaponEntity.RSPPickedUp==true)) then 
			self.WeaponEntity = ents.Create(self.WepClass)
			self.WeaponEntity:SetPos(self.OriginalPos)
			self.WeaponEntity:SetAngles(self.OriginalAngles)
			self.WeaponEntity:Spawn()
			if (cvar:GetBool()==false) then 
				self.WeaponEntity:EmitSound("weapons/stunstick/alyx_stunner2.wav")
			end
			self.LastSpawn = CurTime()
		end 
	end
	if (IsValid(self.WeaponEntity) and self.WeaponEntity:GetPos():Distance(self.OriginalPos) > 120) then 
		if (CurTime() - self.LastSpawn > 30) then 
			self.WeaponEntity:Remove()
		end
	end
end	



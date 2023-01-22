local grenadeThrowForce = CreateConVar( "sk_fraggrenade_force_throw", "2000", { FCVAR_SERVER_CAN_EXECUTE } , "Force to throw the grenade at")
local grenadeLobForce = CreateConVar( "sk_fraggrenade_force_lob", "350", { FCVAR_SERVER_CAN_EXECUTE } , "Force to lob the grenade at")
local grenadeRollForce = CreateConVar( "sk_fraggrenade_force_roll", "700", { FCVAR_SERVER_CAN_EXECUTE } , "Force to roll the grenade at")

AddCSLuaFile("cl_init.lua")
include( 'shared.lua' )
AddCSLuaFile('shared.lua')

function SWEP:Initialize()
	self.Throwing = false 
	self.CanThrow = true
	self.ThrowType = 1
end


function SWEP:Think()
    if (self:Clip1()==0) then     
        if (self:Ammo1() > 0) then 
            self:GetOwner():RemoveAmmo( 1, self.Weapon:GetPrimaryAmmoType() )
            self:SetClip1(1)
        end        
    end 
    if (self.Throwing) then 
        if (!(self.Owner:KeyDown(IN_ATTACK) or self.Owner:KeyDown(IN_ATTACK2))) then 
            self.Throwing = false 
            if (self.ThrowType==1) then 
                self:SendWeaponAnim(ACT_VM_THROW)
                local grenade = ents.Create("npc_grenade_frag_new")
                local eyePos = self.Owner:EyePos()
                local eyeAng = self.Owner:EyeAngles()
                local src = eyePos + eyeAng:Forward() * 18 + eyeAng:Right() * 8
                local pVel = self.Owner:GetVelocity() 
                local vThrow = pVel + (eyeAng:Forward()* grenadeThrowForce:GetFloat())
                grenade:SetPos(src)
                grenade:Spawn()
                grenade:Activate()
                grenade:PhysWake()
                grenade:GetPhysicsObject():SetAngleVelocityInstantaneous(Vector(math.random(-300,300),math.random(-300,300),math.random(-300,300)))
                grenade:GetPhysicsObject():SetVelocity(vThrow)
                grenade:SetOwner(self.Owner)
					
                
            elseif (self.ThrowType==2) then
                    self:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
                    local grenade = ents.Create("npc_grenade_frag_new")
                    local eyePos = self.Owner:EyePos()
                    local eyeAng = self.Owner:EyeAngles()
                    local src = eyePos + eyeAng:Forward() * 18 + eyeAng:Right() * 8 + Vector(0,0,-8)
                    local pVel = self.Owner:GetVelocity() 
                    local vThrow = pVel + (eyeAng:Forward()* grenadeLobForce:GetFloat())
                    grenade:SetPos(src)
                    grenade:Spawn()
                    grenade:Activate()
                    grenade:PhysWake()
                    grenade:GetPhysicsObject():SetAngleVelocityInstantaneous(Vector(math.random(-300,300),math.random(-300,300),math.random(-300,300)))
                    grenade:GetPhysicsObject():SetVelocity(vThrow)
                    grenade:SetOwner(self.Owner)
                //end 
            end
            self:TakePrimaryAmmo(1)
            if (self:Ammo1() > 0) then 
                self:GetOwner():RemoveAmmo( 1, self.Weapon:GetPrimaryAmmoType() )
                self:SetClip1(1)
            end        
            
            timer.Simple(0.6,function()
                self.CanThrow = true
                if (self:Ammo1()==0 ) then 
                    self:Remove()
                end 
                self:SendWeaponAnim(ACT_VM_DRAW)
            end)
        end 
    end 
end 


function SWEP:Deploy()
	self:SendWeaponAnim(ACT_VM_DRAW)
end

function SWEP:PrimaryAttack()
    if (self.CanThrow==true and self:CanPrimaryAttack()) then 
        self.Throwing = true 
        self.CanThrow = false
        self.ThrowType = 1
        self:SendWeaponAnim(ACT_VM_PULLBACK_HIGH)
    end
end
 

function SWEP:SecondaryAttack()
		if (self.CanThrow==true and self:CanSecondaryAttack()) then 
			self.Throwing = true 
			self.CanThrow = false
			self.ThrowType = 2
			self:SendWeaponAnim(ACT_VM_PULLBACK_LOW)
		end
end
 
AddCSLuaFile("shared.lua")

SWEP.Author = "Xayr"
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.Instructions = ""
SWEP.PrintName = "Grenade?"
 
SWEP.Slot = 4 
SWEP.SlotPos = 4
SWEP.Category = "Category"
SWEP.Spawnable = true -- Whether regular players can see it
SWEP.AdminSpawnable = true -- Whether Admins/Super Admins can see it

SWEP.ViewModel = "models/weapons/v_grenade.mdl" -- This is the model used for clients to see in first person.
SWEP.WorldModel = "models/weapons/w_grenade.mdl" -- This is the model shown to all other clients and in third-person.

SWEP.Primary.ClipSize = 1
SWEP.Primary.DefaultClip = 5
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "Grenade"

 
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"


function SWEP:CanPrimaryAttack()
	if ( self.Weapon:Clip1() <= 0 ) then
        return false 
    end 
    return true
end

    
function SWEP:CanSecondaryAttack()
	if ( self.Weapon:Clip1() <= 0 ) then
        return false 
    end
    return true
end
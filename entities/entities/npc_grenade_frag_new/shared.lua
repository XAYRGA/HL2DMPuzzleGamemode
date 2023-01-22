AddCSLuaFile("shared.lua")
ENT.Type = "anim"
ENT.Author = "Xayr"
ENT.LifeTime = 4.5
ENT.Damage = 100
local fragDamage = GetConVar("sk_plr_dmg_fraggrenade")
local fragRadius = GetConVar("sk_fraggrenade_radius")

function ENT:Initialize()
	self:SetModel("models/weapons/w_grenade.mdl")

	if (SERVER) then 
		self:PhysicsInit(SOLID_BBOX)
		self:SetRenderMode(RENDERMODE_TRANSCOLOR)
		self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	end
	if (CLIENT) then
	
	end

	self.Exploding = false
	self.ExplodingStart = CurTime()
	self.TickDistance = 1 
	self.LastTick = CurTime()
	
	if (SERVER) then 
		local trail = util.SpriteTrail( self, 0, Color( 255, 0, 0 ), true, 15, 0, 0.2, 1 / ( 15 + 1 ) * 0.5, "sprites/bluelaser1.vmt" )

	end

	if (self.DontDetonateImmediately~=true) then 
		self:StartCountdown()
	end 
end

function ENT:GravgunPickup(ply)
    self:SetOwner(ply)
    self.Exploding = true
	self.ExplodingStart = CurTime()
    self.LifeTime = 2
    self.TickDistance = 0.3
end 


function ENT:StartCountdown()
	self.Exploding = true
	self.ExplodingStart = CurTime()
end

function ENT:Think()
	if (SERVER) then 
		if (self.Exploding) then 
			if (self.LastTick + self.TickDistance  < CurTime()) then 
				self:EmitSound("Grenade.Blip")	
				self.LastTick = CurTime()
			end
			if (self.ExplodingStart + self.LifeTime  < CurTime()) then 
				
				util.BlastDamage( self, game.GetWorld(), self:GetPos(), fragRadius:GetFloat(), fragDamage:GetFloat() )
				local effectdata = EffectData()
				effectdata:SetOrigin( self:GetPos() )
				util.Effect( "Explosion", effectdata, true, true )
				self:Remove()
			end
			
			local timeRemaining = (self.ExplodingStart + self.LifeTime) - CurTime()
			if (timeRemaining < self.LifeTime / 2) then 
				self.TickDistance = 0.3
			end 
		end 
	end
end

function ENT:Draw()
	self:DrawModel()	
end

hook.Add("GravGunOnPickedUp","LuaGrenade",function(ply,ent)
    if ent.GravgunPickup then 
        ent:GravgunPickup(ply)
    end
end)
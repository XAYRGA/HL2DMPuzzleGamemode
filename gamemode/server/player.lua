local PLAYER = FindMetaTable("Player")

util.AddNetworkString("GM:ChatPrint")
function PLAYER:ChatPrint(...) 
    net.Start("GM:ChatPrint")
        net.WriteTable({...})
    net.Send(self)
end 

function GM:ChatPrintAll(...)
    net.Start("GM:ChatPrint")
        net.WriteTable({...})
    net.Broadcast()
end 

function GM:PlayerInitialSpawn(ply)
    ply:SetModel("models/player/alyx.mdl")
    ply:SetTeam(TEAM_REBELS)
    ply:AllowFlashlight(GetConVar("mp_flashlight"):GetBool())
    ply:SetCollisionGroup(COLLISION_GROUP_PASSABLE_DOOR)
end

function GM:PlayerSpawn(ply)
    if (ply.NextTeam!=nil) then 
        ply:SetTeam(ply.NextTeam)
        ply.NextTeam = nil
    end
    ply:SetCollisionGroup(COLLISION_GROUP_PASSABLE_DOOR)
end

function GM:PlayerCanHearPlayersVoice( listener, talker )
    return true
end

GM.MaxAmmo = {
    ["RPG_Round"] = function() return GetConVar("sk_max_rpg_round"):GetInt() end,
    ["AR2"] = function() return GetConVar("sk_max_ar2"):GetInt() end,
    ["SMG1"] = function() return GetConVar("sk_max_smg1"):GetInt() end,
    ["Pistol"] = function() return GetConVar("sk_max_pistol"):GetInt() end,
    ["357"] = function() return GetConVar("sk_max_357"):GetInt() end,
    ["Buckshot"] = function() return GetConVar("sk_max_buckshot"):GetInt() end,
    ["XBowBolt"] = function() return GetConVar("sk_max_crossbow"):GetInt() end,
    ["Grenade"] = function() return GetConVar("sk_max_grenade"):GetInt() end,
    ["slam"] = function() return GetConVar("sk_max_satchel"):GetInt() end,
}

function GM:PlayerCanPickupWeapon( ply, weapon )

    if (weapon:GetPrimaryAmmoType()!=-1) then 
        local ammoType = weapon:GetPrimaryAmmoType()
        local ammoTypeIndex = game.GetAmmoTypes()[ammoType]
        local PlayerAmmoCount = ply:GetAmmoCount(ammoType)     
        local data = self.MaxAmmo[ammoTypeIndex]
        local ammoLimit
        if (type(data)=="function") then 
            ammoLimit = data()
        elseif (type(data)=="number") then
            ammoLimit = data  
        end     
  
        if (data!=nil) then 
            if (PlayerAmmoCount>=ammoLimit and ply:HasWeapon(weapon:GetClass()) ) then                 
                return false
            end
            if (PlayerAmmoCount + weapon:Clip1() > ammoLimit) then
                weapon:SetClip1(ammoLimit - PlayerAmmoCount)
            end 
        else 
            MsgC(Color(255,0,0),"Ammo type " .. ammoTypeIndex .. " not in gamemode manifest! " .. tostring(ply))
            MsgN("")
            return true
        end 
    else 
        if (ply:HasWeapon(weapon:GetClass())) then 
            return false 
        end    
    end  
    ply:EmitSound("items/ammo_pickup.wav")
    return true
end

function GM:PlayerAmmoChanged(ply, ammoType, old, new)   
        local ammoTypeIndex = game.GetAmmoTypes()[ammoType]
        local PlayerAmmoCount = ply:GetAmmoCount(ammoType)   
        local data = self.MaxAmmo[ammoTypeIndex]
        local ammoLimit
        if (type(data)=="function") then 
            ammoLimit = data()
        elseif (type(data)=="number") then
            ammoLimit = data  
        end 

        if (data!=nil) then 
            if (PlayerAmmoCount>=ammoLimit) then 
                ply:SetAmmo(ammoLimit,ammoType)                
            end        
        else 
            MsgC(Color(255,0,0),"Ammo type " .. ammoTypeIndex .. " not in gamemode manifest! " .. tostring(ply))
            MsgN("")
        end 
end 

GM.TeamFootsteps = {}
GM.TeamFootsteps[TEAM_REBELS] = {
    "npc/combine_soldier/gear1.wav",
    "npc/combine_soldier/gear2.wav",
    "npc/combine_soldier/gear3.wav",
    "npc/combine_soldier/gear4.wav",
    "npc/combine_soldier/gear5.wav",
    "npc/combine_soldier/gear6.wav",
}

GM.TeamFootsteps[TEAM_COMBINE] = {
    "npc/combine_soldier/gear1.wav",
    "npc/combine_soldier/gear2.wav",
    "npc/combine_soldier/gear3.wav",
    "npc/combine_soldier/gear4.wav",
    "npc/combine_soldier/gear5.wav",
    "npc/combine_soldier/gear6.wav",
}


function GM:PlayerFootstep(ply, pos,foot,snd,vol,fil) 
    if self.TeamFootsteps[ply:Team()] then 
        local fs = table.Random(self.TeamFootsteps[ply:Team()])
        ply:EmitSound(fs,75,100,vol)
        return true 
    end    
end


local launchScale = CreateConVar( "pz_player_explosion_launch_multiplier", "1", { FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY } , "Change how much the damage explosions are multiplied by, and how hard they launch players around.")


function GM:PlayerTakeDamage(ply, dmginfo) 
    if (dmginfo:IsExplosionDamage()) then 
        ply:SetVelocity(dmginfo:GetDamageForce() * launchScale:GetFloat() / 1000)
    end 
end 

local friendlyfire = GetConVar("mp_friendlyfire")
function GM:PlayShouldTakeDamage(ply, atk)
    if (IsValid(atk) and atk:IsPlayer()) then 
        if (ply:Team()==atk:Team() and not friendlyfire:GetBool()) then 
            return false
        end 
    end
end

hook.Add("EntityTakeDamage", "GM:PlayerTakeDamage",function(t,di)
    if (t:IsPlayer()) then 
        GAMEMODE:PlayerTakeDamage(t,di)
    end 
end)

 

function GM:PlayerInitialSpawn(ply)
    ply:SetModel("models/player/alyx.mdl")
    ply:SetTeam(TEAM_REBELS)
    ply:AllowFlashlight(GetConVar("mp_flashlight"):GetBool())
end

function GM:PlayerSpawn(ply)
    if (ply.NextTeam!=nil) then 
        ply:SetTeam(ply.NextTeam)
        ply.NextTeam = nil
    end
end

function GM:PlayerCanHearPlayersVoice( listener, talker )
    return true
end

GM.MaxAmmo = {
    ["weapon_rpg"] = function() return GetConVar("sk_max_rpg_round"):GetInt() end,
    ["weapon_ar2"] = function() return GetConVar("sk_max_ar2"):GetInt() end,
    ["weapon_smg1"] = function() return GetConVar("sk_max_smg1"):GetInt() end,
    ["weapon_pistol"] = function() return GetConVar("sk_max_pistol"):GetInt() end,
    ["weapon_357"] = function() return GetConVar("sk_max_357"):GetInt() end,
    ["weapon_shotgun"] = function() return GetConVar("sk_max_buckshot"):GetInt() end,
    ["weapon_crossbow"] = function() return GetConVar("sk_max_crossbow"):GetInt() end,
    ["weapon_frag"] = function() return GetConVar("sk_max_grenade"):GetInt() end,
}

function GM:PlayerCanPickupWeapon( ply, weapon )

    if (weapon:GetPrimaryAmmoType()!=-1) then 
        local ammoType = weapon:GetPrimaryAmmoType()
        local PlayerAmmoCount = ply:GetAmmoCount(ammoType) 
        local data = self.MaxAmmo[weapon:GetClass()]
        local ammoLimit
        if (type(data)=="function") then 
            ammoLimit = data()
        elseif (type(data)=="number") then
            ammoLimit = data  
        end 
   
        if (data!=nil) then 
            if (PlayerAmmoCount>=ammoLimit) then 
                return false
            end
            if (PlayerAmmoCount + weapon:Clip1() >  ammoLimit) then
                weapon:SetClip1(ammoLimit - PlayerAmmoCount)
            end 
        end
    else 
        if (ply:HasWeapon(weapon:GetClass())) then 
            return false 
        end    
    end  
    ply:EmitSound("items/ammo_pickup.wav")
    return true
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
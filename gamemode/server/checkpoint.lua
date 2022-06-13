local enable = CreateConVar( "pz_checkpoint_enable", "1", { FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY } , "Enable Checkpoint System")
local count = CreateConVar( "pz_checkpoint_count", "10", { FCVAR_SERVER_CAN_EXECUTE } , "Amount of checkpoints players get per map")

GM.CheckpointRemaining = GM.CheckpointRemaining or {} 
local RemainingData = GM.CheckpointRemaining

function GM:CheckpointSpawn(ply)
    if (ply.HasCheckpoint==true) then 
        self:CheckpointReturn(ply)
    end 
end 

function GM:CheckpointInitialSpawn(ply)
    if (!RemainingData[ply:SteamID()]) then 
        ply:SetNWInt("CheckpointsRemaining", count:GetInt())
        RemainingData[ply:SteamID()] = ply:GetNWInt("CheckpointsRemaining");
    else 
        ply:SetNWInt("CheckpointsRemaining", RemainingData[ply:SteamID()])
    end
 
end 

function GM:CheckpointFailRestore(ply) 
    ply:EmitSound(Sound("/ambient/machines/thumper_shutdown1.wav"))
end 

function GM:CheckpointReturn(ply) 
    ply:EmitSound(Sound("ambient/levels/citadel/zapper_warmup1.wav"))
    timer.Simple(1.5, function() 
        if (ply.HasCheckpoint and ply:Alive()) then 
            ply:EmitSound(Sound("ambient/machines/thumper_top.wav"))
            ply:SetPos(ply.CheckpointData.Pos)
            ply:SetAngles(ply.CheckpointData.Ang)
            ply:SetVelocity(ply.CheckpointData.Velocity - ply:GetVelocity())
            ply:SetEyeAngles(ply.CheckpointData.Eye)
            ply:SetHealth(ply.CheckpointData.Health)
            ply:SetArmor(ply.CheckpointData.Armor)
            ply:StripWeapons()
            ply:StripAmmo()
            for k,v in pairs(ply.CheckpointData.Weapons) do 
                local wp = ply:Give(v[1])
                ply:SetAmmo(v[3],v[2])
                wp:SetClip1(v[4])
                wp:SetClip2(wp[5] or 0 )
            end 
            timer.Simple(0,function()
                ply:SelectWeapon(ply.CheckpointData.WeaponActive or "weapon_physcannon")
            end)
        else 
            self:CheckpointFailRestore(ply)
        end 
    end) 
end 

function GM:SetCheckpoint(ply) 
    local wpns = {}

    for k,v in pairs(ply:GetWeapons()) do 
        wpns[#wpns + 1] = {v:GetClass(), v:GetPrimaryAmmoType(), ply:GetAmmoCount(v:GetPrimaryAmmoType()), v:Clip1(), v:Clip2()}
    end 
    local lastActive = "weapon_physcannon"
    if (IsValid(ply:GetActiveWeapon())) then
        lastActive = ply:GetActiveWeapon():GetClass()
    end 
    ply.CheckpointData =  {
        Pos = ply:GetPos(),
        Ang = ply:GetAngles(),
        Health = ply:Health(),
        Armor = ply:Armor(),
        Velocity = ply:GetVelocity(),
        Eye = ply:EyeAngles(),
        Weapons = wpns,
        WeaponActive = lastActive
    }
    ply.HasCheckpoint = true
end 

function GM:CheckpointTrySet(ply) 
    if enable:GetBool()==false then 
        ply:ChatPrint("Checkpoints aren't enabled for this server.")
        return
    end 
    if ply:GetNWInt("CheckpointsRemaining") < 1 then 
        ply:ChatPrint("You don't have any checkpoints left!")
        return 
    end
    ply:SetNWInt("CheckpointsRemaining",ply:GetNWInt("CheckpointsRemaining") - 1) 
    self:SetCheckpoint(ply)
    ply:ChatPrint("Checkpoint set, you have " .. ply:GetNWInt("CheckpointsRemaining") .. " checkpoints remaining.")
    RemainingData[ply:SteamID()] = ply:GetNWInt("CheckpointsRemaining")
end 

function GM:CheckpointClear(ply) 
    ply.HasCheckpoint = false 
    ply:ChatPrint("Your checkpoint was cleared.")
end 


function GM:CheckpointChat(ply,t)
    if (t=="!cp") then 
        self:CheckpointTrySet(ply)
    end 

    if (t=="!ucp") then 
        self:CheckpointClear(ply)
    end 

    if (t=="!gocp") then 
        self:CheckpointReturn(ply)
    end 
end 



hook.Add("PlayerSay","CheckpointSay",function(P,T,TO) GAMEMODE:CheckpointChat(P,T,TO) end)
hook.Add("PlayerSpawn","CheckpointSpawn",function(P) GAMEMODE:CheckpointSpawn(P) end)
hook.Add("PlayerInitialSpawn","CheckpointSpawn",function(P) GAMEMODE:CheckpointInitialSpawn(P) end)

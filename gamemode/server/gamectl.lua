function GM:EndGame(ply)
    MapVote.Start()
end 

function GM:OnPointClientCommand(ply ,command)
    local cmd = string.Explode(" ",string.lower(command))
    if (cmd[1]=="cl_playermodel") then 
        ply.NextModel = (string.Replace(cmd[2],"models/humans/","models/player/"))
        if (string.find(cmd[2],"human")) then 
            ply.NextTeam = TEAM_REBELS
        else 
            ply.NextTeam = TEAM_COMBINE
        end
        return true
    end 
end

function GM:PointsThink()
	for k,v in pairs(player.GetAll()) do
		if v:Frags() > v.LastFrags then 
			local added = v:Frags() - v.LastFrags
			v.LastFrags = v:Frags()
			hook.Run("OnPlayerEarnFrags",v,added, v:Frags())
		end
	end
end

hook.Add("PlayerInitialSpawn","PointSysSpawn",function(P)
    P.LastFrags = 0
end)

local lastFragsCheck = CurTime() 
hook.Add("Think","PointSysThink",function()
    if (lastFragsCheck + 3 < CurTime()) then 
	    GAMEMODE:PointsThink()
        lastFragsCheck = CurTime()
    end 
end)

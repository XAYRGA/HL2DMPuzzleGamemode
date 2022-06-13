function GM:PointsThink()
	for k,v in pairs(player.GetAll()) do
		if v:Frags() > v.LastFrags then 
			local added = v:Frags() - v.LastFrags
			v.LastFrags = v:Frags()
			hook.Run("OnPlayerEarnFrags",v,added, v:Frags())
		end
	end
end

hook.Add("PlayerInitialSpawn","PointSysSpawn",function()
    P.LastFrags = 0
end)

local lastFragsCheck = CurTime() 
hook.Add("Think","PointSysThink",function()
    if (lastFragsCheck + 3 < CurTime()) then 
	    GAMEMODE:PointsThink()
        lastFragsCheck = CurTime()
    end 
end)

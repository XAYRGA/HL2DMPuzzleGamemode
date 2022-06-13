GM.MaxSprint = 300
GM.SprintDrainRate = 1
GM.SprintRechargeDelay = 3
GM.SprintRecahrgeRate =  1
GM.RunSpeed = 500
GM.WalkSpeed = 250

GM.DrowningDischargeRate = 100
GM.DrownDamage = 10
GM.DrownRechargeRate = 1 
GM.DrownFrequency = 1.3



hook.Add("Think","DrowningThink",function()
	local cm = (66.6666 / (1/engine.TickInterval())) // Recompute, in singleplayer it can change.
    for k,ply in pairs(player.GetAll()) do 
        if (!ply.Oxygen) then 
            ply.Oxygen = 100
            ply.LastDrownDamage = CurTime()
            ply.DrownOwedHealth = 0
        end
        if ply:WaterLevel()==3 then  
            if (ply.Oxygen > 0) then 
                ply.Oxygen = ply.Oxygen - (GAMEMODE.DrowningDischargeRate/1000) * cm
            else                
                if (ply.LastDrownDamage + GAMEMODE.DrownFrequency < CurTime() and ply:Alive()) then 
                    ply:TakeDamage(GAMEMODE.DrownDamage)
                    ply.LastDrownDamage = CurTime() 
                    ply:EmitSound("player/pl_drown" .. math.random(1,3) .. ".wav")               
                end 
            end         
        else
            if (ply.Oxygen < 100) then 
                ply.Oxygen = ply.Oxygen + GAMEMODE.DrownRechargeRate * cm
            end 
        end      
        ply:SetNWFloat("Oxygen",ply.Oxygen)
    end 
end)

function GM:OnSprintMove(ply,mv)
	local cm = (66.6666 / (1/engine.TickInterval())) // Recompute, in singleplayer it can change.
	if mv:KeyDown(IN_SPEED) then 
		if ply.Sprint > 0 then 
			if mv:GetVelocity():Length() > 0 and ply:IsOnGround()  then 
				ply.Sprint = ply.Sprint - ((self.SprintDrainRate * cm) * math.Clamp(self.RunSpeed / mv:GetVelocity():Length(),0,1)) 
				ply.LastSprintTime = CurTime()
				ply.Sprinting = true
			end
		else 
			ply.Sprinting = false 
		end
	else 
		ply.Sprinting = false 
	end

	if ply.Sprint > 0 then 
		if ply:GetRunSpeed()~=self.RunSpeed then 
			ply:SetRunSpeed(self.RunSpeed)
		end
	else 
		if ply:GetRunSpeed()~=self.WalkSpeed then 
			ply:SetRunSpeed(self.WalkSpeed)
		end
	end

	if CurTime() > (ply.LastSprintTime + self.SprintRechargeDelay ) then
		if ply.Sprint < self.MaxSprint then 
			ply.Sprint = ply.Sprint + self.SprintRecahrgeRate*cm
		end
	end

    if (ply.LastSprinting!=ply.Sprinting) then 
        if (ply.Sprinting==true) then 
            ply:EmitSound("player/suit_sprint.wav")
        end
        ply.LastSprinting = ply.Sprinting
    end
	ply:SetNWInt("Sprint",(ply.Sprint / self.MaxSprint) * 100 )
end

function GM:SprintThink()

end


hook.Add("Move","SprintMove",function(py,mv)
	GAMEMODE:OnSprintMove(py,mv)
end)


hook.Add("PlayerSpawn","SprintSpawn",function(P)
	P.Sprint = GAMEMODE.MaxSprint
	P.LastSprintTime = 0
	P.Sprinting = false
    P.LastSprinting = false
end)

hook.Add("Think","SprintThink",function()
	GAMEMODE:SprintThink()
end)	
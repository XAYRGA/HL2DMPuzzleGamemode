GM.RTVPercentage = 66
GM.RTVVotes = {}
GM.RTVEnableSounds = true 
GM.RTVGamemodeStart = GM.RTVGamemodeStart or CurTime()  
if (GAMEMODE) then 
    GM.RTVGamemodeStart = GAMEMODE.RTVGamemodeStart
end 

local rtvEnable = CreateConVar( "pz_rtv_enabled", "1", { FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY } , "Enable Rock The Vote")
local rtvPercentage  = CreateConVar( "pz_rtv_percentage", "66", { FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY } , "Rock The Vote percentage required")
local rtvCooldown = CreateConVar( "pz_rtv_cooldown", "380", { FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY } , "Time it takes after map start for RTV to enable.")


function GM:RockTheVote(ply)    
    if (rtvEnable:GetBool()==false) then 
        ply:ChatPrint(Color(255,0,0),"RTV is not enabled on this server.")
        return false
    end 
    if (CurTime() - self.RTVGamemodeStart < rtvCooldown:GetInt()) then 
        ply:ChatPrint(Color(155,0,155),"RTV is not ready yet... please wait ", tostring(math.ceil(rtvCooldown:GetInt() - (CurTime() - self.RTVGamemodeStart) )), " seconds.")
        return false
    end 





    if ( self.RTVVotes[ply]) then 
        ply:ChatPrint(Color(155,0,155),"You have already rocked the vote!")
    else 
        self.RTVVotes[ply] = true 
        local reqPly = math.ceil(#player.GetAll() * (rtvPercentage:GetInt()/100))
        local curPly = table.Count(self.RTVVotes)
        self:ChatPrintAll(ply, Color(255,255,255)," has rocked the vote! ",Color(255,255,0),"[",tostring(curPly),"/",tostring(reqPly),"]")
    end 

    local reqPly = math.ceil(#player.GetAll() * (rtvPercentage:GetInt()/100))
    local curPly = table.Count(self.RTVVotes)
    
    if (curPly>=reqPly) then 
        self:ChatPrintAll(Color(255,255,0),"The vote has been rocked! Selecting next map!")
        GAMEMODE:EndGame()
    end
end

hook.Add("PlayerSay","rtv",function(P,T,TO)
    if (T=="rtv" or T=="!rtv" or T=="/rtv") then 
        if (GAMEMODE:RockTheVote(P)==false) then 
            return ""
        end
    end
end)

local rtvEnabledNotify = false 

timer.Create("RTVNotify",5,0,function()
    if (CurTime() - GAMEMODE.RTVGamemodeStart > rtvCooldown:GetInt() and rtvEnabledNotify == false) then 
        GAMEMODE:ChatPrintAll({Color(0,255,0),"RTV is now enabled! Use !rtv to vote to change the map"})
        rtvEnabledNotify = true   
    end
end)
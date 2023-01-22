PATCH.MapMatch = "js_puzzle_semi_pro_schumi*"


AddInputPatch("spawn_rpg#ForceSpawn",function() 
    timer.Simple(0.1,function()
        for k,v in pairs(ents.GetAll()) do
            local dorsprn = false	
            if v:GetClass()=="weapon_rpg" then
                local opos = v:GetPos()
                local n = ents.Create("pz_respawner")
                n:SetPos(opos)
                n.OriginalPos = opos 
                n.OriginalAngles = v:GetAngles()
                n.WepClass = v:GetClass()
                n:Spawn()
                v:Remove()
            end
        end
    end)
end)
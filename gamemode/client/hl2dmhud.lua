local lastMag = Color(255,255,0,100)
hook.Add("HUDPaint","SprintHud",function()
    local fl = LocalPlayer():GetNWFloat("Sprint")
    local ox = LocalPlayer():GetNWFloat("Oxygen")

    if (fl<100 and ox >=99) then 
        local val = (fl/100) * 1100
        draw.RoundedBox( 10, ScrW() * 0.02, ScrH() * 0.84, ScrW() * 0.118, ScrH() * 0.06, Color(1,1,1,100))
        surface.SetTextPos( ScrW() * 0.025, ScrH() * 0.845 )
        surface.SetFont("ChatFont")
        surface.SetTextColor(lastMag)
        surface.DrawText("AUX POWER")
        surface.SetTextPos( ScrW() * 0.025, ScrH() * 0.88 )
        surface.DrawText("SPRINT")

        for i=0, 9 do 
            val = val - 100 
        
            local mul = math.Clamp((val/100) ,0,1)
    
            local alpha = mul * 255

            surface.SetDrawColor(Color(255,255 * mul,0,alpha))
            surface.DrawRect(ScrW() * 0.0244 + (i * ScrW() * 0.0115), ScrH() * 0.868 , ScrW() * 0.0075, ScrH() * 0.0065)
        end 
        mul = math.Clamp((val/100) ,0,1)
        lastMag = Color(255,255 * math.Clamp(fl/50,0,1),0,255)
    elseif (ox < 100) then 
        local val = (ox/100) * 1100
        draw.RoundedBox( 10, ScrW() * 0.02, ScrH() * 0.84, ScrW() * 0.118, ScrH() * 0.06, Color(1,1,1,100))
        surface.SetTextPos( ScrW() * 0.025, ScrH() * 0.845 )
        surface.SetFont("ChatFont")
        surface.SetTextColor(lastMag)
        surface.DrawText("AUX POWER")
        surface.SetTextPos( ScrW() * 0.025, ScrH() * 0.88 )
        surface.DrawText("OXYGEN")

        for i=0, 9 do 
            val = val - 100 
            local mul = math.Clamp((val/100) ,0,1)
            local alpha = mul * 255
            surface.SetDrawColor(Color(255 - (255*mul),164,255 * mul,alpha))
            surface.DrawRect(ScrW() * 0.0244 + (i * ScrW() * 0.0115), ScrH() * 0.868 , ScrW() * 0.0075, ScrH() * 0.0065)
        end 
        mul = math.Clamp((val/100) ,0,1)
        lastMag = Color(255 - (255 * math.Clamp(ox/50,0,1)),164,255 * math.Clamp(ox/50,0,1),255)
    end 

end)
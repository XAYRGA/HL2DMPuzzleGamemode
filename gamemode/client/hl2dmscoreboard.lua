GM.ScoreboardVisible = false 

surface.CreateFont( "HL2DMScoreboard", {
	font = "Tahoma", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = true,
	size = ScreenScale(5),
	weight = 400,
	blursize = 0,
	scanlines = 0,
	antialias = false,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )


local COLOR_HL2 = Color(255,177,0)
local w = ScrW() * 0.5
local h = ScrH() * 0.8
local x = ScrW() * 0.5
local y = ScrH() * 0.48
local row_size = ScrH() * 0.016

local TEAM_COMBINE = 2
local TEAM_REBELS = 1

local corner_x = x - w/2
local corner_y =  y - h/2

local R = 30
hook.Add("HUDPaint","hl2dmScoreboard",function()
    if (GAMEMODE.ScoreboardVisible == true) then 
        local tOffset = row_size * 2
        draw.RoundedBoxEx( R,corner_x,corner_y, w,h , Color(0,0,0,160), true,true,true,true )
        surface.SetDrawColor(COLOR_HL2)
        surface.DrawOutlinedRect(corner_x,corner_y,w,h)
        draw.DrawText( GetHostName(), "HudHintTextLarge", corner_x + ScrW() * 0.005, corner_y + ScrH() * 0.005, COLOR_HL2, TEXT_ALIGN_LEFT )
        draw.DrawText( "Score", "HL2DMScoreboard", corner_x + ScrW() * 0.41, corner_y + ScrH() * 0.005, COLOR_HL2, TEXT_ALIGN_LEFT )
        draw.DrawText( "Deaths", "HL2DMScoreboard", corner_x + ScrW() * 0.44, corner_y + ScrH() * 0.005, COLOR_HL2, TEXT_ALIGN_LEFT )
        draw.DrawText( "Latency", "HL2DMScoreboard", corner_x + ScrW() * 0.47, corner_y + ScrH() * 0.005, COLOR_HL2, TEXT_ALIGN_LEFT )

        local ROWLEFT = corner_x + ScrW() * 0.005
        local ROWDOWN = corner_y + ScrH() * 0.005
        local ROWHEIGHT = row_size - 5
        local ROWLENGTH = w - ScrW() * 0.01
        
        local cp = team.GetPlayers(TEAM_COMBINE)
        local sc = team.GetScore(TEAM_COMBINE)
        local tn = team.GetName(TEAM_COMBINE)
        local tc = team.GetColor(TEAM_COMBINE)
        local txt 
        if #tc > 1 or #tc==0 then 
            txt = tn .. " - " .. #tc .. " players"
        else 
            txt = tn  .. " - " .. #tc .. " player"
        end 
        draw.DrawText( txt, "HudHintTextLarge", ROWLEFT, tOffset + ROWDOWN, tc, TEXT_ALIGN_LEFT )
        draw.DrawText( tostring(sc), "HL2DMScoreboard", ROWLEFT + ScrW() * 0.41, tOffset + ROWDOWN, tc, TEXT_ALIGN_LEFT )
        surface.SetDrawColor(tc)
        surface.DrawLine(ROWLEFT,tOffset+ row_size * (0.85) +ROWDOWN,ROWLEFT + ROWLENGTH, tOffset+row_size * (0.85) +ROWDOWN)
    
        tOffset = tOffset + row_size 
        for k,v in pairs(cp) do 
            if (v==LocalPlayer()) then 
                surface.SetDrawColor(255,255,255,30)
                surface.DrawRect(ROWLEFT ,tOffset + ROWDOWN ,ROWLENGTH,ROWHEIGHT)
            end
            draw.DrawText( v:Nick(), "HudHintTextLarge", ROWLEFT, tOffset + ROWDOWN, tc, TEXT_ALIGN_LEFT )
            draw.DrawText( tostring(v:Frags()), "HL2DMScoreboard", ROWLEFT + ScrW() * 0.41, tOffset + ROWDOWN, tc, TEXT_ALIGN_LEFT )
            draw.DrawText( tostring(v:Deaths()), "HL2DMScoreboard", ROWLEFT + ScrW() * 0.44, tOffset + ROWDOWN, tc, TEXT_ALIGN_LEFT )
            draw.DrawText( tostring(v:Ping()), "HL2DMScoreboard", ROWLEFT + ScrW() * 0.47, tOffset + ROWDOWN, tc, TEXT_ALIGN_LEFT )
            tOffset = tOffset + row_size
        end
        

        local cp = team.GetPlayers(TEAM_REBELS)
        local sc = team.GetScore(TEAM_REBELS)
        local tn = team.GetName(TEAM_REBELS)
        local tc = team.GetColor(TEAM_REBELS)
        local txt 
        if #tc > 1 or #tc==0 then 
            txt = tn .. " - " .. #tc .. " players"
        else 
            txt = tn  .. " - " .. #tc .. " player"
        end 
        draw.DrawText( txt, "HudHintTextLarge", ROWLEFT, tOffset + ROWDOWN, tc, TEXT_ALIGN_LEFT )
        draw.DrawText( tostring(sc), "HL2DMScoreboard", ROWLEFT + ScrW() * 0.41, tOffset + ROWDOWN, tc, TEXT_ALIGN_LEFT )
        surface.SetDrawColor(tc)
        surface.DrawLine(ROWLEFT,tOffset+ row_size * (0.85) +ROWDOWN,ROWLEFT + ROWLENGTH, tOffset+row_size * (0.85) +ROWDOWN)
    
        tOffset = tOffset + row_size 
        for k,v in pairs(cp) do 
            if (v==LocalPlayer()) then 
                surface.SetDrawColor(255,255,255,30)
                surface.DrawRect(ROWLEFT ,tOffset + ROWDOWN ,ROWLENGTH,ROWHEIGHT)
            end
            draw.DrawText( v:Nick(), "HudHintTextLarge", ROWLEFT, tOffset + ROWDOWN, tc, TEXT_ALIGN_LEFT )
            draw.DrawText( tostring(v:Frags()), "HL2DMScoreboard", ROWLEFT + ScrW() * 0.41, tOffset + ROWDOWN, tc, TEXT_ALIGN_LEFT )
            draw.DrawText( tostring(v:Deaths()), "HL2DMScoreboard", ROWLEFT + ScrW() * 0.44, tOffset + ROWDOWN, tc, TEXT_ALIGN_LEFT )
            draw.DrawText( tostring(v:Ping()), "HL2DMScoreboard", ROWLEFT + ScrW() * 0.47, tOffset + ROWDOWN, tc, TEXT_ALIGN_LEFT )
            tOffset = tOffset + row_size
        end   
    end
end)

function GM:ScoreboardShow()
    self.ScoreboardVisible = true 
    return true
end

function GM:ScoreboardHide()
    self.ScoreboardVisible = false 
    return true
end 

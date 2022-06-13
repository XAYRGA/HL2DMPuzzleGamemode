local Talking = {}
local IconTalk = surface.GetTextureID( "voice/icntlk_sv")
local IconTalkLocal = surface.GetTextureID("voice/icntlk_local")
local TalkingLocal = false 

hook.Add("HUDPaint","VoiceGUI",function()
	local depth = 0
	for k,v in pairs(Talking) do
		surface.SetDrawColor(Color(230,142,20,160))
		surface.DrawRect(ScrW() * 0.80, ScrH() * 0.80 - (ScrH() * 0.027*depth), ScrW() * 0.12, ScrH() * 0.025)
		surface.SetFont("ChatFont")
		surface.SetTextColor(Color(255,255,255,255))
		surface.SetTextPos( ScrW() * 0.825, ScrH() * 0.805 - (ScrH() * 0.027*depth)  ) -- Set text position, top left corner
		surface.DrawText( v:Nick() ) -- Draw the text
		surface.SetDrawColor(Color(255,255,255,160))
		surface.SetTexture(IconTalk)
		surface.DrawTexturedRect(ScrW() * 0.81, ScrH() * 0.80 - (ScrH() * 0.027*depth), ScrH() * 0.025, ScrH() * 0.025)
		depth = depth + 1
	end

	if (TalkingLocal) then 
		surface.SetDrawColor(Color(255,255,255,160))
		surface.SetTexture(IconTalkLocal)
		surface.DrawTexturedRect(ScrW() * 0.94, ScrH() * 0.75 - (ScrH() * 0.027), ScrH() * 0.075, ScrH() * 0.075)
	end
end)

function GM:PlayerStartVoice(ply)
	if (ply!=LocalPlayer() or not LocalPlayer():IsVoiceAudible()) then 
		Talking[ply:SteamID()] = ply
	end 
	if (ply==LocalPlayer()) then 
		TalkingLocal = true
	end
end

function GM:PlayerEndVoice( ply )
	Talking[ply:SteamID()] = nil
	if (ply==LocalPlayer()) then 
		TalkingLocal = false
	end
end


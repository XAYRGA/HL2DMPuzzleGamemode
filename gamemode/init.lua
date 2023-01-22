
include( 'shared.lua' )
AddCSLuaFile('shared.lua')

for k,v in pairs (file.Find("puzzles/gamemode/shared/*.lua","LUA")) do
   MsgC(Color(251,53,255,255),"[GAMEMODE]: ") print("SH: " .. v )
	AddCSLuaFile("puzzles/gamemode/shared/" .. v)
	include("puzzles/gamemode/shared/" .. v);
end

for k,v in pairs (file.Find("puzzles/gamemode/server/*.lua","LUA")) do
	MsgC(Color(251,53,255,255),"[GAMEMODE]: ") print("SV: " .. v ) 
	include("puzzles/gamemode/server/" .. v);
end

for k,v in pairs (file.Find("puzzles/gamemode/client/*.lua","LUA")) do
	MsgC(Color(251,53,255,255),"[GAMEMODE]: ") print("CL: " .. v )
	AddCSLuaFile("puzzles/gamemode/client/" .. v)
end

GM.PlayerSpawnTime = {}


--[[---------------------------------------------------------
   Name: gamemode:Initialize( )
   Desc: Called immediately after starting the gamemode 
-----------------------------------------------------------]]
function GM:Initialize( )

end


--[[---------------------------------------------------------
   Name: gamemode:InitPostEntity( )
   Desc: Called as soon as all map entities have been spawned
-----------------------------------------------------------]]
function GM:InitPostEntity( )	

end
 

--[[---------------------------------------------------------
   Name: gamemode:Think( )
   Desc: Called every frame
-----------------------------------------------------------]]
function GM:Think( )

end


--[[---------------------------------------------------------
   Name: gamemode:ShutDown( )
   Desc: Called when the Lua system is about to shut down
-----------------------------------------------------------]]
function GM:ShutDown( )
   
end



function GM:ShowTeam(ply)

end 

function GM:PlayerCanJoinTeam(ply,team)
   return false 
end
include( 'shared.lua' )

for k,v in pairs (file.Find("puzzles/gamemode/shared/*.lua","LUA")) do
	print("[GAMEMODE CL]: SH : " .. v)
	include("puzzles/gamemode/shared/" .. v) ;
end
for k,v in pairs (file.Find("puzzles/gamemode/client/*.lua","LUA")) do
	print("[GAMEMODE CL]:FL_INITIALIZE: " .. v)
	include("puzzles/gamemode/client/" .. v);
end


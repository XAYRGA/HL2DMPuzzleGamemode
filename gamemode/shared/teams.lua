--[[---------------------------------------------------------
   Name: gamemode:CreateTeams()
   Desc: Note - HAS to be shared.
-----------------------------------------------------------]]

TEAM_UNASSIGNED = 0
TEAM_REBELS = 1
TEAM_COMBINE = 2

function GM:CreateTeams()


	team.SetSpawnPoint( TEAM_UNASSIGNED , "info_player_start" )


	team.SetUp(TEAM_REBELS, "Rebels", Color (255, 0, 0, 255), false)
    team.SetSpawnPoint( TEAM_REBELS, {"info_player_rebel","info_player_deathmatch"} )


	team.SetUp(TEAM_COMBINE, "Combine", Color (0, 0, 255, 255), false)
    team.SetSpawnPoint( TEAM_COMBINE, {"info_player_combine", "info_player_deathmatch"} )
end

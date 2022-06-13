MapVote = {}
MapVote.Config =  { 
    MapLimit = 24,
    TimeLimit = 28,
    AllowCurrentMap = false,
    EnableCooldown = true,
    MapsBeforeRevote = 3,
    RTVPlayerCount = 3,
    MapPrefixes = {"js_","cg_","puzzle_"}
}


function MapVote.HasExtraVotePower(ply)
	-- Example that gives admins more voting power
	--[[
    if ply:IsAdmin() then
		return true
	end 
    ]]

	return false
end


MapVote.CurrentMaps = {}
MapVote.Votes = {}

MapVote.Allow = false

MapVote.UPDATE_VOTE = 1
MapVote.UPDATE_WIN = 3



GM.ChatHints = {
    {Color(255,0,0),"Save your place by typing !cp, or clear your saved spot with !ucp"},
    {Color(255,255,0),"You can vote to change the map by using !rtv"}, 
    {Color(255,255,255),"Some puzzles may require more than one person to complete. Try working together!"},
    {Color(255,0,0),"Using a checkpoint stores your weapons, ammo, health, and velocity."}
}


local hintsEnable  = CreateConVar( "pz_hintsenabled", "1", {FCVAR_SERVER_CAN_EXECUTE} , "Enable printing hints to people in chat")

timer.Create("GameHints",140,0,function()
    if (hintsEnable:GetBool()) then 
        local v1 = math.random(1,#GAMEMODE.ChatHints)
        local vt = GAMEMODE.ChatHints[v1]

        GAMEMODE:ChatPrintAll(unpack(vt))
    end
end)


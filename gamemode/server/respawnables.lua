-- Bring a magazine to read around our broken down transportation
	

CreateConVar( "hl2mp_item_respawn_time", "2", { FCVAR_SERVER_CAN_EXECUTE } , "Respawn time for all respawnables")
HL2MP_ITEM_RESPAWN_TIME = 2
local function funcCallback(CVar, PreviousValue, NewValue)
	HL2MP_ITEM_RESPAWN_TIME = tonumber(NewValue)
end
cvars.AddChangeCallback("hl2mp_item_respawn_time", funcCallback)

local respawnables = {

	"item_healthkit",
	"item_healthvial",
	"weapon_physcannon",
	"weapon_357",
	"weapon_stunstick",
	"weapon_crowbar",
	"weapon_slam",
	"weapon_ar2",
	"weapon_smg1",
	"weapon_frag",
	"weapon_pistol",
	"weapon_crossbow",
	"weapon_shotgun",
    "weapon_rpg",
	"item_ammo_ar2",
	"item_battery",
	"item_box_buckshot",
	"item_ammo_smg1",
	"item_ammo_pistol",
	"item_smg1_grenade",	
}


function GM:AddRespawnables()
	for k,v in pairs(ents.GetAll()) do
		local dorsprn = false
		for i,str in pairs(respawnables) do
			if string.lower(v:GetClass()) == string.lower(str) then dorsprn = true end
		end
		if dorsprn == true then
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

end

hook.Add("InitPostEntity","RESP_PatchMap",GM.AddRespawnables)

hook.Add("WeaponEquip","RESP_PickupCheck",function(W)
	W.RSPPickedUp = true
end)
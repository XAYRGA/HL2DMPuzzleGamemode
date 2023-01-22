local enable = CreateConVar( "pz_compat_grenades", "1", { FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY } , "Replace grenades")


hook.Add( "PlayerCanPickupWeapon", "GrenadeFix", function( ply, weapon )
	
	if ( weapon:GetClass() == "weapon_frag" and enable:GetBool()==true ) then 
		
		local PlayerAmmoCount = ply:GetAmmoCount("Grenade")     
		local data = GAMEMODE.MaxAmmo["Grenade"]
		local ammoLimit
		if (type(data)=="function") then 
			ammoLimit = data()
		elseif (type(data)=="number") then
			ammoLimit = data  
		end    

		if (data!=nil) then 
			if (PlayerAmmoCount>=ammoLimit and ply:HasWeapon("weapon_frag_new") ) then                 
				return false
			end
			if (PlayerAmmoCount + weapon:Clip1() > ammoLimit) then
				weapon:SetClip1(ammoLimit - PlayerAmmoCount)
			end 
		end
		ply:Give( "weapon_frag_new" )  
        weapon:Remove()
        return false
	end
end )
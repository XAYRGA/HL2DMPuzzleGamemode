local debugging = CreateConVar( "pz_mpatch_debug", "0", { FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY } , "Replace grenades")
local debuggingNoTrackTrain  = CreateConVar( "pz_mpatch_debug_hide_noisy", "1", { FCVAR_SERVER_CAN_EXECUTE} , "Replace grenades")

local MapPatcher = {}

MapPatcher.CurrentPatchBank = nil
MapPatcher.PatchData = {}

GM.MapPatcher = MapPatcher

local NoisyClasses = {
    ["path_track"] = true,
    ["func_tracktrain"] = true,
    ["func_tanktrain"] = true,
}


MapPatcher.NoisyClasses = NoisyClasses 

function MapPatcher:HandleEvent(ent, input, activator, caller, data) 

    if (!IsValid(ent)) then 
        return
    end
    local entName = ent:GetName()      

    if (debugging:GetBool()==true) then
        if (debuggingNoTrackTrain:GetBool()==true and NoisyClasses[ent:GetClass()]==true) then 
            // Silence noisy classes.
        else 
            MsgC(Color(255,100,0),"[" .. ent:EntIndex() .."]")
            MsgC(Color(255,100,0),entName)
            MsgC(Color(255,255,255), "(")
            MsgC(Color(255,0,0),ent:GetClass())
            MsgC(Color(255,255,255), ") ")
            MsgC(Color(100,100,255),input)
            MsgN(" ")
        end
    end  

    if (self.CurrentPatchBank==nil) then 
        return
    end 

    local lookupString = string.format("%s#%s",string.lower(entName),string.lower(input))

    if (self.CurrentPatchBank.InputPatches[lookupString]) then 
        local lud = self.CurrentPatchBank.InputPatches[lookupString]
        lud:Execute(ent, input, activator, caller, data)
        
    end 

end
 

function MapPatcher:Load() 
    AddInputPatch = MapPatcher.AddInputPatch
    for k,v in pairs (file.Find("puzzles/gamemode/server/patches/*.lua","LUA")) do
        MsgC(Color(251,53,255,255),"[GAMEMODE - MAP PATCHER]: ") print("LD: " .. v ) 
        PATCH = {MapMatch = "",InputPatches = {}}    
        include("puzzles/gamemode/server/patches/" .. v);
        self.PatchData[#self.PatchData + 1] = PATCH 
        PATCH = nil
    end  
    AddInputPatch = nil 
end 


function MapPatcher.AddInputPatch(str, func)
    PATCH.InputPatches[string.lower(str)] = {Execute = func}
end 
 
function MapPatcher:SelectPatchBank() 
    for k,v in pairs(self.PatchData) do 
        if (type(v.MapMatch)=="string") then 
            local matchAny = v.MapMatch[#v.MapMatch] 
            if (matchAny=="*") then 
                local mapName = string.sub(v.MapMatch,1,#v.MapMatch - 1)
                if (string.find(string.lower(game.GetMap()),string.lower(mapName))) then 
                    self.CurrentPatchBank = v 
                    return
                end 
            else
                if (string.lower(game.GetMap()) == string.lower(v.MapMatch)) then 
                    self.CurrentPatchBank = v 
                    return 
                end
            end              
        elseif (type(v.MapMatch)=="function") then 
            local res = v.MapMatch()
            if (res==true) then 
                self.CurrentPatchBank = v
                return
            end
        end 
    end 
end

function MapPatcher:InitPatchBank()
    if (self.CurrentPatchBank) then 
        if (self.CurrentPatchBank.Initialize) then 
            self.CurrentPatchBank:Initialize()
        end 
    end 
end 

if (!MAPPATCH_ALREADY_INITD) then 
    hook.Add("Initialize","GM:MapPatcher",function()
        MapPatcher:Load() 
    end)
    hook.Add("InitPostEntity","GM:MapPatcher",function()
        MapPatcher:SelectPatchBank() 
        MapPatcher:InitPatchBank()
    end)
    MAPPATCH_ALREADY_INITD = true 
else  
    MapPatcher:Load()
    MapPatcher:SelectPatchBank() 
    MapPatcher:InitPatchBank()
end 

hook.Add("AcceptInput","GM:MapPatch",function(...)
    MapPatcher:HandleEvent(...)
end)
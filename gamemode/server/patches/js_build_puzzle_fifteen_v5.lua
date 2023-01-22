PATCH.MapMatch = "js_build_puzzle_fifteen_v5"


function PATCH:Initialize()
    print("Patched broken spawn trigger!")
    if (IsValid(Entity(196))) then 
        Entity(196):Remove()
    end
end 
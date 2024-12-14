local External = require(game.ReplicatedStorage.Modules.Utils.External)


local Monsters = {}

print('HI DO I EVER GET RUN')

function Monsters:GetListOfMonsterClasses()
    
    local returnDict = {}
    
    local classDirectory
    
    if game:GetService("RunService"):IsServer() then
        classDirectory = game.ServerScriptService.Classes.Monsters
    else
        classDirectory = game.Players.LocalPlayer.PlayerScripts.Scripts.Classes.Monsters
    end

    for _, instance in pairs(classDirectory:GetChildren()) do
        if instance:IsA("ModuleScript") then
            returnDict[instance.Name] = External:import(instance)
        end
    end

    return returnDict
end


return Monsters
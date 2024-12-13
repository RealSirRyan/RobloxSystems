local External = require(game.ReplicatedStorage.Modules.Utils.External)

local activeMonsters = {}
local monsterClasses = {}


local Monsters = {}


function Monsters:_initMonster(className, model)

    if monsterClasses[className] then
        local monster = monsterClasses[className](model)
        activeMonsters[model] = monster
    end
end


function Monsters:_updateMonster(model, ...)
    local monster = activeMonsters[model]
    if monster and monster.update then
        monster:update(...)
    end
end


function Monsters:main()

    self.remotes = External:getRemotes(script)


    for _, instance in pairs (game.Players.LocalPlayer.PlayerScripts.Scripts.Classes.Monsters:GetChildren()) do
        if instance:IsA("ModuleScript") then
            monsterClasses[instance.Name] = External:import(instance)
        end
    end

	self.remotes.InitMonsterOnClient.OnClientEvent:Connect(function(...)
		self:_initMonster(...)
	end)

	self.remotes.UpdateMonsterOnClient.OnClientEvent:Connect(function(...)
		self:_updateMonster(...)
	end)

    --Ask the server to send us all the currently active monsters
	self.remotes.InitAllMonstersOnClient:FireServer()
end

return Monsters
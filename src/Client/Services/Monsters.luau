local Initialization = require(game.ReplicatedStorage.Modules.Utils.Initialization)

local Monsters = {}


function Monsters:initMonster(className, model)

    if self.monsterClasses[className] then
        local monster = self.monsterClasses[className](model)
        self.monsters[model] = monster
    end
end


function Monsters:updateMonster(model, func, ...)
    local monster = self.monsters[model]
    if monster then
        if monster[func] then
            --TODO: Do better error handling
            monster[func](monster, ...)
        end
    end
end


function Monsters:main()
    
    self.remotes = Initialization:getRemotes(script)

    -- List of all monsters
    self.monsters = {}

    -- List of all monster classes
    self.monsterClasses = {}

    for _, instance in pairs (game.Players.LocalPlayer.PlayerScripts.Scripts.Classes.Monsters:GetChildren()) do
        if instance:IsA("ModuleScript") then
            self.monsterClasses[instance.Name] = require(instance)
        end
    end


	self.remotes.InitMonster.OnClientEvent:Connect(function(...)
		self:initMonster(...)
	end)

	self.remotes.UpdateMonster.OnClientEvent:Connect(function(...)
		self:UpdateMonster(...)
	end)

    --Ask the server to send us all the currently active monsters    
	self.remotes.InitAllMonsters:FireServer()
end

Monsters:main()

return Monsters
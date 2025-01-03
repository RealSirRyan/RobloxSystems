local External = require(game.ReplicatedStorage.Modules.Utils.External)

local activeMonsters = {}
local monsterClasses = {}


local Monsters = {}


function Monsters:_initMonster(className, model, config)
    if monsterClasses[className] then
        local monster = monsterClasses[className](model, config)
        activeMonsters[model] = monster
    end
end


function Monsters:_updateMonster(model, ...)
    
    local monster = activeMonsters[model]
    
    if monster and monster.update then
        monster:update(...)
    end
end


function Monsters:_updateMonsterConfig(model, ...)
    
    local monster = activeMonsters[model]
    if monster and monster.update then
        monster:updateConfig(...)
    end
end


function Monsters:main()

    self.remotes = External:getRemotes(script)
    self.replicated = External:getReplicated(script)

    monsterClasses = self.replicated:GetListOfMonsterClasses()

    
	self.remotes.InitMonsterOnClient.OnClientEvent:Connect(function(...)
		self:_initMonster(...)
	end)

	self.remotes.UpdateMonsterOnClient.OnClientEvent:Connect(function(...)
		self:_updateMonster(...)
	end)

    self.remotes.UpdateMonsterConfigOnClient.OnClientEvent:Connect(function(...)
        self:_updateMonsterConfig(...)
    end)

    --Ask the server to send us all the currently active monsters
	self.remotes.InitAllMonstersOnClient:FireServer()
end

return Monsters
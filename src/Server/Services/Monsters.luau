local Run = game:GetService("RunService")

local External = require(game.ReplicatedStorage.Modules.Utils.External)

local rng = Random.new()

local monsterClasses = {}
local activeMonsters = {}


local Monsters = {}


function Monsters:spawn(className, position, configPreset)
    if type(className) == "string" then
        
        local monsterClass = monsterClasses[className]

        local monster = monsterClass(configPreset)

        table.insert(activeMonsters, monster)

        monster.model.Parent = workspace
        monster.model:SetPrimaryPartCFrame(CFrame.Angles(0, rng:NextNumber() * 2 * math.pi, 0) + position)

        for _, player in pairs (game.Players:GetPlayers()) do
            self:_initMonsterOnClient(player, monster)
        end
    end
end


function Monsters:updateMonsterOnAllClients(monster, ...)
    
    self.remotes.UpdateMonsterOnClient:FireAllClients(monster.model, ...)
end


function Monsters:updateMonsterConfigOnAllClients(monster, ...)
    self.remotes.UpdateMonsterConfigOnClient:FireAllClients(monster.model, ...)
end




function Monsters:_initMonsterOnClient(player, monster)
    self.remotes.InitMonsterOnClient:FireClient(player, monster.replicated.className, monster.model, monster.config)
end


function Monsters:main()
    
    self.remotes = External:getRemotes(script)
    self.replicated = External:getReplicated(script)

    monsterClasses = self.replicated:GetListOfMonsterClasses()


    for i = 1, 10 do
        self:spawn('Vampire', Vector3.new(0, 0, 10 * i))
    end
    

    self.remotes.InitAllMonstersOnClient.OnServerEvent:Connect(function(player)
        for _, monster in pairs (activeMonsters) do
            self:_initMonsterOnClient(player, monster)
        end
    end)

    
    while task.wait(0.5) do
        for _, monster in pairs (activeMonsters) do
            if monster.tick then
                monster:tick()
            end
        end
    end
end

return Monsters
local Run = game:GetService("RunService")

local External = require(game.ReplicatedStorage.Modules.Utils.External)
local Generic

local activeMonsters = {}


local Monsters = {}


function Monsters:updateMonsterOnAllClients(monster, ...)
    self.remotes.UpdateMonsterOnClient:FireAllClients(monster.model, ...)    
end




function Monsters:_initMonsterOnClient(player, monster)
    self.remotes.InitMonsterOnClient:FireClient(player, monster.replicated.className, monster.model)
end


function Monsters:main()
    
    Generic = External:import(game.ServerScriptService.Classes.Monsters.Generic)

    self.remotes = External:getRemotes(script)


    local newMonster = Generic()
    table.insert(activeMonsters, newMonster)

    newMonster.model.Parent = workspace
    newMonster.model:SetPrimaryPartCFrame(CFrame.new(0, 0, 0))

    for _, player in pairs (game.Players:GetPlayers()) do
       self:_initMonsterOnClient(player, newMonster)
    end

    Run.Heartbeat:Connect(function()
        newMonster:tick()
    end)


    self.remotes.InitAllMonstersOnClient.OnServerEvent:Connect(function(player)
        for _, monster in pairs (activeMonsters) do
            self:_initMonsterOnClient(player, monster)
        end
    end)

end

return Monsters
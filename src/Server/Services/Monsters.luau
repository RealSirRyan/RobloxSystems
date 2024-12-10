local Run = game:GetService("RunService")

local Initialization = require(game.ReplicatedStorage.Modules.Utils.Initialization)
local GenericMonster = require(game.ServerScriptService.Classes.Monsters.Generic)

local Monsters = {}


function Monsters:initAllMonsters(player)
    
    for _, monster in pairs (self.monsters) do
        monster:initClient(player)
    end
end


function Monsters:main()
    
    self.remotes = Initialization:getRemotes(script)
    
    self.monsters = {}


    local newMonster = GenericMonster()
    table.insert(self.monsters, newMonster)

    newMonster.model.Parent = workspace
    newMonster.model:SetPrimaryPartCFrame(CFrame.new(0, 0, 0))


    for _, plr in pairs (game.Players:GetPlayers()) do
        newMonster:initClient(plr)
    end

    Run.Heartbeat:Connect(function()
        newMonster:tick()
    end)


    self.remotes.InitAllMonsters.OnServerEvent:Connect(function(...)
        self:initAllMonsters(...)
    end)

end

Monsters:main()


return Monsters
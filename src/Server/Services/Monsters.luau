local RunService = game:GetService("RunService")

local GenericMonster = require(game.ServerScriptService.Classes.Monsters.Generic)

local Monsters = {}


function Monsters:main()
    local newMonster = GenericMonster()
    print(newMonster)

    newMonster.model.Parent = workspace
    newMonster.model:SetPrimaryPartCFrame(CFrame.new(0, 0, 0))

    RunService.Heartbeat:Connect(function()
        newMonster:tick()
    end)
end


return Monsters
local External = require(game.ReplicatedStorage.Modules.Utils.External)
local Class = External:import(game.ReplicatedStorage.Modules.Utils.Class)
local Generic = External:import(game.Players.LocalPlayer.PlayerScripts.Scripts.Classes.Monsters.Generic)

local walkAnimation = Instance.new("Animation")
local idleAnimation = Instance.new("Animation")


local Vampire = Class.new{super=Generic}


function Vampire:init(model, config)
    self.super.init(self, model, config)

    -- Applying properties from configs
    if config.headColour then
        model['Body Colors'].HeadColor3 = config.headColour
    end

    if config.face then
        config.face:Clone().Parent = model.Head
    end
end


function Vampire:main()
    self.replicated = External:getReplicated(script)
end


return Vampire
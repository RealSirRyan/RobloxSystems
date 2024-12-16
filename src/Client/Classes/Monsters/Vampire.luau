local External = require(game.ReplicatedStorage.Modules.Utils.External)
local Class = External:import(game.ReplicatedStorage.Modules.Utils.Class)
local Generic = External:import(game.Players.LocalPlayer.PlayerScripts.Scripts.Classes.Monsters.Generic)

local walkAnimation = Instance.new("Animation")
local idleAnimation = Instance.new("Animation")


local Vampire = Class.new{super=Generic}


function Vampire:init(model, config)
    self.super.init(self, model, config)
end


function Vampire:main()
    self.replicated = External:getReplicated(script)
end


return Vampire
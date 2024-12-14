local External = require(game.ReplicatedStorage.Modules.Utils.External)
local Class = External:import(game.ReplicatedStorage.Modules.Utils.Class)
local Generic = External:import(game.ServerScriptService.Classes.Monsters.Generic)

local vampireFaces = {game.ReplicatedStorage.Monsters.Faces.Vampire, game.ReplicatedStorage.Monsters.Faces.ClassicVampire, game.ReplicatedStorage.Monsters.Faces.EpicVampire}


local Vampire = Class.new{super=Generic}


function Vampire:init()
    self.super.init(self)

    -- Putting something in config
    self.config.headColour = BrickColor.random().Color
    self.config.face = vampireFaces[math.random(1, #vampireFaces)]
end


function Vampire:main()
    self.replicated = External:getReplicated(script)
end

return Vampire
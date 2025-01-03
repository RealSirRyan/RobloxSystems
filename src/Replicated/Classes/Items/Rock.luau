local External = require(game.ReplicatedStorage.Modules.Utils.External)
local Class = External:import(game.ReplicatedStorage.Modules.Utils.Class)
local Generic = External:import(game.ReplicatedStorage.Modules.Classes.Items.Generic)


local Rock = Class.new{super = Generic}


function Rock:init(quantity)
    self.super.init(self, quantity)
end


function Rock:main()
    self.id = script.Name
    self.displayName = "Rock"
end

return Rock
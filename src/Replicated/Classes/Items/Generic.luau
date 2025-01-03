local External = require(game.ReplicatedStorage.Modules.Utils.External)
local Class = External:import(game.ReplicatedStorage.Modules.Utils.Class)


local Generic = Class.new{}


function Generic:init(quantity)
    self.quantity = quantity or 1
end


function Generic:main()
    self.id = script.Name
    self.stackable = true
    self.displayName = "Generic"
end

return Generic
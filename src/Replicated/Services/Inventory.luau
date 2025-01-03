local External = require(game.ReplicatedStorage.Modules.Utils.External)


local Inventory = {}


function Inventory:main()
    self.remotes = External:getRemotes(script)
end

return Inventory
local External = require(game.ReplicatedStorage.Modules.Utils.External)

local itemsDir = game.ReplicatedStorage.Modules.Classes.Items


local Items = {}


function Items:spawn(id, quantity)
    if itemsDir:FindFirstChild(id) then
        return External:import(itemsDir:FindFirstChild(id))(quantity)
    end
end

return Items
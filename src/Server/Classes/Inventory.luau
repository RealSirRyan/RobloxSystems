local External = require(game.ReplicatedStorage.Modules.Utils.External)
local Class = External:import(game.ReplicatedStorage.Modules.Utils.Class)
local Items = External:import(game.ServerScriptService.Services.Items)


local Inventory = Class.new{}


--[[
    Add an item to the inventory
]]
function Inventory:addItem(item, slot)

    if item then
        if slot and type(slot) == "number" and slot <= self.size then
            -- Add the item to a specified slot
    
            local otherItem = self.contents[slot]
    
            if otherItem then
                -- An Item exists in that slot. already. Is it able to stack?
                if otherItem.id == item.id and item.stackable then
                    otherItem.quantity += item.quantity
                    return true
                else
                    return false
                end
            
            else
                -- When there is no item in this slot
                self.contents[slot] = item
            end
        
        else
            -- No slot specified. Add to first avalible slot

            -- Check if there is an item of the same type this can stack onto
            if item.stackable then
                for _, otherItem in pairs(self.contents) do
                    if otherItem.id == item.id then
                        otherItem.quantity += item.quantity
                        return true
                    end
                end
            end

            -- Check if there is an empty slot the item can be put into
            for i = 1, self.size do
                if not self.contents[i] then
                    self.contents[i] = item
                    return true
                end
            end
        end
    end
    return false
end

--[[
    Locates an item in the inventory by id, removes it, and returns the item.
    It can add up the quantities of multiple of the same items to reach the specified quantity.
]]
function Inventory:withdrawById(id, withdrawQuantity)
    withdrawQuantity = withdrawQuantity or 1

    -- Searching for items...

    local totalQuantityFound = 0
    local selectedItems = {}

    for _, item in pairs (self.contents) do
        if item.id == id then

            -- This is the same itemtype that we want!
            totalQuantityFound += item.quantity
            table.insert(selectedItems, item)


            if totalQuantityFound >= withdrawQuantity then
                -- There is enough of that item in the inventory
                local returnItem = Items:spawn(id, 0)

                for _, item in pairs(selectedItems) do
                    local extractedQuantity = math.min(item.quantity, withdrawQuantity - returnItem.quantity)

                    item.quantity = item.quantity - extractedQuantity
                    returnItem.quantity += extractedQuantity

                    -- If the item has a quantity of 0, it must be removed!
                    if item.quantity == 0 then
                        self:_removeItem(item)
                    end
                end

                return returnItem
            end

        end
    end

    return false
end


--[[
    Searches for the specified item, and remove it from the inventory

]]
function Inventory:_removeItem(item)
    for i, otherItem in pairs (self.contents) do
        if otherItem == item then
            self.contents[i] = nil      
        end
    end
end



function Inventory:init(size)
    self.size = size or 1
    self.contents = {}
end


function Inventory:main()

    self.users = {}

    self.remotes = External:getRemotes(script)

    local newItem = Items:spawn("Generic", 3)
    
    local newInventory = self(100)
    --newInventory:withdrawById("Generic", 16)
   
    local success = newInventory:addItem(Items:spawn("Rock", 3), 4)
    newInventory:addItem(Items:spawn("Generic", 3), 7)

    local returnedItem = newInventory:withdrawById("Generic", 4)

    print(newInventory)
    warn(newInventory.contents[4].displayName)
end

return Inventory
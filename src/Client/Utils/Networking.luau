local Initialization = require(game.ReplicatedStorage.Modules.Utils.Initialization)

local Networking = {}

--[[
    Yield until all descendants of an instance are loaded
]]
function Networking:waitForDescendants(instance)
    local fullCount = self.remotes.GetDescendantsCurrentCount:InvokeServer(instance)
    
    if fullCount then
        local currentCount = #instance:GetDescendants()

        while currentCount < fullCount do
            local descendant = instance.DescendantAdded:Wait()
            if not self.replicated:isIgnored(descendant) then
                currentCount +=1
            end
        end        
    end
end


function Networking:main()
    self.remotes = Initialization:getRemotes(script)
end

Networking:main()


return Networking     
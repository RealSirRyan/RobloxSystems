local External = require(game.ReplicatedStorage.Modules.Utils.External)


local Networking = {}

--[[
    Yield until all descendants of an instance are loaded
]]
function Networking:waitForDescendants(instance)
    local fullCount = self.remotes.GetFullDescendantsCount:InvokeServer(instance)
    
    if fullCount then
        local currentCount = #instance:GetDescendants()

        while currentCount < fullCount do
            local descendant = instance.DescendantAdded:Wait()
            if not self.replicated:isIgnored(descendant) then
                currentCount += 1
            end
        end
    end
end


function Networking:main()
    self.remotes = External:getRemotes(script)
    self.replicated = External:getReplicated(script)
end

return Networking     
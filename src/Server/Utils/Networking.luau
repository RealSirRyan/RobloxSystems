local External = require(game.ReplicatedStorage.Modules.Utils.External)


local Networking = {}


function Networking:_getDescendantCount(instance)
    
    if instance then
        local descendantCount = 0

        for _, descendant in pairs(instance:GetDescendants()) do
            
            if not self.replicated:isIgnored(descendant) then 
                descendantCount+=1
            end
        end
        
        return descendantCount
    end
end


function Networking:main()

    self.remotes = External:getRemotes(script)
    self.replicated = External:getReplicated(script)

    
    self.remotes.GetFullDescendantsCount.OnServerInvoke = function(_, ...)
        return self:_getDescendantCount(...)
    end
end

return Networking
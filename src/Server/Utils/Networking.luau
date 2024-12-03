local Networking = {}


function Networking:_returnDescendantCount(_, instance)
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
  
    self.remotes.GetDescendantsCurrentCount.OnServerInvoke = function()
        return self:_returnDescendantCount()
    end
end


return Networking
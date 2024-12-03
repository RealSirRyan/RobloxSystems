local Run = game:GetService('RunService')

local Networking = {}

--Wait for all the descendants of an object to load
function Networking:waitForDescendants(instance)
    if Run:IsClient() then
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
end


return Networking     
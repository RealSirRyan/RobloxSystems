local Networking = {}

function Networking:isIgnored(instance)
    if instance:IsA("Camera") then
        return true
    end
end

return Networking
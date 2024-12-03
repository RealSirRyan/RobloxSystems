local Run = game:GetService("RunService")

local Initialization = {}

function Initialization:getReplicatedSide(scriptInstance)
    local otherScriptInstace = self.replicatedScriptsDir:FindFirstChild(scriptInstance.Name, true)
    if otherScriptInstace and otherScriptInstace:IsA("ModuleScript") then
        return require(otherScriptInstace)
    end
end

function Initialization:getClientSide(scriptInstance)
    if Run:IsClient() then
        local otherScriptInstace = self.clientScriptsDir:FindFirstChild(scriptInstance.Name, true)
        if otherScriptInstace and otherScriptInstace:IsA("ModuleScript") then
            return require(otherScriptInstace)
        end
    end
end

function Initialization:getServerSide(scriptInstance)
    if Run:IsServer() then
        local otherScriptInstace = self.serverScriptsDir:FindFirstChild(scriptInstance.Name, true)
        if otherScriptInstace and otherScriptInstace:IsA("ModuleScript") then
            return require(otherScriptInstace)
        end
    end
end

function Initialization:getRemotes(scriptInstance)
    local remotes = self.remotesDir:FindFirstChild(scriptInstance.Name, true)
    if remotes and remotes:IsA("Folder") then
        return remotes
    end
end

function Initialization:initDir(dir)
    for _, instance in pairs (dir:GetDescendants()) do
        if instance:IsA('ModuleScript') then
            local startTime = os.clock()
            require(instance)
            local deltaTime = os.clock()-startTime
            print('Initialized Module "'..instance.Name..'". Took '..tostring(deltaTime)..' seconds!')
        end
    end
end

function Initialization:main()
    self.serverScriptsDir = game.ServerScriptService
    self.replicatedScriptsDir = game.ReplicatedStorage.Modules
    self.remotesDir = game.ReplicatedStorage.Remotes

    if Run:IsClient() then
        self.clientScriptsDir = game.Players.LocalPlayer.PlayerScripts
    end
end

Initialization:main()

return Initialization
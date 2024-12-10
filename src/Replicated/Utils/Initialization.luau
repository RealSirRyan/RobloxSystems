local Run = game:GetService("RunService")

local PRINT_MODULES = false

local Initialization = {}


function Initialization:getReplicated(scriptInstance)
    local otherScriptInstace = self.replicatedScriptsDir:FindFirstChild(scriptInstance.Name, true)
    if otherScriptInstace and otherScriptInstace:IsA("ModuleScript") then
        return require(otherScriptInstace)
    end
end


function Initialization:getClient(scriptInstance)
    if Run:IsClient() then
        local otherScriptInstace = self:_findSimilarPath(scriptInstance, self.clientScriptsDir)
        if otherScriptInstace and otherScriptInstace:IsA("ModuleScript") then
            return require(otherScriptInstace)
        end
    end
end


function Initialization:getServer(scriptInstance)
    if Run:IsServer() then
        local otherScriptInstace = self:_findSimilarPath(scriptInstance, self.serverScriptsDir)
        if otherScriptInstace and otherScriptInstace:IsA("ModuleScript") then
            return require(otherScriptInstace)
        end
    end
end


function Initialization:getRemotes(scriptInstance)

    local remotes = self:_findSimilarPath(scriptInstance, self.remotesDir)
    if remotes and remotes:IsA("Folder") then
        return remotes
    end
end


function Initialization:_findSimilarPath(instance, otherPathRoot)
    local levels = {}
    
    local level = instance
    while level ~= self.replicatedScriptsDir and level ~= self.clientScriptsDir and level ~= self.serverScriptsDir and level ~= game do
        table.insert(levels, level)
        level = level.Parent
    end

    local level = otherPathRoot
    for i = 0, #levels-1 do
        local child = level:FindFirstChild((levels[#levels-i]).Name)
        if child then
            level = child
        else
            return nil
        end
    end

    return level
end


function Initialization:initDir(dir)
    for _, instance in pairs (dir:GetDescendants()) do
        print(instance)
        if instance:IsA("ModuleScript") then
            local success, error = pcall(function()
                local startTime = os.clock()
                require(instance)
                local deltaTime = os.clock()-startTime
                if PRINT_MODULES then
                    print('Initialized Module "'..instance.Name..'". Took '..tostring(deltaTime)..' seconds!')    
                end
            end)
            
            if not success then
                warn(error)
            end
        end
    end
end


function Initialization:main()
    self.serverScriptsDir = game.ServerScriptService
    self.replicatedScriptsDir = game.ReplicatedStorage.Modules
    self.remotesDir = game.ReplicatedStorage.Remotes

    if Run:IsClient() then
        self.clientScriptsDir = game.Players.LocalPlayer.PlayerScripts.Scripts
        warn(self.clientScriptsDir)
    end
end

Initialization:main()


return Initialization
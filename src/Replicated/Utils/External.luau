local Run = game:GetService("RunService")

local serverScriptsDir = game.ServerScriptService
local clientScriptsDir
local replicatedScriptsDir = game.ReplicatedStorage.Modules
local remotesDir = game.ReplicatedStorage.Remotes

local assets

local mainRanModules = {}


local External = {}


function External:getReplicated(script)
    
    local replicatedScript = self:findFirstDescendantOfClassAndName(replicatedScriptsDir, script.Name, "ModuleScript")
    if replicatedScript and replicatedScript:IsA("ModuleScript") then
        return self:import(replicatedScript)
    end
end


function External:getClient(script)
    
    if Run:IsClient() and not clientScriptsDir:IsAncestorOf(script) then
        local clientScript = self:findFirstDescendantOfClassAndName(clientScriptsDir, script.Name, "ModuleScript")
        if clientScript and clientScript:IsA("ModuleScript") then
            return self:import(clientScript)
        end
    end
end


function External:getServer(script)
    
    if Run:IsServer() and not serverScriptsDir:IsAncestorOf(script) then
        local serverScript = self:findFirstDescendantOfClassAndName(serverScriptsDir, script.Name, "ModuleScript")
        if serverScript and serverScript:IsA("ModuleScript") then
            return self:import(serverScript)
        end
    end
end


function External:getRemotes(script)

    local remotes = self:findFirstDescendantOfClassAndName(remotesDir, script.Name, "Folder")
    if remotes and remotes:IsA("Folder") then
        return remotes
    end
end


function External:import(moduleScript)
    local module = require(moduleScript)
    
    if not table.find(mainRanModules, module) and module.main then
        table.insert(mainRanModules, module)
        module:main()
    end
    
    return module
end


function External:findFirstDescendantOfClassAndName(ancestor, name, class)
    
    for _, descendant in pairs (ancestor:GetDescendants()) do

        if descendant.Name == name and descendant.ClassName == class then
            return descendant
        end
    end
end


function External:getAssets()
    return assets
end




function External:_initDir(dir)
    
    for _, instance in pairs (dir:GetDescendants()) do
        if instance:IsA("ModuleScript") and instance ~= script then
            task.spawn(function()
            
                local success, error = pcall(function()
                    self:import(instance)
                end)
                
                if not success then
                    warn(error)
                end    
            end)
        end
    end
end


function External:initAll()
    if Run:IsServer() then
        
        assets = workspace.Assets
        assets.Parent = game.ReplicatedStorage
        
        self:_initDir(serverScriptsDir)
        self:_initDir(replicatedScriptsDir)
    else
        
        assets = game.ReplicatedStorage:WaitForChild("Assets")
        
        clientScriptsDir = game.Players.LocalPlayer.PlayerScripts.Scripts

        self:_initDir(clientScriptsDir)
        self:_initDir(replicatedScriptsDir)
    end
end

return External
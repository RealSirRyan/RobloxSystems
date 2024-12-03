local Run = game:GetService("RunService")

local Init = {}

Init.SERVER_SCRIPTS_DIR = game.ServerScriptService
Init.REPLICATED_SCRIPTS_DIR = game.ReplicatedStorage.Scripts
Init.REMOTES_DIR = game.ReplicatedStorage.Remotes
if Run:IsClient() then
    Init.CLIENT_SCRIPTS_DIR = game.Players.LocalPlayer.PlayerScripts
end


-- Inject attributes into a module
function Init:inject(moduleInstance)

    local module = require(moduleInstance)

    -- INJECT .remotes
    local remotes = self.REMOTES_DIR:FindFirstChild(moduleInstance.Name, true)
    if remotes and remotes:IsA("Folder") then
        module.remotes = remotes
    end

    -- INJECT .client, .server or .replicated
    if moduleInstance:IsDescendantOf(self.REPLICATED_SCRIPTS_DIR) then
        
        if Run:IsServer() then
            
            -- ADD A .server ATTRIBUTE
            local serverModuleInstance = self.SERVER_SCRIPTS_DIR:FindFirstChild(moduleInstance.Name, true)
            if serverModuleInstance and serverModuleInstance:IsA("ModuleScript") then
                module.server = require(serverModuleInstance)
            end
        else
            
            -- ADD A .client ATTRIBUTE
            local clientModuleInstance = self.CLIENT_SCRIPTS_DIR:FindFirstChild(moduleInstance.Name, true)
            if clientModuleInstance and clientModuleInstance:IsA("ModuleScript") then
                module.client = require(clientModuleInstance)
            end
        end
    
    else
        
        -- ADD A .replicated ATTRIBUTE
        local replicatedModuleInstance = self.REPLICATED_SCRIPTS_DIR:FindFirstChild(moduleInstance.Name, true)
        if replicatedModuleInstance and replicatedModuleInstance:IsA("ModuleScript") then
            warn('Adding replicated value')
            module.replicated = require(replicatedModuleInstance)
        end
    end
end


--Run a module's 'main' function
function Init:start(moduleInstance)
    local module = require(moduleInstance)
    if module.main then
        task.spawn(function()
            module:main()
        end)
    end
end


--Inject attributes in all modules within 'dir'
function Init:injectModules(dir)
    for _, instance in pairs (dir:GetDescendants()) do
        if instance:IsA("ModuleScript") and instance ~= script then
            
            local success, msg = pcall(function()
                self:inject(instance)  
            end)
            if not success then
                warn('Error Injecting properties into module '..instance.Name..'. '..msg)
            end
        end
    end
end

-- Start all modules within 'dir'
function Init:startModules(dir)
    for _, instance in pairs (dir:GetDescendants()) do
        if instance:IsA("ModuleScript") and instance ~= script then
            local success, msg = pcall(function()
                self:start(instance)
            end)
            if not success then
                warn('Error Injecting properties into module '..instance.Name..'. '..msg)
            end
        end
    end
end


--Initiate everything
function Init:initAll()
    
    -- INJECT

    if Run:IsClient() then
        self:injectModules(self.CLIENT_SCRIPTS_DIR)
    else
        self:injectModules(self.SERVER_SCRIPTS_DIR)
    end

    self:injectModules(self.REPLICATED_SCRIPTS_DIR)

    -- START

    if Run:IsClient() then
        self:startModules(self.CLIENT_SCRIPTS_DIR)
    else
        self:startModules(self.SERVER_SCRIPTS_DIR)
    end

    self:startModules(self.REPLICATED_SCRIPTS_DIR)
end


return Init
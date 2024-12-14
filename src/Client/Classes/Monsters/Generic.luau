local External = require(game.ReplicatedStorage.Modules.Utils.External)
local Class = External:import(game.ReplicatedStorage.Modules.Utils.Class)
local Networking


local Generic = Class.new{}


function Generic:update(...)
--[[
	if state == self.replicated.states.idle then
		
		self.walk:Stop()
		self.idle:Play()		
	elseif state == self.replicated.states.walk then
		
		self.idle:Stop()
		self.walk:Play()
	end ]]
end


function Generic:init(model, config)

	warn(config)

	--Verify all instances are loaded
	Networking:waitForDescendants(model)
	Networking:waitForDescendants(self.replicated.modelTemplate)
	
	self.humanoid = model:WaitForChild("Humanoid")

	-- self.idle = self.humanoid:LoadAnimation(idleAnimation)
	-- self.walk = self.humanoid:LoadAnimation(walkAnimation)

	model.PrimaryPart.Transparency = 1

	local modelClone = self.replicated.modelTemplate:Clone()
	modelClone:SetPrimaryPartCFrame(model.PrimaryPart.CFrame)

	for _, instance in pairs(modelClone:GetChildren()) do
		if not model:FindFirstChild(instance.Name) or instance:IsA("CharacterMesh") then
			instance.Parent = model
		end
	end

	local rootJoint = modelClone.PrimaryPart:WaitForChild("RootJoint")
	rootJoint.Parent = model.PrimaryPart
	rootJoint.Part0 = model.PrimaryPart
end


function Generic:main()
	
	Networking = External:import(game.Players.LocalPlayer.PlayerScripts.Scripts.Utils.Networking)

	self.replicated = External:getReplicated(script)
	
	
	--[[
	walkAnimation.AnimationId = "rbxassetid://101341174956754"
    idleAnimation.AnimationId = "rbxassetid://104484008905993"]]
end

return Generic
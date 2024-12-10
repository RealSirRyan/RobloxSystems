local Networking = require(game.ReplicatedStorage.Modules.Utils.Networking)
local Class = require(game.ReplicatedStorage.Modules.Utils.Class)
local Initialization = require(game.ReplicatedStorage.Modules.Utils.Initialization)

local Generic = Class.new{}


function Generic:changeState(state)
	if self.replicated.states.find(state) and state == self.replicated.states.idle then
		self.replicated.walk:Stop()
		self.idle:Play()		
	elseif self.replicated.states.find(state) and state == self.replicated.states.walk then
		self.idle:Stop()
		self.walk:Play()
	end 
end


function Generic:init(model)

	--Verify all instances are loaded
	Networking:waitForDescendants(model)
	Networking:waitForDescendants(self.replicated.modelTemplate)
	

	self.humanoid = model:WaitForChild("Humanoid")
	
	self.idle = self.humanoid:LoadAnimation(self.idleAnimation)
	self.walk = self.humanoid:LoadAnimation(self.walkAnimation)


	model.PrimaryPart.Transparency = 1

	local modelClone = self.modelTemplate:Clone()
	modelClone:SetPrimaryPartCFrame(model.PrimaryPart.CFrame)

	for _, inst in pairs(modelClone:GetChildren()) do
		if not model:FindFirstChild(inst.Name) or inst:IsA("CharacterMesh") then
			inst.Parent = model
		end
	end

	local rootJoint = modelClone.PrimaryPart:WaitForChild("RootJoint")
	rootJoint.Parent = model.PrimaryPart
	rootJoint.Part0 = model.PrimaryPart
end


function Generic:main()
	self.replicated = Initialization:getReplicated(script)
	self.remotes = Initialization:getRemotes(script)

    self.walkAnimation = Instance.new("Animation")
    self.idleAnimation = Instance.new("Animation")
    
    self.walkAnimation.AnimationId = "rbxassetid://101341174956754"
    self.idleAnimation.AnimationId = "rbxassetid://104484008905993"	

end

Generic:main()


return Generic
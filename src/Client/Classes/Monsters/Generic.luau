local Networking = require(game.ReplicatedStorage.Scripts.Utils.Networking)
local Class = require(game.ReplicatedStorage.Scripts.Utils.Class)

local Generic = Class.new{}


function Generic:changeState(state)
	if self.states.find(state) and state == self.states.idle then
		self.walk:Stop()
		self.idle:Play()		
	elseif self.states.find(state) and state == self.states.walk then
		self.idle:Stop()
		self.walk:Play()
	end 
end


function Generic:_init(model)

	--Verify all instances are loaded
	Networking:waitForDescendants(model)
	Networking:waitForDescendants(self.replicated.modelTemplate)
	
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


	self.humanoid = model:WaitForChild("Humanoid")
	
	self.idle = self.humanoid:LoadAnimation(self.idleAnimation)
	self.walk = self.humanoid:LoadAnimation(self.walkAnimation)
end


function Generic:main()

    self.walkAnimation = Instance.new("Animation")
    self.idleAnimation = Instance.new("Animation")
    
    self.walkAnimation.AnimationId = "rbxassetid://101341174956754"
    self.idleAnimation.AnimationId = "rbxassetid://104484008905993"	
end


return Generic
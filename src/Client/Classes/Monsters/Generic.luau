local External = require(game.ReplicatedStorage.Modules.Utils.External)
local Class = External:import(game.ReplicatedStorage.Modules.Utils.Class)
local Networking


local Generic = Class.new{}


function Generic:update(func, ...)
	if self[func] then
		self[func](self, ...)
	end
end


function Generic:updateConfig(newConfig)

	for i, v in pairs(newConfig) do
		self.config[i] = v
		
		if self.configFunctions and self.configFunctions[i] then
			
			self.configFunctions[i](self, v)
		end
	end
end




function Generic:_flashYellow()
	if self.model.Head then
		local oldColour = self.model.Head.Color
		self.model.Head.Color = Color3.new(1, 1, 0)
		task.wait(0.5)
		self.model.Head.Color = oldColour
	end
end


function Generic:_equipAccessory(accessoryTemplate)
	
	if accessoryTemplate then

		local accessory = accessoryTemplate:Clone()
		
		local handle = accessory:FindFirstChild("Handle")
		
		local accessoryAttachment = handle:FindFirstChildOfClass("Attachment")
		
		local characterAttachment

		if accessoryAttachment.Name == 'HairAttachment' then
			characterAttachment = self.model.Head.HairAttachment
		elseif accessoryAttachment.Name == "HatAttachment" then
			characterAttachment = self.model.Head.HatAttachment
		end
		
		if characterAttachment then
			accessory.Parent = self.model
		
			local weld = Instance.new("Weld")
			weld.Part0 = handle
			weld.Part1 = characterAttachment.Parent
			
			weld.C0 = accessoryAttachment.CFrame
			weld.C1 = characterAttachment.CFrame
			weld.Parent = handle
		end

	end
end


function Generic:init(model, config)

	--Verify all instances are loaded
	Networking:waitForDescendants(model)
	Networking:waitForDescendants(self.replicated.modelTemplate)
	
	self.humanoid = model:WaitForChild("Humanoid")
	self.model = model

	self.config = config

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

	-- Processing config
	

	self:updateConfig(config)

end


function Generic:main()
	
	Networking = External:import(game.Players.LocalPlayer.PlayerScripts.Scripts.Utils.Networking)

	self.replicated = External:getReplicated(script)
	

	self.configFunctions = {

        ['face'] = function(self, face)
            
            if self.model and self.model:FindFirstChild('Head') then
                local head = self.model.Head
                if head:FindFirstChildOfClass('Decal') then
                    head:FindFirstChildOfClass('Decal').Texture = face.Texture
				else
					face:Clone().Parent = head
				end
            end
        end,

		['accessories'] = function(self, accessories)
			for _, accessoryTemplate in pairs (accessories) do
				self:_equipAccessory(accessoryTemplate)
			end
		end,

		['hats'] = function(self, hats)
			for _, hat in pairs(hats) do
				self:_equipAccessory(hat)
			end
		end,

    }
	--[[
	walkAnimation.AnimationId = "rbxassetid://101341174956754"
    idleAnimation.AnimationId = "rbxassetid://104484008905993"]]
end

return Generic
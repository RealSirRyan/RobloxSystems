local External = require(game.ReplicatedStorage.Modules.Utils.External)
local Class = External:import(game.ReplicatedStorage.Modules.Utils.Class)

-- local walkCooldown = 5
-- local walkDistance = 20


local Generic = Class.new{}


function Generic:tick()
--[[
	-- Is it time to pick a new random destination?
	if self._lastWalkTime + walkCooldown < time() then

		self._targetPos = (self.primary.CFrame * CFrame.Angles(0, math.random(0, 2 * math.pi), 0) * CFrame.new(walkDistance, 0, 0)).Position
		self._lastWalkTime = time()
		
		-- Update client-side on state change
		Monsters:updateMonsterOnAllClients(self, self.replicated.states.walk)
	end

    -- Move to the target position
	if self._targetPos then
		
		self.humanoid:MoveTo(self._targetPos)

		-- Set to idle if destination is reached
		if (self._targetPos-self.primary.Position).magnitude < 3 then
			
            self.humanoid:MoveTo(self.primary.Position)
			self._targetPos = nil
			
            -- Update clients on state change
            Monsters:updateMonsterOnAllClients(self, self.replicated.states.idle)
		end
	end]]
end


function Generic:init()
	
	-- self._lastWalkTime = 0
	-- self._targetPos = nil

	self.config = {}

	self.model = self.replicated.modelTemplate:Clone()
	self.humanoid = self.model:WaitForChild("Humanoid")
    self.primary = self.model.PrimaryPart

	-- Removing unneeded instances on the server-side
    for _, instance in pairs(self.model:GetDescendants()) do
        if instance ~= self.humanoid and instance ~= self.primary then
            instance:Destroy()
        end
    end

	-- Disable unneeded humanoid states
	self.humanoid:SetStateEnabled(0, false)-- Falling
	self.humanoid:SetStateEnabled(1, false)-- Ragdoll
	self.humanoid:SetStateEnabled(2, false)-- Getting Up
	self.humanoid:SetStateEnabled(3, false)-- Jumping
	self.humanoid:SetStateEnabled(4, false)-- Swimming
	self.humanoid:SetStateEnabled(5, false)-- Freefall
	self.humanoid:SetStateEnabled(6, false)-- Flying
	self.humanoid:SetStateEnabled(7, false)-- Landed
	self.humanoid:SetStateEnabled(8, true)-- Running
	self.humanoid:SetStateEnabled(10, true)-- Running No Physics
	self.humanoid:SetStateEnabled(11, false)-- Strafing No Physics
	self.humanoid:SetStateEnabled(12, false)-- Climbing
	self.humanoid:SetStateEnabled(13, false)-- Seated
	self.humanoid:SetStateEnabled(14, false)-- Platform Standing (Freefalling & cannot move)
	self.humanoid:SetStateEnabled(15, false)-- Dead
	self.humanoid:SetStateEnabled(16, false)-- Physics (Humanoid applies no force on its own)
end


function Generic:main()
	
	self.replicated = External:getReplicated(script)
end

return Generic
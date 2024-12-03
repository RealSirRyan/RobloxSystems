local Class = require(game.ReplicatedStorage.Scripts.Utils.Class)

local Generic = Class.new{}


function Generic:tick()
	
	--Is it time to pick a new random destination?
	if self.lastWalkTime+self.walkCooldown < time() then

		self.targetPos = (self.primary.CFrame*CFrame.Angles(0, math.random(0, 2*math.pi), 0)*CFrame.new(self.walkDistance, 0, 0)).Position
		self.lastWalkTime=time()
		
		--Update clients on state change
		for _, plr in pairs (game.Players:GetPlayers()) do
			self:updateClient(plr, "changeState", self.replicated.states.walk)
		end
	end

    --Move to the target position
	if self.targetPos then
		print('Moving')
		print(self.targetPos)
		self.humanoid:MoveTo(self.targetPos)

		--Set to idle if destination is reached
		if (self.targetPos-self.primary.Position).magnitude < 3 then
			
            self.humanoid:MoveTo(self.primary.Position)
			self.targetPos = nil
			
            --Update clients on state change
            for _, player in pairs (game.Players:GetPlayers()) do
				self:updateClient(player, "changeState", self.states.idle)
			end
		end
	end
end

--Initialize the monster on the client side
function Generic:initClient(player)
	self.remotes.InitMonster:FireClient(player, self.replicated.className, self.model)
end

--Prompts the client-side script to fire a function
function Generic:updateClient(player, func, ...)
    self.remotes.UpdateMonster:FireClient(player, self.model, func, ...)	
end

function Generic:_init()
	self.lastWalkTime = 0
	self.targetPos = nil
	self.state = self.replicated.states.idle

	self.model = self.replicated.modelTemplate:Clone()
	self.humanoid = self.model:WaitForChild("Humanoid")
    self.primary = self.model.PrimaryPart

	--Removing unneeded instances on the server-side
    for _, inst in pairs(self.model:GetDescendants()) do
        if inst ~= self.humanoid and inst ~= self.primary then
            inst:Destroy()
        end
    end

	--Disable unneeded humanoid states
	self.humanoid:SetStateEnabled(0, false)--Falling
	self.humanoid:SetStateEnabled(1, false)--Ragdoll
	self.humanoid:SetStateEnabled(2, false)--Getting Up
	self.humanoid:SetStateEnabled(3, false)--Jumping
	self.humanoid:SetStateEnabled(4, false)--Swimming
	self.humanoid:SetStateEnabled(5, false)--Freefall
	self.humanoid:SetStateEnabled(6, false)--Flying
	self.humanoid:SetStateEnabled(7, false)--Landed
	self.humanoid:SetStateEnabled(8, true)--Running
	self.humanoid:SetStateEnabled(10, true)--Running No Physics
	self.humanoid:SetStateEnabled(11, false)--Strafing No Physics
	self.humanoid:SetStateEnabled(12, false)--Climbing
	self.humanoid:SetStateEnabled(13, false)--Seated
	self.humanoid:SetStateEnabled(14, false)--Platform Standing (Freefalling & cannot move)
	self.humanoid:SetStateEnabled(15, false)--Dead
	self.humanoid:SetStateEnabled(16, false)--Physics (Humanoid applies no force on its own)
end


function Generic:main()
	self.walkCooldown = 5
	self.walkDistance = 20
end


return Generic
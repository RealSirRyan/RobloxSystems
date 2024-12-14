local Generic = {}


function Generic:main()
	self.states = {
		['idle']=0,
		['walk']=1
	}
	self.className = script.Name
	self.modelTemplate = game.ReplicatedStorage.Monsters.Templates.Generic
end

return Generic
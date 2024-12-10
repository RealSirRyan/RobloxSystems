local Generic = {}


function Generic:main()
	self.states = {
		'idle',
		'walk'
	}

	self.className = script.Name

	self.modelTemplate = game.ReplicatedStorage.MonsterTemplate
end

Generic:main()


return Generic
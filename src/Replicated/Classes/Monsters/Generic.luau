local Generic = {}

Generic.states = {
	'idle',
	'walk'

}

Generic.className = script.Name
Generic.modelTemplate = game.ReplicatedStorage.MonsterTemplate

function Generic:main()
	self.states = {
		'idle',
		'walk'
	}

	self.className = script.Name

	Generic.modelTemplate = game.ReplicatedStorage.MonsterTemplate
end


return Generic
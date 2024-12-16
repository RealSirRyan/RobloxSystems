local External = require(game.ReplicatedStorage.Modules.Utils.External)


local Generic = {}


function Generic:main()
	self.states = {
		['idle']=0,
		['walk']=1
	}
	self.className = script.Name
	self.modelTemplate = External:getAssets().MonsterTemplates.Generic
end

return Generic
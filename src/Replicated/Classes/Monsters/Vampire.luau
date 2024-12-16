local External = require(game.ReplicatedStorage.Modules.Utils.External)


local Vampire = {}


function Vampire:main()
    self.className = script.Name
    self.modelTemplate = External:getAssets().MonsterTemplates.Vampire
end

return Vampire
local External = require(game.ReplicatedStorage.Modules.Utils.External)
local Class = External:import(game.ReplicatedStorage.Modules.Utils.Class)
local Generic = External:import(game.ServerScriptService.Classes.Monsters.Generic)
local Rng = External:import(game.ReplicatedStorage.Modules.Utils.Rng)

local assets = External:getAssets()
local hair = assets.Accessories.Hair
local hats = assets.Accessories.Hats
local faces = assets.Faces


local Vampire = Class.new{super=Generic}


function Vampire:init(configPreset)
    
    configPreset = configPreset or "default"
    
    self.super.init(self)


    self.config = self.configPresets[configPreset]()

    task.spawn(function()
        while task.wait(2) do
            --self:updateConfig{face = faces.BeastMode}
        end
    end)
end


function Vampire:main()
    self.replicated = External:getReplicated(script)

    self.configPresets = {

        ["male"] = function()
            return {
                ["accessories"] = {
                    Rng:randomValueFromArray{hair.Hair_01, hair.Hair_03, hair.Hair_04, hair.Hair_06, nil},
                    Rng:randomValueFromArray{nil, hats.VampireCrown, hats.VampireTopHat}
                },
                ['face'] = Rng:randomValueFromArray{faces.ClassicVampire, faces.EpicVampire, faces.Vampire, faces.BeastMode}
            
            }
        end,

        ["female"] = function()
            return {
                ["accessories"] = {
                    Rng:randomValueFromArray{hair.Hair_02, hair.Hair_05, hair.Hair_07, hair.Hair_08, hair.Hair_09, hair.Hair_10},
                    Rng:randomValueFromArray{nil, hats.VampireCrown, hats.VampireQueenCrown}
                },
                ['face'] = Rng:randomValueFromArray{faces.ClassicVampire, faces.EpicVampire, faces.Vampire, faces.BeastMode}
            
            }
        end,

        ["default"] = function()
            if math.random(1, 2) == 1 then
                return self.configPresets.male()
            else
                return self.configPresets.female()
            end

        end

    }
end

return Vampire
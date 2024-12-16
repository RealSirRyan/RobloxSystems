local Rng = {}


function Rng:randomValueFromArray(array)
    local randomNumber = math.random(1, #array)
    return array[randomNumber]
end

return Rng
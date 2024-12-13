local Class = {}

--[[
    Constructs an object. self is the class.
]]
function Class:__call(...)
    
    local object = {}
    setmetatable(object, self)

    if self.init then
        self.init(object, ...)
    end

    return object
end

--[[
    Allows classes to access attributes and properties from a parent class
]]
function Class:__index(index)
    if rawget(self, "super") then
        return self.super[index]
    end
end


function Class.new(newClass)
    -- When an object sets its metatable to the class, this allows it to access the class's methods and attributes.
    newClass.__index = newClass
    
    return setmetatable(newClass, Class)
end


return Class
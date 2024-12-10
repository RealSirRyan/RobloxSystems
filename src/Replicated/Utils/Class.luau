local Class = {}


--[[
    Construct an object from a class
]]
function Class:__call(...)
    
    --Create a new object for the class 'self'
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
    if rawget(self, "_super") then
        return self._super[index]
    end
end


function Class.new(new_class)
    --Allows objects created with this class to access class methods and attributes
    new_class.__index = new_class
    
    --Allow 'new_class' to access metamethods from 'Class'
    return setmetatable(new_class, Class)
end


return Class
local BaseObject = require(script.Parent.roblox_packages.BaseObject)

--[=[
	@class ServiceLoader
	The sapling equivilent of Nevermore's `serviceBag` package as well as a successor to the `sapling` package.
]=]
local ServiceLoader = setmetatable({}, BaseObject)
ServiceLoader.ClassName = "ServiceLoader"
ServiceLoader.__index = ServiceLoader

export type ServiceLoader = typeof(setmetatable({} :: {}, ServiceLoader)) & BaseObject.BaseObject

function ServiceLoader.new()
	local self: ServiceLoader = setmetatable(BaseObject.new(), ServiceLoader)
	return self
end

return ServiceLoader

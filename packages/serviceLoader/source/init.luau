local BaseObject = require(script.Parent.roblox_packages.BaseObject)
local ServiceLoaderUtils = require(script.ServiceLoaderUtils)
local serviceLoaderTypes = require(script.serviceLoaderTypes)

--[=[
	@class ServiceLoader
	The sapling equivilent of Nevermore's `serviceBag` package as well as a successor to the `sapling` package.
]=]
local ServiceLoader = setmetatable({}, BaseObject)
ServiceLoader.ClassName = "ServiceLoader"
ServiceLoader.__index = ServiceLoader

export type ServiceLoader =
	typeof(setmetatable(
		{} :: {
			_CanAddServices: boolean,
			_Services: { [string]: serviceLoaderTypes.Service },
		},
		{} :: typeof({ __index = ServiceLoader })
	))
	& BaseObject.BaseObject

function ServiceLoader.new()
	local self: ServiceLoader = setmetatable(BaseObject.new(), ServiceLoader)
	self._CanAddServices = true
	self._Services = {}
	return self
end

--[=[

]=]
function ServiceLoader.GetService(
	self: ServiceLoader,
	requiree: serviceLoaderTypes.Service,
	service: serviceLoaderTypes.Service
)
	local deps = requiree[ServiceLoaderUtils.ServiceDependenciesKey] or {}
	table.insert(deps, service)

	if self._Services[requiree.ServiceName] == nil then
		self._Services[requiree.ServiceName] = requiree
	end

	if self._Services[service.ServiceName] == nil then
		self._Services[service.ServiceName] = service
	end

	requiree[ServiceLoaderUtils.ServiceDependenciesKey] = deps
	return service
end

function ServiceLoader.Init(self: ServiceLoader)
	for _, v in self._Services do
		if typeof(v["Init"]) == "function" then
			v:Init(self)
		end
	end
end

function ServiceLoader._CallMethodDepp(
	self: ServiceLoader,
	methodName: string,
	service: serviceLoaderTypes.Service,
	...
)
	local deps = service[ServiceLoaderUtils.ServiceDependenciesKey] or {}
	for _, v in deps do
		self:_CallMethodDepp(methodName, v)
	end

	if typeof(service[methodName]) == "function" then
		service[methodName](service, ...)
	end
end

function ServiceLoader.Start(self: ServiceLoader)
	self:_CallMethodDepp("Start", self._Services["Origin"])
end

return ServiceLoader

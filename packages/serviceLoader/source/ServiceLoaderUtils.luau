local serviceLoaderTypes = require(script.Parent.serviceLoaderTypes)

--[=[
    @class ServiceLoaderUtils
]=]
local ServiceLoaderUtils = {}

ServiceLoaderUtils.ServiceDependenciesKey = newproxy()

--[=[
    Check if the `obj` is actually a service
]=]
function ServiceLoaderUtils.IsService(obj: serviceLoaderTypes.Service?): (boolean, string?)
	local isTable = typeof(obj) == "table"
	if not isTable then
		return false, "Not a table"
	end

	local serviceName = obj.ServiceName
	local hasServicename = typeof(serviceName) == "string"
	if not hasServicename then
		if serviceName == nil then
			return false, "Missing service name"
		end

		return false, "ServiceName is not a string"
	end

	return true
end

return ServiceLoaderUtils

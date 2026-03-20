local types = require(script.Parent.Parent.types)
type Service = types.Service
local safeRequire = require(script.Parent.safeRequire)

local services = {} :: { [ModuleScript]: Service }

local ServiceManager = {}

function ServiceManager.addService(module: ModuleScript, service: Service?)
	if service == nil then
		local sucess, requiredService = safeRequire(module)
		if not sucess then
			error(`[SAPLING] Error while requiring module: {module:GetFullName()}: {requiredService}`)
			return
		end
		service = requiredService :: Service
	end

	services[module] = service
end

return ServiceManager

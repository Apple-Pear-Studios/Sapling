local OtherService = require(script.Parent.OtherService)
local serviceLoader = require(script.Parent.Parent.Parent.Parent.ReplicatedStorage.packages.serviceLoader.serviceLoader)

local AwesomeService = {}
AwesomeService.ServiceName = "AwesomeService"

export type AwesomeService = typeof(AwesomeService)

function AwesomeService.Init(self: AwesomeService, serviceLoader: serviceLoader.ServiceLoader)
	serviceLoader:GetService(self, OtherService)
end

function AwesomeService.Start(self: AwesomeService)
	print("Start awesome service")
end

return AwesomeService

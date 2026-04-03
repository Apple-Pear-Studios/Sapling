local serviceLoader = require(script.Parent.Parent.Parent.Parent.ReplicatedStorage.packages.serviceLoader.serviceLoader)

local OtherService = {}
OtherService.ServiceName = "AwesomeService"

export type OtherService = typeof(OtherService)

function OtherService.Init(self: OtherService, serviceLoader: serviceLoader.ServiceLoader)
end

function OtherService.Start(self: OtherService)
    print("Start other service")
end

return OtherService
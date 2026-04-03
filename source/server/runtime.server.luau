local AwesomeService = require(script.Parent.NewServices.AwesomeService)
local serviceLoader = require(script.Parent.Parent.Parent.ReplicatedStorage.packages.serviceLoader.serviceLoader)
-- local ReplicatedStorage = game:GetService("ReplicatedStorage")
-- local BlockingDispatcher = require(script.Parent.BlockingDispatcher)
-- local queryBuilder = require(script.Parent.Parent.Parent.ReplicatedStorage.packages.queryBuilder)
-- local sapling = require(script.Parent.Parent.Parent.ReplicatedStorage.packages.sapling)

-- sapling.loadPackages(ReplicatedStorage.packages)
-- sapling.loadServices(script.Parent.services)
-- sapling.fireLifecycle("onStart")

-- sapling.createLifecycle("blockingTest", BlockingDispatcher.new())
-- sapling.fireLifecycle("blockingTest")
-- print("Post lifecycle fire call")

-- print(queryBuilder.new():withTag("CoolTag"):query())

local loader = serviceLoader.new()
loader:GetService({ ServiceName = "Origin" }, AwesomeService)
print(loader._Services)
loader:Init()
loader:Start()

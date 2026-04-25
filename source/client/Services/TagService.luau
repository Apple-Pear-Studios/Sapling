local binder = require(script.Parent.Parent.Parent.Parent.ReplicatedStorage.packages.binder.binder)
local TagService = { ServiceName = "TagService" }

function TagService.OnStart()
    binder.bind("Rainbow", function(instance: Instance)
        print("Added")
        assert(instance:IsA("BasePart"), "Cannot make a non BasePart rainbow")

        local thread = task.spawn(function()
            while task.wait(1) do
                instance.BrickColor = BrickColor.random()
            end
        end)

        return function()
            task.cancel(thread)
            print("Cleaned")
        end
    end)
end

return TagService

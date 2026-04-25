local CollectionService = game:GetService("CollectionService")
local Sweeper = require(script.Parent.roblox_packages.Sweeper)

type BinderCallback = (instance: Instance) -> () -> ()

--[[
    Binder allows you to, well, bind a function to a certain tag.
]]
local Binder = {}

function Binder.yieldUntilTagIsRemoved(tag: string, instance: Instance)
    if not instance:HasTag(tag) then
        return
    end

    local thread = coroutine.running()

    local conn = CollectionService:GetInstanceRemovedSignal(tag):Connect(function(taggedInstance: Instance)
        if taggedInstance == instance then
            coroutine.resume(thread)
        end
    end)

    coroutine.yield()

    conn:Disconnect()

    return
end

local function bindCallbackToInstance(tag: string, instance: Instance, callback: BinderCallback)
    local sweeper = Sweeper.new()

    local cleanup = callback(instance)

    sweeper:Add(cleanup)
    sweeper:Add(instance.Destroying:Connect(cleanup))

    do
        local thread = task.spawn(function()
            Binder.yieldUntilTagIsRemoved(tag, instance)
            cleanup()
        end)
        sweeper:Add(function()
            task.cancel(thread)
        end)
    end
end

function Binder.bind(tag: string, fn: BinderCallback)
    for _, v in CollectionService:GetTagged(tag) do
        bindCallbackToInstance(tag, v, fn)
    end

    CollectionService:GetInstanceAddedSignal(tag):Connect(function(taggedInstance: Instance)
        bindCallbackToInstance(tag, taggedInstance, fn)
    end)
end

return Binder

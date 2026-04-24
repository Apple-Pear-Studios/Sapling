local CollectionService = game:GetService("CollectionService")

type BinderCallback = (instance: Instance) -> () -> ()

--[[
    Binder allows you to, well, bind a function to a certain tag.
]]
local Binder = {}

function Binder.bind(tag: string, fn: BinderCallback)
    for _, v in CollectionService:GetTagged(tag) do
        local cleanup = fn(v)
        v.Destroying:Once(cleanup)
    end
end

return Binder

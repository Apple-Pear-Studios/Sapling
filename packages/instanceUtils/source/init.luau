local function WaitForChildWithPredicate(parent: Instance, predicate: (instance: Instance) -> boolean)
	for _, v in parent:GetChildren() do
		if predicate(v) then
			return v
		end
	end

	local thread = coroutine.running()

	local conn
	conn = parent.ChildAdded:Connect(function(child: Instance)
		if predicate(child) then
			task.spawn(thread, child)
		end
	end)

	local instance = coroutine.yield()
	conn:Disconnect()

	return instance
end

local InstanceUtils = {}

function InstanceUtils.WaitForChildWhichIsA(instance: Instance, class: string)
	return WaitForChildWithPredicate(instance, function(v: Instance)
		return v:IsA(class)
	end)
end

return InstanceUtils

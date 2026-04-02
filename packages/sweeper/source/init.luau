local SweeperUtils = require(script.SweeperUtils)

-- Typicall destroy/disconnect methods, eventually maybe allow you to pass a
-- custom destroy method name.
local DESTROY_METHODS = {
	"Destroy",
	"destroy",
	"Disconnect",
	"disconnect",
}

--[=[
	@class Sweeper
]=]
local Sweeper = {}
Sweeper.ClassName = "Sweeper"
Sweeper.__index = Sweeper

--[=[
	@type Sweepable Instance | () -> () | { [string]: () -> () }
	@within Sweeper

	Describes somethign a Sweeper can cleanup. This is currently any `Instance`, function or table with one of the following
	methods:
	- "Destroy"
	- "Disconnect"
	- "disconnect"
	- "destroy"
]=]
export type Sweepable = Instance | () -> () | { [string]: () -> () }

export type Sweeper = typeof(setmetatable(
	{} :: {
		_Tasks: { Sweepable },
	},
	Sweeper
))

--[=[
	Create new sweeper
]=]
function Sweeper.new()
	local self: Sweeper = setmetatable({}, Sweeper)
	self._Tasks = {}
	return self
end

--[=[
	Adds a task to the sweeper to be cleaned up.
]=]
function Sweeper.Add(self: Sweeper, task: Sweepable)
	local isValid = true

	-- TODO:
	-- Eventually allow you to pass a custom destroy method name

	for _, methodName in DESTROY_METHODS do
		isValid = SweeperUtils.IsValid(task, methodName)
		if not isValid then
			error(`Invalid task: {task}`)
		end
	end

	table.insert(self._Tasks, task)
end

--[=[
	Clean up everything that has been added to the sweeper.
]=]
function Sweeper.Clean(self: Sweeper)
	for _, v in self._Tasks do
		if typeof(v) == "Instance" then
			v:Destroy()
		elseif typeof(v) == "function" then
			v()
		elseif typeof(v) == "table" then
			local destroyMethod
			for _, methodName in DESTROY_METHODS do
				destroyMethod = v[methodName]
				if destroyMethod ~= nil then
					break
				end
			end

			if destroyMethod ~= nil then
				destroyMethod(v)
			end
		end
	end

	table.clear(self._Tasks)
end

--[=[
	Same as [Sweeper.Clean]
]=]
function Sweeper.Destroy(self: Sweeper)
	self:Clean()
end

return Sweeper

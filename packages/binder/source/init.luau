local CollectionService = game:GetService("CollectionService")

local BaseObject = require(script.Parent.roblox_packages.BaseObject)

--[=[
	@interface ClassInterface<T>
	.new: (instance: Instance) -> T
	.Destroy: (T) -> ()
	@within Binder

	Basic requiremnts for a class to be able to be used by a Binder
]=]
type ClassInterface<T> = {
	new: (instance: Instance) -> T,
	Destroy: (T) -> (),
}

--[=[
	@class Binder
	A binder allows you to bind a Luau class to instances with certain tags. For example:

	```lua
	local MyClass = {}
	MyClass.__index = MyClass

	function MyClass.new(robloxInstance)
		print("New tagged instance of ", robloxInstance)
		return setmetatable({}, MyClass)
	end

	function MyClass:Destroy()
		print("Cleaning up")
		setmetatable(self, nil)
	end

	-- bind to every instance with tag of "Yellow"
	local binder = Binder.new("Yellow", MyClass)
	binder:Start() -- listens for new instances and connects events
	```
]=]
local Binder = setmetatable({}, BaseObject)
Binder.ClassName = "Binder"
Binder.__index = Binder

export type Binder<T> =
	typeof(setmetatable(
		{} :: {
			_Class: ClassInterface<T>,
			_Tag: string,
			_ClassInstances: { [Instance]: ClassInterface<T> },
		},
		Binder
	))
	& BaseObject.BaseObject

--[=[
	@prop _Tag string
	@private
	@within Binder

	The [CollectionService] tag to bind to
]=]

--[=[
	@prop _Class ClassInterface<T>
	@private
	@within Binder

	Class table which should contain the constructor & destructor of the class.
]=]

--[=[
	@prop _ClassInstances { [Instance]: ClassInterface<T> }
	@private
	@within Binder

	A map of instances to their class instances.
]=]

--[=[
	Create a new binder
]=]
function Binder.new<T>(tag: string, class: ClassInterface<T>): Binder<T>
	local self: Binder<T> = setmetatable(BaseObject.new(), Binder)
	self._Class = class
	self._Tag = tag
	self._ClassInstances = {}

	self._Sweeper:Add(function()
		for _, v in self._ClassInstances do
			v:Destroy()
		end
	end)

	return self
end

--[=[
	Connects the [CollectionService] events needed to listen to tags.
]=]
function Binder.Start<T>(self: Binder<T>)
	for _, v in CollectionService:GetTagged(self._Tag) do
		self._ClassInstances[v] = self._Class.new(v)
	end

	self._Sweeper:Add(CollectionService:GetInstanceAddedSignal(self._Tag):Connect(function(instance: Instance)
		if self._ClassInstances[instance] ~= nil then
			warn("Already has class binded")
			return
		end
		self._ClassInstances[instance] = self._Class.new(instance)
	end))

	self._Sweeper:Add(CollectionService:GetInstanceRemovedSignal(self._Tag):Connect(function(instance: Instance)
		local class = self._ClassInstances[instance]
		if class == nil then
			return
		end
		self._Class.Destroy(class)
		self._ClassInstances[instance] = nil
	end))
end

return Binder

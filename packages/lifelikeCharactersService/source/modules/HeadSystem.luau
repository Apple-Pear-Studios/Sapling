local NECK_MOTOR_NAME = "__NECK_MOTOR__"

local function createNeckMotor(character: Model)
	local head = character:FindFirstChild("Head")
	local torso = character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso")
	if head == nil or torso == nil then
		return
	end

	local motor = Instance.new("Motor6D")
	motor.Name = NECK_MOTOR_NAME
	motor.Part0 = torso
	motor.Part1 = head
	motor.C0 = CFrame.new(0, 1.2, 0)
	motor.Parent = character
end

local function getNeckMotor(character: Model)
	return character:FindFirstChild(NECK_MOTOR_NAME)
end

--[=[
	@class HeadSystem
	@client
	Handles [Motor6D] objects to control neck rotations.
]=]
local HeadSystem = {}

--[=[
	Updates the head rotation for the `character`, the `yAngle` and `xAngle` should be normalized and everything before
	being passed into this function.
]=]
function HeadSystem.UpdateLookAngles(character: Model, yAngle: number, xAngle: number)
	local neckMotor = getNeckMotor(character)
	if neckMotor == nil then
		createNeckMotor(character)
		neckMotor = getNeckMotor(character)
		if neckMotor == nil then
			return
		end
	end

	local yOffset = neckMotor.C0.Y

	neckMotor.C0 = CFrame.new(0, yOffset, 0) * CFrame.Angles(0, yAngle, 0) * CFrame.Angles(xAngle, 0, 0)
end

return HeadSystem

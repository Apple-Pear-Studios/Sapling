local Players = game:GetService("Players")
local getRemote = require(script.Parent.modules.getRemote)

local isSetup = false
local isReplicationEnabled = true

--[=[
    @class LifelikeCharactersServiceServer
    @server

    Can be accessed via [LifelikeCharactersService.getServer].

    Handles the replication of character's head rotations.
]=]
local LifelikeCharactersServiceServer = {}

--[=[
    Disable replication of character's head rotations between all players in the game.
]=]
function LifelikeCharactersServiceServer.disableReplication()
	isReplicationEnabled = false
end

--[=[
    Enable replication of character's head rotations between all players in the game.
]=]
function LifelikeCharactersServiceServer.enableReplication()
	isReplicationEnabled = true
end

--[=[
    @private
    This function is called for you when the package starts. You do NOT need to call this.
    
    If you call this function it will error.
]=]
function LifelikeCharactersServiceServer.setup()
	assert(not isSetup, "Setup has already been called")
	isSetup = true

	local updateLookAnglesRemote = getRemote("UpdateLookAngles")
	updateLookAnglesRemote.OnServerEvent:Connect(function(player: Player, yAngle: number, xAngle: number)
		if not isReplicationEnabled then
			return
		end

		if typeof(yAngle) ~= "number" then
			return
		end
		if typeof(xAngle) ~= "number" then
			return
		end

		for _, v in Players:GetPlayers() do
			if v.UserId == player.UserId then
				continue
			end
			updateLookAnglesRemote:FireClient(v, player.Character, yAngle, xAngle)
		end
	end)
end

return LifelikeCharactersServiceServer

local PlayerData = require(script.Parent.PlayerData)
local DanceManager = require(script.Parent.Parent.DanceManager)

 -- userid > PlayerData
local playerList = {}

game.Players.PlayerAdded:Connect(function (player: Player)
	playerList[player.UserId] = PlayerData.new(player)
end)

game.Players.PlayerRemoving:Connect(function (player: Player) 
	-- removing the player data so their Player instance can be garbage collected
	playerList[player.UserId] = nil
	DanceManager.playerStopDancing(player)
end)


local PlayerManager = {}

function PlayerManager.getPlayerData(userid: number)
	return playerList[userid]
end

return PlayerManager
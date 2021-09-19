local PlayerData = {}
PlayerData.__index = PlayerData

--[[
	Instantiates a new PlayerData object,
	as well as the leaderboard data associated.
]]
function PlayerData.new(player: Player)
	local pdata = {}
	
	pdata.leaderstats = Instance.new("Folder")
	pdata.leaderstats.Name = "leaderstats"
	pdata.leaderstats.Parent = player

	pdata.scoreVal = Instance.new("IntValue")
	pdata.scoreVal.Name = "Score"
	pdata.scoreVal.Value = 0
	pdata.scoreVal.Parent = pdata.leaderstats

	return setmetatable(pdata, PlayerData)
end

--[[ Increments the player's score leaderstat by the given value ]]
function PlayerData:addScore(score: number)
	self.scoreVal.Value += score
end

return PlayerData
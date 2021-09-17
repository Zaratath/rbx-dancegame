local PlayerData = {}
PlayerData.__index = PlayerData

--[[
	Instantiates a new PlayerData object,
	as well as the leaderboard data associated.
]]
function PlayerData.new(uuid: number)
	local pdata = {}
	pdata.uuid = uuid
	pdata.currentScore = 0
	pdata.currentlyDancing = false
	return setmetatable(pdata, PlayerData)
end

function PlayerData:addScore(score: number)
	self.currentScore += score
end

return PlayerData
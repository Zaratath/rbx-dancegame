local DanceManager = require(script.DanceManager)

local Shared = game.ReplicatedStorage.Common
local DanceFloorArea = require(Shared.dance.DanceFloorArea)


--[[
	Finds which players are inside of the dancefloor and adds/removes them from DanceManager
	Notifies them of the current BeatState, can be nil information. 

	If currentChart is nil (first player dancing), they'll be sent a SongChanged remoteevent immediately after this.
]]
function validatePlayersOnFloor() 
	for _,player:Player in ipairs(game.Players:GetPlayers()) do
		local isOnFloor = DanceFloorArea.playerIsWithinArea(player)
		local isPlayerDancing = DanceManager.isPlayerDancing(player)
		if isOnFloor and not isPlayerDancing then
			DanceManager.playerStartDancing(player)
		elseif not isOnFloor and isPlayerDancing then
			DanceManager.playerStopDancing(player)
		end
	end
end

--serverside gameloop.
local RS = game:GetService("RunService")
RS.Heartbeat:Connect(function(dt) 
	validatePlayersOnFloor()

	--stops song if noone is on the dancefloor.
	if not (DanceManager.countDancingPlayers() > 0) then
		DanceManager.stopSong()
		return
	end
	--tick song, or create one if there is none/it's finished
	local song = DanceManager.getCurrentSong()
	if song and not (song:isFinished()) then
		song:tick(dt)
	else 
		DanceManager.newSong()
	end
end)

local DanceManager = require(script.DanceManager)
local PlayerManager = require(script.player.PlayerManager)


local Shared = game.ReplicatedStorage.Common
local DanceFloorArea = require(Shared.dance.DanceFloorArea)

--[[
	Finds which players are inside of the dancefloor and adds/removes them from DanceManager

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

--[[ Handles PlayerHit remotes, adding to a player's score if the hit is within the realm of possibility. ]]
function handlePlayerHit(player, chord, acc)
	if not chord or not acc then
		print("Malformed PlayerHit args recieved.")
		return
	end

	local beat = DanceManager.playerHitNote(player, chord, acc)
	if not beat then
		print("Player does not have another beat in this chord. Potentially dis-honest client")
		return
	end
	
	PlayerManager.getPlayerData(player.UserId):addScore(acc)
	
end

Shared.remotes.PlayerHit.OnServerEvent:Connect(handlePlayerHit)

-- serverside gameloop.
local RS = game:GetService("RunService")
RS.Heartbeat:Connect(function(dt) 
	validatePlayersOnFloor()

	if not (DanceManager.countDancingPlayers() > 0) then
		DanceManager.stopSong()
		return
	end

	-- tick song, or create one if there is none/it's finished
	local song = DanceManager.getCurrentSong()
	if song and not (song:isFinished()) then
		song:tick(dt)
	else 
		DanceManager.newSong()
	end
end)

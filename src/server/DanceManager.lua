local Shared = game.ReplicatedStorage.Common
local Song = require(Shared.music.Song)
local SongSelector = require(script.Parent.SongSelector)
local PlayerBeats = require(Shared.music.PlayerBeats)
local AnimationManager = require(script.Parent.AnimationManager)

-- map of Players by their uuid
local playersByUUID = {};
-- map of playerBeats objects
local playerBeats = {}

-- active song playing. 
local currentSong = nil

local DanceManager = {}

--[[ Removes a note from the player's playerBeats object. Handles fumbling on 0 acc hits. 
	@returns the removed note ]]
function DanceManager.playerHitNote(player, chord, acc)
	if acc == 0 then
		AnimationManager.fumble(player)
	end
	local playerBeat = playerBeats[player.UserId]
	if not playerBeat then return end
	return playerBeat:removeBeat(chord)
end

--[[ Begins tracking a player as dancing, as well as beginning a song if this player is the first to begin dancing ]]
function DanceManager.playerStartDancing(player: Player)
	-- not playing a song, create one.
	if currentSong == nil then
		DanceManager.newSong()
	end

	-- player is added to the table after creating the new song if none, so they're not sent a SongChanged event
	AnimationManager.startDance(player)
	playersByUUID[player.UserId] = player
	playerBeats[player.UserId] = PlayerBeats.new(currentSong, currentSong:getTick())
	Shared.remotes.PlayerJoinDance:FireClient(player, currentSong.chart.name, currentSong.difficulty, currentSong:getTick())
end
--[[ Stops tracking a player as dancing, and empties their beat data. ]]
function DanceManager.playerStopDancing(player: Player)
	AnimationManager.stopDance(player)
	playersByUUID[player.UserId] = nil
	playerBeats[player.UserId] = nil
	Shared.remotes.PlayerLeaveDance:FireClient(player)
end

function DanceManager.isPlayerDancing(player: Player): boolean
	return playersByUUID[player.UserId] ~= nil
end

function DanceManager.getCurrentSong()
	return currentSong
end

--[[ Stops the current song and resets player beat data. Nothing if there's no current song. ]]
function DanceManager.stopSong() 
	currentSong = nil

end

--[[ Begins playing a new song. Chart and difficulty selected within SongSelector ]]
function DanceManager.newSong() 
	local chart = SongSelector.selectSong()
	local difficulty = SongSelector.selectDifficulty(chart)

	currentSong = Song.new(chart, difficulty)
	for _,player in pairs(playersByUUID) do
		Shared.remotes.SongChanged:FireClient(player, chart.name, difficulty, 0)
	end
end

--[[ @returns A cloned table of all currently dancing players. ]]
function DanceManager.getDancingPlayers(): {Player}
	local t = {}
	for _,v in pairs(playersByUUID) do
		table.insert(t, v)
	end
	return t
end

--[[ @returns the number of players currently dancing ]]
function DanceManager.countDancingPlayers(): number
	local i = 0
	for _,_ in pairs(playersByUUID) do
		i += 1
	end
	return i
end

return DanceManager
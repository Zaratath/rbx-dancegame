local Shared = game.ReplicatedStorage.Common
local Song = require(Shared.music.Song)
local SongSelector = require(script.Parent.SongSelector)



--map of Players by their uuid
local playersByUUID = {};
--map of player's associated PlayerBeat object.
local playerBeats = {}

--active song playing. 
local currentSong = nil



local DanceManager = {}
--[[ Begins tracking a player as dancing, as well as beginning a song if this player is the first to begin dancing ]]
function DanceManager.playerStartDancing(player: Player)
	--not playing a song, create one.
	if currentSong == nil then
		DanceManager.newSong()
	end
	--player is added to the table after creating the new song if none, so they're not sent a SongChanged event
	playersByUUID[player.UserId] = player
	Shared.remotes.PlayerJoinDance:FireClient(player, currentSong.chart.name, currentSong.difficulty, currentSong:getTick())
end
--[[ Stops tracking a player as dancing, and deletes their beat data. ]]
function DanceManager.playerStopDancing(player: Player)
	playersByUUID[player.UserId] = nil
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
		Shared.remotes.SongChanged:FireClient(player, chart.name, difficulty)
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
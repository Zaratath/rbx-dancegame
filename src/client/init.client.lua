local Shared = game.ReplicatedStorage.Common
local DanceFloor = require(script.render.dancefloor.DanceFloor)
local Song = require(Shared.music.Song)
local Charts = require(Shared.music.Charts)
local PlayerBeats = require(Shared.music.PlayerBeats)
local Input = require(script.Input)
local Hit = require(Shared.music.Hit)

-- variables pertaining to the current song
local localSong = nil
local playerBeats = nil
local currentAudio = nil

local function handleInput(chord:string, inputState, inputObject)
	-- only handles button downs
	if inputState ~= Enum.UserInputState.Begin then return end
	chord = tonumber(chord)
	local hit = Hit.new(localSong:getTick(), chord)
	playerBeats:checkHit(hit)
end

local function startSong(name: string, difficulty: string, timePos: number?) 
	print("Created clientside BeatState ", name, difficulty, timePos)
	if name == nil or difficulty == nil then
		-- player was the first to enter the dance floor, no song was playing.
		-- will recieve a SongChanged event immediately after PlayerJoinDance
		return
	end
	localSong = Song.new(Charts.getChartByName(name), difficulty, timePos)
	playerBeats = PlayerBeats.new(localSong, timePos)
	currentAudio = Charts.getAudioByName(name)
	currentAudio.TimePosition = timePos
	currentAudio:Play()

	Input.bind(handleInput)
end

local function stopSong()
	print("Clientside stopped dancing")
	localSong = nil
	playerBeats = nil
	currentAudio:Stop()
	currentAudio = nil

	Input.unbind()
end

--[[ Player joined song in progress ]]
Shared.remotes.PlayerJoinDance.OnClientEvent:Connect(startSong)
--[[ Player left dance floor, stop playing ]]
Shared.remotes.PlayerLeaveDance.OnClientEvent:Connect(stopSong)
--[[ New song started ]]
Shared.remotes.SongChanged.OnClientEvent:Connect(startSong)

local function tick(dt: number) 
	localSong:tick(dt)
	playerBeats:missExpiredNotes()
end

local function render(dt)
	DanceFloor.randomizeColours(dt)
end

-- clientside gameloop
local RS = game:GetService("RunService")
RS.RenderStepped:Connect(function(dt) 
	if localSong == nil then return end
	tick(dt)
	render(dt)
end)
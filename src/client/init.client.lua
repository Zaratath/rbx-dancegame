local Shared = game.ReplicatedStorage.Common
local DanceFloor = require(script.render.dancefloor.DanceFloor)
local BeatRenderer = require(script.render.ui.BeatRenderer)
local Song = require(Shared.music.Song)
local Charts = require(Shared.music.Charts)
local PlayerBeats = require(Shared.music.PlayerBeats)
local Input = require(script.Input)
local Hit = require(Shared.music.Hit)

-- variables pertaining to the current song
local localSong = nil
local playerBeats = nil
local currentAudio = nil

local function handleBeat(chord, acc) 
	BeatRenderer.drawAccPop(chord, acc)
	playerBeats:removeBeat(chord)
	Shared.remotes.PlayerHit:FireServer(chord, acc)
end

local function handleInput(chord:string, inputState)
	-- only handles button downs
	if inputState ~= Enum.UserInputState.Begin then return end
	chord = tonumber(chord)

	local hit = Hit.new(localSong:getTick(), chord)
	local hitAcc = playerBeats:checkHit(hit)
	
	--[[ misplays don't count against the player, so player's could technically spam the keys and slowly gain points.
		 this could either be changed to make misplays (taps/keypresses without a note) remove points or
		 drop a combo multiplier if one were to be implemented. ]]
	if hitAcc > 0 then
		handleBeat(chord, hitAcc)
	end
end

local function startSong(name: string, difficulty: string, timePos: number?) 
	if name == nil or difficulty == nil then
		-- player was the first to enter the dance floor, no song was playing.
		-- will recieve a SongChanged event immediately after PlayerJoinDance
		return
	end
	print("Created clientside PlayerBeats", name, difficulty, timePos)
	localSong = Song.new(Charts.getChartByName(name), difficulty, timePos)
	playerBeats = PlayerBeats.new(localSong, timePos)
	currentAudio = Charts.getAudioByName(name)
	currentAudio.TimePosition = timePos
	currentAudio:Play()

	Input.bind(handleInput)
	BeatRenderer.create(handleInput)
end

local function stopSong()
	print("Clientside stopped dancing")
	localSong = nil
	playerBeats = nil
	currentAudio:Stop()
	currentAudio = nil
	Input.unbind()
	BeatRenderer.destroy()
end

--[[ Player joined song in progress ]]
Shared.remotes.PlayerJoinDance.OnClientEvent:Connect(startSong)
--[[ Player left dance floor, stop playing ]]
Shared.remotes.PlayerLeaveDance.OnClientEvent:Connect(stopSong)
--[[ New song started ]]
Shared.remotes.SongChanged.OnClientEvent:Connect(startSong)

local function tick(dt: number) 
	localSong:tick(dt)
	local missed = playerBeats:getExpiredBeats()
	for _,beat in ipairs(missed) do
		handleBeat(beat.Chord, 0)
	end
end

local function render(dt)
	DanceFloor.randomizeColours(dt)
	BeatRenderer.tickRender(playerBeats, dt)
end

-- clientside gameloop
local RS = game:GetService("RunService")
RS.RenderStepped:Connect(function(dt) 
	if localSong == nil or localSong:isFinished() then return end
	tick(dt)
	render(dt)
end)
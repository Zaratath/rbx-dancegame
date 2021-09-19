local BeatComponent = require(script.Parent.BeatComponent)
local GhostButton = require(script.Parent.GhostButton)

local FRAME_SIZE = 0.5
local CHORD_COUNT = 4

local BeatUi = {}
BeatUi.__index = BeatUi

function BeatUi.new(hitCallback)
	local bu = {}

	local ScreenGui = Instance.new("ScreenGui")
	bu.gui = ScreenGui

	local Frame = Instance.new("Frame")
	Frame.Size = UDim2.new(FRAME_SIZE, 0, 0.5, 0)
	Frame.Position = UDim2.new(FRAME_SIZE/2, 0, 0, 0)
	Frame.SizeConstraint = Enum.SizeConstraint.RelativeXX
	Frame.BackgroundTransparency = 1
	Frame.Parent = ScreenGui


	local ListLayout = Instance.new("UIListLayout")
	ListLayout.FillDirection = Enum.FillDirection.Horizontal
	ListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	ListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
	ListLayout.Parent = Frame

	bu.chords = {}
	for chord=1,CHORD_COUNT do
		local chordFrame = Instance.new("Frame")
		chordFrame.Size = UDim2.new(1/CHORD_COUNT, 0, 1, 0)
		chordFrame.SizeConstraint = Enum.SizeConstraint.RelativeXX
		chordFrame.BackgroundTransparency = 0.95
		chordFrame.Parent = Frame
		
		GhostButton.new(chordFrame, chord, hitCallback)

	 	bu.chords[chord] = chordFrame
	end

	ScreenGui.Parent = game.Players.LocalPlayer.PlayerGui
	return setmetatable(bu, BeatUi)
end

function BeatUi:getChordUI(chord) 
	return self.chords[chord]
end

function BeatUi:destroy()
	self.gui:Destroy()
end

return BeatUi
-- defines the speed at which notes approach visually (in seconds)
local APPROACH_TIME = 8 
-- left, down, up, right
local CHORD_ROTA = {90, 0, 180, 270}
local assetid = "http://www.roblox.com/asset/?id=1687470215"

local BeatComponent = {}
BeatComponent.__index = BeatComponent

function BeatComponent.getApproachTime()
	return APPROACH_TIME
end

function BeatComponent.new(parent, beat, song)
	local bc = {}
	bc.beat = beat
	bc.song = song
	local label = Instance.new("ImageLabel")
	label.Size = UDim2.new(1,0,1,0)
	label.SizeConstraint = Enum.SizeConstraint.RelativeXX
	label.Image = assetid
	label.BackgroundTransparency = 1
	label.Rotation = CHORD_ROTA[beat.Chord]
	label.Parent = parent
	bc.label = label

	return setmetatable(bc, BeatComponent)
end

function BeatComponent:render()
	local tickDelta = self.beat.TimePosition - self.song:getTick()
	local relativePosition = tickDelta / APPROACH_TIME
  	self.label.Position = UDim2.new(0,0,1 * relativePosition,0)
end

function BeatComponent:destroy() 
	self.label:Destroy()
end

return BeatComponent
-- left, down, up, right
local CHORD_ROTA = {90, 0, 180, 270}
local assetid = "http://www.roblox.com/asset/?id=1687470215"

local GhostButton = {}
GhostButton.__index = GhostButton

function GhostButton.new(parent, chord, callback)
	local gb = {}

	local button = Instance.new("ImageButton")
	button.Activated:Connect(function()
		-- passing UserInputState.Begin, Activated UserInputState appears to only be End for some reason
		callback(chord, Enum.UserInputState.Begin)
	end)
	button.Size = UDim2.new(1,0,1,0)
	button.SizeConstraint = Enum.SizeConstraint.RelativeXX
	button.Image = assetid
	button.BackgroundTransparency = 1
	button.ImageTransparency = 0.6
	button.Rotation = CHORD_ROTA[chord]
	button.Parent = parent
	gb.button = button

	return setmetatable(gb, GhostButton)
end

return GhostButton

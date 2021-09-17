local DanceFloorArea = {}

local SIZE = 50 --x and z size of the dancefloor.
local CENTER = Vector2.new(30, 0) --the center of the dance floor.

local HALFSIZE = SIZE/2

--[[
	@return Whether or not the Player's Character is within the DanceArea bounds.
			false if their Character does not exist.
]]
function DanceFloorArea.playerIsWithinArea(player: Player): boolean
	local character = player.Character;
	if not character then return false end
	local position = character.HumanoidRootPart.Position
	return DanceFloorArea.locationIsWithinArea(position)
end

function DanceFloorArea.locationIsWithinArea(location: Vector3): boolean
	return ((location.X < CENTER.X + HALFSIZE)
		and (location.X > CENTER.X - HALFSIZE)
		and (location.Z < CENTER.Y + HALFSIZE)
		and (location.Z > CENTER.Y - HALFSIZE))
end

function DanceFloorArea.getSize(): number
	return SIZE
end

function DanceFloorArea.getCenter(): Vector2
	return CENTER
end

return DanceFloorArea
local Shared = game.ReplicatedStorage.Common
local DanceFloorArea = require(Shared.dance.DanceFloorArea)

--generating the dancefloor, programmer art! :)
local DIVISIONS = 8 --how many times the dancefloor is cut

local RANDOM_COLOUR_INTERVAL = 1 --1 seconds between colour changes
local danceFloorParts: {Part} = {}

do 
	local CENTER = DanceFloorArea.getCenter()
	local SIZE = DanceFloorArea.getSize()
	local HALF_SIZE = SIZE/2
	local SCALED_SIZE = SIZE/DIVISIONS

	local folder = Instance.new("Folder")
	folder.Name = "DanceFloor"
	folder.Parent = workspace

	for x=CENTER.X-HALF_SIZE, CENTER.X+HALF_SIZE, SCALED_SIZE do
		for z=CENTER.Y-HALF_SIZE, CENTER.Y+HALF_SIZE, SCALED_SIZE do
			local DanceFloorPart = Instance.new("Part")
			DanceFloorPart.Name = "dfPart"
			DanceFloorPart.Position = Vector3.new(x, 0, z)
			DanceFloorPart.Size = Vector3.new(SCALED_SIZE, 0.25, SCALED_SIZE)
			DanceFloorPart.Material = Enum.Material.Neon
			DanceFloorPart.Transparency = 0.5
			DanceFloorPart.BrickColor = BrickColor.random()
			DanceFloorPart.Parent = workspace
			table.insert(danceFloorParts, DanceFloorPart)
		end
	end
end 

local DanceFloor = {}

--deltatime collector is initialized as the interval so it turns immediately.
local dtBucket = RANDOM_COLOUR_INTERVAL
function DanceFloor.randomizeColours(dt: number) 
	dtBucket += dt
	if dtBucket < RANDOM_COLOUR_INTERVAL then return end
	dtBucket -= RANDOM_COLOUR_INTERVAL

	for _,part in pairs(danceFloorParts) do
		part.BrickColor = BrickColor.random()
	end
end

return DanceFloor

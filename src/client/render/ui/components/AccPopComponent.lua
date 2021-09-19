local ACC_POP_TEXT = {"Miss","Good","Great","Perfect!"}
local ACC_POP_COLOR = {Color3.new(0.9, 0.3, 0.3),
						Color3.new(1, 0.9, 0.1),
						Color3.new(0.4, 0.9, 0.5),
						Color3.new(0.3, 0.5, 1)}
-- time in seconds the pop lasts
local EXPIRY_TIME = 1
-- pixels to move up.
local TRAVEL_DIST = 20

local AccPop = {}
AccPop.__index = AccPop

function AccPop.new(chordui, acc)
	local accpop = {}

	local textLabel = Instance.new("TextLabel")
	-- index starts at 1, acc 0 is miss
	textLabel.Text = ACC_POP_TEXT[acc+1]
	textLabel.TextColor3 = ACC_POP_COLOR[acc+1]
	textLabel.BackgroundTransparency = 1
	textLabel.Parent = chordui

	accpop.label = textLabel
	accpop._tick = 0

	return setmetatable(accpop, AccPop)
end

function AccPop:tick(dt)
	self._tick += dt
	
	if self._tick > EXPIRY_TIME then
		self:destroy()
		return
	end

	local pos = self._tick / EXPIRY_TIME

	self.label.Position = UDim2.new(0,0,0,pos)
end

function AccPop:destroy()
	self.label:Destroy()
	self.isDestroyed = true
end

return AccPop
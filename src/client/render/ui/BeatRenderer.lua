local UiComponents = script.Parent.components
local AccPopComponent = require(UiComponents.AccPopComponent)
local BeatComponent = require(UiComponents.BeatComponent)
local BeatUi = require(UiComponents.BeatUi)
local BeatRenderer = {}

-- maps chart Beat objects to their corresponding ui component
local activeBeatComponents = {}
local accPops = {}

local beatUi = nil

function BeatRenderer.create(hitCallback)
	beatUi = BeatUi.new(hitCallback)
end

function BeatRenderer.destroy()
	beatUi:destroy()
	beatUi = nil
end

--[[ Renders all beats and ticks forward components. ]]
function BeatRenderer.tickRender(playerBeats, dt)
	local song = playerBeats.song

	-- ticking the acc pops
	local newaccPops = {}
	for i,accPop in pairs(accPops) do
		accPop:tick(dt)
		if not accPop.isDestroyed then
			table.insert(newaccPops, accPop)
		end
	end
	accPops = newaccPops

	local newactiveComponents = {}
	-- finding or creating all current beats in the song
	for _,chord in ipairs(playerBeats.beats) do
		for _,beat in ipairs(chord) do
			if beat.TimePosition > song:getTick() + BeatComponent.getApproachTime() then continue end

			local activeC = activeBeatComponents[beat]
			if activeC then 
				activeBeatComponents[beat] = nil
			end

			local component = activeC or BeatComponent.new(beatUi:getChordUI(beat.Chord), beat, song)
			component:render()
			table.insert(newactiveComponents, component)
		end
	end

	-- since beats have been removed from activeComponents if they're still found in the song
	-- activeComponents will consist of expired/consumed beats. destroys them here
	for i,component in pairs(activeBeatComponents) do
		component:destroy()
	end
	activeBeatComponents = newactiveComponents
end

--[[ Draws an accuracy popup at the given Chord ]]
function BeatRenderer.drawAccPop(chord, acc)
	local accPop = AccPopComponent.new(beatUi:getChordUI(chord), acc)
	table.insert(accPops, accPop)
end



return BeatRenderer


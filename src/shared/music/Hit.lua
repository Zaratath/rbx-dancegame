local Hit = {}

function Hit.new(timePos:number, chord:number)
	local hit = {}
	hit.TimePos = timePos
	hit.Chord = chord
	return hit
end

return Hit
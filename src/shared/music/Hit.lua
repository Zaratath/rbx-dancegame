local Hit = {}

function Hit.new(timePos:number, chord:number)
	print(timePos, chord)
	local hit = {}
	hit.timePos = timePos
	hit.chord = chord
	return hit
end

return Hit
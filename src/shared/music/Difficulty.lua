local difficulties = {
	["Easy"] = 1,
	["Medium"] = 2,
	["Hard"] = 3,
	["Expert"] = 4
}

-- to make it immutable
return setmetatable({}, {
	__index = function(_, k) 
		return difficulties[k]
		end,
	__newindex = function() 
		error("Cannot modify Enum Difficulty")
		end
	}
)
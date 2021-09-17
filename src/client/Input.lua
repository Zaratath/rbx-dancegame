local CAS = game:GetService("ContextActionService")
local Input = {}

local CHORDS = 4
local KEYS = {
	Enum.KeyCode.Left,
	Enum.KeyCode.Down,
	Enum.KeyCode.Up,
	Enum.KeyCode.Right
}

--[[ Binds input and generates the hit keys. ]]
function Input.bind(callback)
	for i=1,CHORDS do
		CAS:BindAction(i, callback, true, KEYS[i])
	end
end
--[[ Unbinds input, removing hit keys. ]]
function Input.unbind()
	for i=1,CHORDS do
		CAS:UnbindAction(i)
	end
	
end

return Input
local danceAnimation = Instance.new("Animation")
danceAnimation.AnimationId = "rbxassetid://7516694105"

local fumbleAnimation = Instance.new("Animation")
fumbleAnimation.AnimationId = "rbxassetid://7517245849"

local AnimationManager = {}

local danceTracks = {}

function loadAnimation(player, anim): AnimationTrack
	local character = player.Character or player.CharacterAdded:Wait()
	local animator = character.Humanoid:FindFirstChildOfClass("Animator")
	local animationTrack = animator:LoadAnimation(anim)
	return animationTrack
end

--[[ Begins a players dance animationTrack ]]
function AnimationManager.startDance(player: Player)
	local animationTrack = loadAnimation(player, danceAnimation)
	animationTrack.Looped = true
	animationTrack.Priority = Enum.AnimationPriority.Idle
	animationTrack:Play()

	danceTracks[player] = animationTrack
end

--[[ Stops a player's dance animationTrack ]]
function AnimationManager.stopDance(player: Player)
	local track = danceTracks[player]
	if track then
		track:Stop()
	end
	danceTracks[player] = nil
end

--[[ Plays the fumble animation for the given player ]]
function AnimationManager.fumble(player)
	local animationTrack = loadAnimation(player, fumbleAnimation)
	animationTrack.Priority = Enum.AnimationPriority.Action
	animationTrack:Play()
	danceTracks[player] = animationTrack
end


return AnimationManager
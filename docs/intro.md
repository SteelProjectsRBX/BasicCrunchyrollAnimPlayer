# Getting started

## Define your rig(s)
Firstly, you need to create a crunchyroll rig. For example, a setup that constructs a valid R6 rig would look like this:

```lua
local crunchyroll = require(path_to_crunchyroll)

return function()
	return Crunchyroll.create_rig({
		name = "Torso",

		c0 = CFrame.new(0, 0, 0, -1, 0, 0, 0, 0, 1, 0, 1, -0),
		c1 = CFrame.new(0, 0, 0, -1, 0, 0, 0, 0, 1, 0, 1, -0),

		children = {
			{
				name = "Head",
				c0 = CFrame.new(0, 1, 0, -1, 0, 0, 0, 0, 1, 0, 1, -0),
				c1 = CFrame.new(0, -0.5, 0, -1, 0, 0, 0, 0, 1, 0, 1, -0),
			},
			{
				name = "Left Leg",
				c0 = CFrame.new(-1, -1, 0, 0, 0, -1, 0, 1, 0, 1, 0, 0),
				c1 = CFrame.new(-0.5, 1, 0, 0, 0, -1, 0, 1, 0, 1, 0, 0),
			},
			{
				name = "Right Leg",
				c0 = CFrame.new(1, -1, 0, 0, 0, 1, 0, 1, -0, -1, 0, 0),
				c1 = CFrame.new(0.5, 1, 0, 0, 0, 1, 0, 1, -0, -1, 0, 0),
			},
			{
				name = "Left Arm",
				c0 = CFrame.new(-1, 0.5, 0, 0, 0, -1, 0, 1, 0, 1, 0, 0),
				c1 = CFrame.new(0.5, 0.5, 0, 0, 0, -1, 0, 1, 0, 1, 0, 0),
			},
			{
				name = "Right Arm",
				c0 = CFrame.new(1, 0.5, 0, 0, 0, 1, 0, 1, -0, -1, 0, 0),
				c1 = CFrame.new(-0.5, 0.5, 0, 0, 0, 1, 0, 1, -0, -1, 0, 0),
			},
		},
	})
end
```

This function, when called, returns an R6 crunchyroll rig to be used for animating. You should create one for each separate DataModel rig you wish to animate.
___

## Initialize `KeyframeSequence` instances
If needed, a neat trick to extract the `KeyframeSequence` from an Animation object would be to paste this in the RobloxStudio command bar:

```lua
game:GetObjects("AnimationContentURL")[1].Parent = workspace
```

All base R6 `KeyframeSequences` can be downloaded [here](https://github.com/SteelProjectsRBX/BasicCrunchyrollAnimPlayer/raw/refs/heads/main/dev/rigs/r6/r6anims.rbxm), or found at [https://github.com/SteelProjectsRBX/BasicCrunchyrollAnimPlayer/raw/refs/heads/main/dev/rigs/r6/r6anims.rbxm](https://github.com/SteelProjectsRBX/BasicCrunchyrollAnimPlayer/tree/main/dev/rigs/r6)
___

## Basic example of using BasicCrunchyrollAnimPlayer

### Create an `AnimPlayer` object
```lua
local mySigmaRig = BasicCrunchyrollAnimPlayer.CreateAnimator(rig, motor6Ds)
```

You will need to provide the crunchyroll rig to use, and, optionally<sup><span style = "font-size: 0.8em;">1</sup>, an array of `Motor6Ds`, that are named ***exactly as defined in your rig template***. For example, the Motor6D that corresponds to move the `Right Arm` should of course be named `Right Arm`.

For R6 rigs, Roblox names them differently. For example, `Right Arm` is named `Right Shoulder`. Make sure that the crunchyroll rig limbs match the Motor6D names!


### Start playing animations

```lua
local animAsset = crunchyroll:load_keyframe_sequence(sequence)
local playData = {
	alpha = 0,
	
	start_fade_time = 0,
	stop_fade_time = 0,

	weight = 1,
	priority = 1,

	looped = false, -- Whether the animation should repeat after it finishes.
}

mySigmaRig:StartPlayingAnimation(animAsset, playData)
```

To stop an animation:
```lua
mySigmaRig:StopPlayingAnimation(animAsset)
```

### Stepping all animations
If you have supplied Motor6Ds while constructing the player, you can use `:StepForward`
```lua
RunService.Heartbeat:Connect(function(dt)
	local updateLiveToo = false

	mySigmaRig:StepForward(dt, rootCF, updateLiveToo)
end)
```

... where `updateLiveToo` indicates whether to update Motor6Ds to the new solved limb CFrames.


<sub><span style = "font-size: 0.8em;">
1. If you wish to not use Motor6Ds, you won't be able to use `:UpdateLiveLimbCFrames` or pass `updateLiveToo` in certain API functions, as they assume Motor6Ds exist. You can write your own logic about updating CFrames in the DataModel rig.
(`updateLiveToo` is a flag that indicates whether to update `Motor6D.C1`.)
</sub>
___
## Manually updating `Motor6D` CFrames

If you have supplied `Motor6Ds` while constructing the player, you can use `:UpdateLiveLimbCFrames` and `:SetLimbCFramesInstantly`. Both are useful for applying lag compensation.
___

For information on what each function does, view the API reference. Here is an example .rbxl file that utilizes BasicCrunchyrollAnimPlayer.

⠀
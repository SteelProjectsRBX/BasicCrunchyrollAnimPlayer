local animation_asset = require("@self/roblox/animation_asset")
local animation_solver = require("@self/animation_solver")
local rig = require("@self/rig")

--[=[
	@class Crunchyroll
	
	The root module.
]=]

--[=[
	@function load_keyframe_sequence
	@within Crunchyroll
	
	Load a keyframe sequence from Roblox. This will return an AnimationAsset.
	
	@param keyframe_sequence KeyframeSequence
	@return AnimationAsset
]=]

--[=[
	@function create_rig
	@within Crunchyroll
	
	Create a rig from a model. This will return a Rig.
	
	@param rig_hierarchy Limb
	@return Rig
]=]

--[=[
	@function solve_animation
	@within Crunchyroll
	
	The primary function of the module. This will solve the animation for a rig.
	Example:
	```lua
		crunchyroll.solve_animation(rig, {
			[animation] = {
				priority = 1,

				start_fade_time = 0,
				stop_fade_time = 0,
				weight = 1,

				alpha = 0.5,
			},
		}, character.HumanoidRootPart.CFrame)
	```
	
	@param rig Rig
	@param tracks { [AnimationAsset]: AnimationTrack }
	@param root CFrame
]=]

--[=[
	@class Rig
	
	An animated rig. Pass this into the animation solver.
]=]

--[=[
	@prop result_coordinate_frames { [string]: CFrame }
	@within Rig
	
	The result table of the rig. Structured as { [limb name]: CFrame }
]=]

--[=[
	@class AnimationAsset
	
	An animation asset. This stores the animation length, and the keyframes.
]=]

--[=[
	@interface AnimationTrack
	@within Crunchyroll
	.stop_fade_time number
	.start_fade_time number
	.weight number
	.alpha number
	.priority number
	
	This table describes the state of an animation. It is agnostic to the animation asset.
]=]

--[=[
	@interface Limb
	@within Crunchyroll
	.name string
	.c0 CFrame
	.c1 CFrame
	.depends_on string 
	
	This is the Crunchyroll equivalent of a Roblox Motor6D.
	`depends_on` is how the hierarchy works; for example "Head" depends on "Torso"
]=]

export type LimbInfo = rig.LimbInfo
export type Rig = rig.Identity

export type AnimationTrack = animation_solver.AnimationTrack
export type AnimationAsset = animation_asset.Identity

return {
	load_keyframe_sequence = animation_asset.load_keyframe_sequence,
	create_rig = rig.create_rig,

	solve_animation = animation_solver,
}

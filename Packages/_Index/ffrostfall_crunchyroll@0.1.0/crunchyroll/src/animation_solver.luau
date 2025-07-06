local animation_asset = require("./roblox/animation_asset")
local create_rig = require("./rig")

export type AnimationTrack = {
	-- 0-1
	alpha: number,

	-- 0-1
	start_fade_time: number,
	stop_fade_time: number,
	weight: number,

	-- arbitrary number
	priority: number,
}

local function solve_fade_time_influence(
	real_time: number,
	animation_length: number,
	start_fade_time: number,
	stop_fade_time: number
): number
	if real_time <= start_fade_time then
		return math.min(1 - ((start_fade_time - real_time) / start_fade_time), 1)
	elseif real_time >= (animation_length + stop_fade_time) then
		return math.min(
			1 - ((real_time - (animation_length - stop_fade_time)) / stop_fade_time),
			1
		)
	else
		return 1
	end
end

local function animation_solver(
	rig: create_rig.Identity,
	tracks: {
		[animation_asset.Identity]: AnimationTrack,
	},
	root: CFrame
)
	local limb_array: { create_rig.Limb }, result_coordinate_frames: { [string]: CFrame }, total_weight: number =
		rig._topologically_sorted_limbs, rig.result_coordinate_frames, 0
	for _, limb in limb_array do
		limb.priority = -1
	end

	for _, track in tracks do
		total_weight += track.weight
	end

	for animation, playback in tracks do
		local real_time: number, priority: number =
			animation.length * playback.alpha, playback.priority
		local influence: number = (playback.weight / total_weight)
			* solve_fade_time_influence(
				real_time,
				animation.length,
				playback.start_fade_time,
				playback.stop_fade_time
			)

		-- Figure out which keyframes to interpolate between
		local keyframe_after: animation_asset.KeyframeNode?, closest_distance_after: number, keyframe_before: animation_asset.KeyframeNode?, closest_distance_before: number =
			nil, math.huge, nil, math.huge

		for _, keyframe in animation.keyframes do
			local distance = keyframe.time - real_time
			local absolute_distance = math.abs(distance)

			if distance >= 0 and (absolute_distance < closest_distance_after) then
				keyframe_after, closest_distance_after = keyframe, absolute_distance
			elseif distance <= 0 and (absolute_distance < closest_distance_before) then
				keyframe_before, closest_distance_before = keyframe, absolute_distance
			end
		end

		-- Solve limb transforms
		for _, node in limb_array do
			if node.priority > priority then
				continue
			end

			local left_pose, right_pose =
				keyframe_before and keyframe_before.poses[node.name],
				keyframe_after and keyframe_after.poses[node.name]
			local left_or_right = left_pose or right_pose

			if left_pose and right_pose then
				--stylua: ignore
				node.transform, node.priority =
					node.transform:Lerp(
						-- Doubled lerped for blending
						left_pose.coordinate_frame:Lerp(
							right_pose.coordinate_frame,
							left_pose.easing_function((real_time - left_pose.time) / (right_pose.time - left_pose.time))
						),
						influence
					), priority
			elseif left_or_right then
				node.transform, node.priority =
					node.transform:Lerp(left_or_right.coordinate_frame, influence), priority
			end
		end
	end

	result_coordinate_frames["root"] = root
	for _, limb in limb_array do
		result_coordinate_frames[limb.name] = result_coordinate_frames[limb.depends_on]
			* limb.c0
			* limb.transform
			* limb.c1
	end
end

return animation_solver

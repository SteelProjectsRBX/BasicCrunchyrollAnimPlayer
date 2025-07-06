--!strict

local Crunchyroll = require("../Packages/crunchyroll")

local playerConstructor = {}
local playerMethods = {} :: AnimPlayerMethods

export type AnimPlayerModel = Model & { Joints: Folder }

export type AnimationPlayData = Crunchyroll.AnimationTrack & {
	Looped: boolean,
}

export type AnimPlayerObj = {
	Rig: Crunchyroll.Rig,
	LiveModel: AnimPlayerModel,

	_PlayingAnims: { [Crunchyroll.AnimationAsset]: AnimationPlayData },
}

export type AnimPlayerMethods = {
	SetLimbCFramesInstantly: (self: AnimPlayerFull, newLimbWorldCFrames: { [string]: CFrame }) -> (),

	StartPlayingAnimation: (
		self: AnimPlayerFull,
		animAsset: Crunchyroll.AnimationAsset,
		initialTrackData: AnimationPlayData
	) -> (),
	UpdateLiveLimbCFrames: (self: AnimPlayerFull) -> (),
	StopPlayingAnimation: (self: AnimPlayerFull, animToStop: Crunchyroll.AnimationAsset) -> (),

	StepForward: (self: AnimPlayerFull, dt: number, updateLiveToo: boolean?) -> (),
}

export type AnimPlayerFull = AnimPlayerObj & AnimPlayerMethods

function playerConstructor.CreateAnimator(rig: Crunchyroll.Rig, liveModel: AnimPlayerModel): AnimPlayerFull
	local self: AnimPlayerObj = {
		Rig = rig,
		LiveModel = liveModel,

		_PlayingAnims = {},
	}

	for name, fn in playerMethods do
		self[name] = fn
	end

	return self :: AnimPlayerFull
end

function playerMethods.SetLimbCFramesInstantly(
	self: AnimPlayerFull,
	newLimbWorldCFrames: { [string]: CFrame },
	updateLiveToo: boolean?
)
	self.Rig.result_coordinate_frames = newLimbWorldCFrames

	if updateLiveToo == true then
		self:UpdateLiveLimbCFrames()
	end
end

function playerMethods.UpdateLiveLimbCFrames(self: AnimPlayerFull)
	local liveModel = self.LiveModel

	local primaryPart = liveModel.PrimaryPart :: BasePart

	local rootCF = primaryPart.CFrame

	for name, cf in self.Rig.result_coordinate_frames do
		if name == "root" then
			continue
		end

		local correspondingMotor6D = (liveModel.Joints :: any)[name] :: Motor6D
		local newCF = rootCF:ToObjectSpace(cf):Inverse() * correspondingMotor6D.C0

		correspondingMotor6D.C1 = newCF
	end
end

function playerMethods.StepForward(self: AnimPlayerFull, dt: number, updateLiveToo: boolean?)
	local primaryPart = self.LiveModel.PrimaryPart :: BasePart

	for asset, track in self._PlayingAnims do
		local totalTime = asset.length
		local newAlpha = track.alpha + (dt / totalTime)

		if newAlpha >= 1 and not track.Looped then
			self:StopPlayingAnimation(asset)
			continue
		end

		track.alpha = newAlpha % 1 -- modulus 1 to wrap it around when it overshoots
	end

	Crunchyroll.solve_animation(self.Rig, self._PlayingAnims, primaryPart.CFrame) -- also updates rig.result_coordinate_frames

	if updateLiveToo then
		self:UpdateLiveLimbCFrames()
	end
end

function playerMethods.StartPlayingAnimation(
	self: AnimPlayerFull,
	animAsset: Crunchyroll.AnimationAsset,
	playData: AnimationPlayData
)
	self._PlayingAnims[animAsset] = playData
end

function playerMethods.StopPlayingAnimation(self: AnimPlayerFull, animToStop: Crunchyroll.AnimationAsset)
	self._PlayingAnims[animToStop] = nil
end

return playerConstructor
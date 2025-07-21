--!strict

local Crunchyroll = require("../Packages/crunchyroll")

local playerConstructor = {}
local playerMethods = {} :: AnimPlayerMethods

export type AnimationPlayData = Crunchyroll.AnimationTrack & {
	looped: boolean,
}

export type AnimPlayerObj = {
	Rig: Crunchyroll.Rig,
	LimbCFrames: {[string]: CFrame},
	PlayingAnims: { [Crunchyroll.AnimationAsset]: AnimationPlayData },

	_NameSortedJoints: { [string]: Motor6D },
}

export type AnimPlayerMethods = {
	SetLimbCFramesInstantly: (
		self: AnimPlayerFull,
		newLimbWorldCFrames: { [string]: CFrame },
		rootCF: CFrame,
		updateLiveToo: boolean?
	) -> (),

	StartPlayingAnimation: (
		self: AnimPlayerFull,
		animAsset: Crunchyroll.AnimationAsset,
		initialTrackData: AnimationPlayData
	) -> (),
	UpdateLiveLimbCFrames: (self: AnimPlayerFull, rootCF: CFrame) -> (),
	StopPlayingAnimation: (self: AnimPlayerFull, animToStop: Crunchyroll.AnimationAsset) -> (),

	StepForward: (self: AnimPlayerFull, dt: number, rootCF: CFrame, updateLiveToo: boolean?) -> (),
}

export type AnimPlayerFull = AnimPlayerObj & AnimPlayerMethods

function playerConstructor.CreateAnimator(rig: Crunchyroll.Rig, motor6Ds: { Motor6D }): AnimPlayerFull
	local _nameSortedJoints = {}

	for _, motor6d in motor6Ds do
		_nameSortedJoints[motor6d.Name] = motor6d
	end

	local self: AnimPlayerObj = {
		Rig = rig,
		PlayingAnims = {},
		LimbCFrames = rig.result_coordinate_frames,
		
		_NameSortedJoints = _nameSortedJoints,
	}

	for name, fn in playerMethods do
		self[name] = fn
	end

	return self :: AnimPlayerFull
end

function playerMethods.SetLimbCFramesInstantly(
	self: AnimPlayerFull,
	newLimbWorldCFrames: { [string]: CFrame },
	rootCF: CFrame,
	updateLiveToo: boolean?
)
	self.LimbCFrames, self.Rig.result_coordinate_frames = newLimbWorldCFrames, newLimbWorldCFrames

	if updateLiveToo == true then
		self:UpdateLiveLimbCFrames(rootCF)
	end
end

function playerMethods.UpdateLiveLimbCFrames(self: AnimPlayerFull, rootCF: CFrame)
	local motor6Ds = self._NameSortedJoints

	for name, cf in self.Rig.result_coordinate_frames do
		if name == "root" then
			continue
		end

		local correspondingMotor6D = motor6Ds[name]
		local newCF = rootCF:ToObjectSpace(cf):Inverse() * correspondingMotor6D.C0

		correspondingMotor6D.C1 = newCF
	end
end

function playerMethods.StepForward(self: AnimPlayerFull, dt: number, rootCF: CFrame, updateLiveToo: boolean?)
	for asset, track in self.PlayingAnims do
		local totalTime = asset.length
		local newAlpha = track.alpha + (dt / totalTime)

		if newAlpha >= 1 and not track.looped then
			self:StopPlayingAnimation(asset)
			continue
		end

		track.alpha = newAlpha % 1 -- modulus 1 to wrap it around when it overshoots
	end

	Crunchyroll.solve_animation(self.Rig, self.PlayingAnims, rootCF) -- also updates rig.result_coordinate_frames

	if updateLiveToo then
		self:UpdateLiveLimbCFrames(rootCF)
	end
end

function playerMethods.StartPlayingAnimation(
	self: AnimPlayerFull,
	animAsset: Crunchyroll.AnimationAsset,
	playData: AnimationPlayData
)
	
	self.PlayingAnims[animAsset] = playData
end

function playerMethods.StopPlayingAnimation(self: AnimPlayerFull, animToStop: Crunchyroll.AnimationAsset)
	self.PlayingAnims[animToStop] = nil
end

return playerConstructor
--!strict

local crunchyroll = require("./Packages/crunchyroll")
local animPlayer = require("@self/player")

-- // Player types
export type AnimPlayerModel = animPlayer.AnimPlayerModel
export type AnimationPlayData = animPlayer.AnimationPlayData
export type AnimPlayerFull = animPlayer.AnimPlayerFull

-- // Crunchyroll types
export type LimbInfo = crunchyroll.LimbInfo
export type Rig = crunchyroll.Rig

export type AnimationTrack = crunchyroll.AnimationTrack
export type AnimationAsset = crunchyroll.AnimationAsset

return {
	animPlayer = animPlayer,
	crunchyroll = crunchyroll,
}
# API Reference

## BasicCrunchyRollAnimPlayer
___

### .CreateAnimator
Constructs an `AnimPlayer`.

```luau
BasicCrunchyRollAnimPlayer.CreateAnimator(
    rig: Crunchyroll.Rig,
    motor6Ds: {Motor6D}?
) -> AnimPlayer
```

## AnimPlayer
___

### Properties

#### Rig [ <code><a href="https://ffrostfall.github.io/crunchyroll/api/Rig/" target="_blank">Rig</a></code> ]

The crunchyroll rig that is being used.

___

#### LimbCFrames [ {[string]: CFrame} ]

Equal to [`rig.result_coordinate_frames`](https://ffrostfall.github.io/crunchyroll/api/Rig#result_coordinate_frames). The CFrames are in world space.
___

#### PlayingAnims [ {[<a href="https://ffrostfall.github.io/crunchyroll/api/AnimationAsset" target="_blank">AnimationAsset</a>]: [AnimationPlayData](/datatypes/AnimationPlayData)} ]
The list of currently playing animations. Imagine it as `Animator:GetPlayingAnimationTracks()`. **Not meant to be written into.**
___
### Methods

#### `:UpdateLiveLimbCFrames(rootCF: CFrame)`
Uses the passed Motor6Ds to update the `.C1` of every limb to the current [`AnimPlayer.LimbCFrames`](/api/#limbcframes-string-cframe). 

`rootCF` should be the `HumanoidRootPart.CFrame`.
___

#### `:StepForward(dt: number, rootCF: CFrame, updateLiveToo: boolean?)`
Steps forward every animation by `dt`. Stops every animation when its done, unless [`.Looped`](/datatypes/animationdata/#alpha-number) is true.
___

#### `:SetLimbCFramesInstantly(newLimbWorldCFrames: {[string]: CFrame}, rootCF: CFrame, updateLiveToo: boolean)`
Immediately sets `self.LimbCFrames` to the provided `newLimbWorldCFrames` table, and optionally also updates `Motor6D.C1`s if `updateLiveToo` is `true`.

___

#### <code>:StartPlayingAnimation(animAsset: <a href="https://ffrostfall.github.io/crunchyroll/api/AnimationAsset" target="_blank">AnimationAsset</a>, playData: [AnimationPlayData](/datatypes/AnimationPlayData)</code>
Begins playing an animation by inserting it in [`self.PlayingAnims`](/api/#playinganims-animationasset-animationplaydata).

`animAsset` can be retrieved by calling <code> <a href="https://ffrostfall.github.io/crunchyroll/api/Crunchyroll#load_keyframe_sequence" target="_blank">crunchyroll.load_keyframe_sequence(keyframe_sequence)</a> </code>

___

#### <code>:StopPlayingAnimation(animAsset: <a href="https://ffrostfall.github.io/crunchyroll/api/AnimationAsset" target="_blank">AnimationAsset</a>)</code>
Immediately stops playing an animation by removing it from [`self.PlayingAnims`](/api/#playinganims-animationasset-animationplaydata).
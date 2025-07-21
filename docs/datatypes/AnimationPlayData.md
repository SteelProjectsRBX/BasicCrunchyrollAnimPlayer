# AnimationPlayData

## Summary
```luau
AnimationPlayData: {
    alpha: number,

    start_fade_time: number,
    stop_fade_time: number,

    weight: number,
    priority: number,

    looped: boolean
}
```

## Fields

### alpha [number]
The percentage (0 - 1) of the animation progress.
___

### start_fade_time [number]
⠀
___

### stop_fade_time [number]
⠀
___

### weight [number]
Higher value = higher animation weight, which basically means the animation has more influence over other playing animations.

___
### priority [number]
If there are multiple animations that influence the same limb, the animations with the lowest priority values will be played, and other animations will be ignored.

### looped [boolean?]
Animations with `looped` set to `false` or `nil` will be immediately stopped when their [`alpha`](/datatypes/animationdata#alpha-number) reaches 1 when using [`AnimPlayer:StepForward()`](/api/#stepforwarddt-number-rootcf-cframe-updatelivetoo-boolean).

```
This is a basic custom animation player, which wraps around [ffrostfall's crunchyroll](https://github.com/ffrostfall/crunchyroll) to play animations from `KeyframeSequences`.


https://github.com/user-attachments/assets/20c4fef7-9eeb-4935-b2ca-038187333e7e


It works with any rig format you give it (R6, R15, custom) and this repository comes with the R6 rig.

To actually move the limbs using the API, you can pass an array of [`Motor6Ds`](https://create.roblox.com/docs/reference/engine/classes/Motor6D) for this module to manipulate. If you don't want to use Motor6Ds, you can just use the result world CFrames at any time via [`player.LimbCFrames`](https://steelprojectsrbx.github.io/BasicCrunchyrollAnimPlayer/api/#limbcframes-string-cframe)

Documentation: https://steelprojectsrbx.github.io/BasicCrunchyrollAnimPlayer/

# Installation

## Wally
```
basiccrunchyrollanimplayer = "steelprojectsrbx/basiccrunchyrollanimplayer@0.1.2"
```

## Roblox Studio
Head over to the [latest release](https://github.com/SteelProjectsRBX/BasicCrunchyrollAnimPlayer/releases) and download the `build.rbxm` file.
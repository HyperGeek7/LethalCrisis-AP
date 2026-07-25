# Lethal Crisis APWorld
A very early stab at implementing a Lethal Crisis APWorld. This has been tested against the Steam release of Lethal Crisis, but it should work just fine against the physical or DLSite releases, assuming they're fully patched. It also installs cleanly on top of an English-patched install of Lethal Crisis, although the reverse is not true.

**This is early in development. It's fully playable, but be prepared to cheat in stage or item unlocks if you get stuck. Report any problems you run into in the Issues tab of the repo.**

This repo is actually three repos in a trenchcoat:
- `patch_files` contains the modified lua files that must be injected into Lethal Crisis to let it talk to the AP client.
- `lc-ap_patcher` contains the source for the installer that actually injects those files.
- `lethalcrisis` contains the apworld itself.

## Setup
- **Back up your save files if you want to keep them.** These are in the `save` folder under your Lethal Crisis install. The AP patch cannot differentiate between "normal" save files and ones associated with an AP game, and it will bork your save data if you accidentally load it.
    - In addition, an issue with Lethal Crisis's Steam implementation means that verifying game files also blasts your saves. This patch makes a backup such that you shouldn't _need_ to do this to get back to a vanilla install, but it's an easy mistake to make if you're running on autopilot.
- If you intend to install the English patch and haven't done it already, do that first. The AP patch can be applied on top of the English patch, but the English patch cannot be applied on top of the AP patch.
- You will need to download 3 files from the latest release:
    - `lethalcrisis.apworld`, which should be installed to Archipelago as usual.
    - `ap_patch_files.lczip`, which should be placed in your Lethal Crisis folder next to `Lethal Crisis.exe` and `Lethal Crisis.p`. **Leave this zipped, do not extract it.**
    - Either `lc-ap_patcher-x86_64-windows.exe` or `lc-ap_patcher-x86_64-linux`, depending on your OS, which should also be placed in your Lethal Crisis folder next to `ap_patch_files.lczip`.
- If you're running the Steam release of LC, you should just need to run the patcher (`lc-ap_patcher-x86_64-windows.exe` or `lc-ap_patcher-x86_64-linux`). If you're using one of the Japanese releases, drag `リーサルクライシス.p` onto the patcher.
    - If you're running a non-Steam release on Linux, this fallback might not launch the patcher properly. In that case, you'll need to launch the patcher from the terminal, passing in the `.p` file as an argument, i.e. `./lc-ap_patcher-x86_64-linux リーサルクライシス.p`.
- Assuming the patcher runs successfully, you are ready to play!

## Playing
- Once the APWorld is installed, you should have a "Lethal Crisis Client" option in your launcher.
- Launch the AP client **before** starting Lethal Crisis itself.
- Enter your connection details and player name as usual.
- Start Lethal Crisis.
- When you arrive at the title screen, a line reading "Lethal Crisis has connected!" should appear in the client. Once you see this, you are free to start a new file in Lethal Crisis and begin playing.

## Uninstalling
The patcher backs up your original `Lethal Crisis.p` as `Lethal Crisis.p.vanilla` in your Lethal Crisis folder. Simply delete `Lethal Crisis.p` and rename `Lethal Crisis.p.vanilla` to take its place.

## Known issues, limitations, and to-dos.
- Once you have access to 10B, _all_ of the finale stages open up, which makes it fairly trivial to just go to 17B and finish the game without playing any of the intervening stages. This is a quirk of how the intermission screen is programmed, which doesn't allow for "normal" progress through the B stages while leaving the rest of the stages available for play. This isn't insurmountable, but fixing it will require replacing INTERMISSION.LUA with a decompiled version I can edit, which is...daunting.
- The exact way AP Items were implemented means that all application descriptions use the English translations, even if the rest of the game is in Japanese. This can probably be detected and worked around with a separate TEXT_APMESSAGE.LUA file for JP, but for this pass I figure that odds are good anyone playing this rando speaks English.
- There is no in-game indicator when you receive items. I want to add some text in the corner or something for this, but for now you need to keep the client up elsewhere to keep on top of things.
- The only goal available right now is getting stage 17B's D rank and achieving the true ending. Earlier objectives (e.g., getting 16's D rank, the normal ending) should be doable, but they're not yet implemented.
- Logic definitely needs some help. I have little doubt I've left some ranks with default handling that really want a more specific pool of applications or stat limiters. Conversely, I've probably put logic on some ranks that's stricter than they actually warrant. It'll need some dialing in.
- Life and energy maxes don't update mid-stage, which is a limitation of the engine. Similarly, stage and application unlocks are flaky while in the intermission screen.
- The results screen can be behave a little strangely if you happen to get a location unlock the screen would have revealed while the screen is already up. This is most noticeable with the auto-release when you clear your goal.

## Thanks and acknowledgements
- json.lua is lifted directly from [rxi's repo](https://github.com/rxi/json.lua), and this project would not work without it.
- theKeithD for [thmj3g-tools](https://github.com/theKeithD/thmj3g-tools). No code from this is directly included in the AP world, but it was still a handy starting point for modifying an AIMS game.
- viruscamp et al. for [luadec](https://github.com/viruscamp/luadec), which produced a couple of the decompiled (and subsequently modified) lua files included in the patch.
- tehtmi for [unluac](https://sourceforge.net/projects/unluac/), which didn't _directly_ produce any files used in this project, but which was invaluable for helping to untangle the logic in some files luadec couldn't handle. Looking at you, INTERMISSION.LUA.
- Similarly, x3zvawq et al. for [unluac-rs](https://github.com/x3zvawq/unluac-rs), which came in clutch right at the end of development for cleaning up a crash in INTERMISSION.LUA.
- All the many developers of Archipelago and its APWorlds, for producing such a fun environment to play around in and expand.
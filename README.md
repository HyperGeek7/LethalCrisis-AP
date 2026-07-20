# Lethal Crisis AP World
A very early stab at implementing an LC APWorld. This has been tested against the Steam release of Lethal Crisis, but it should work just fine against the physical or DLSite releases, assuming they're fully patched. It _should_ also install cleanly on top of an English-patched install of LC.

**This is early in development. It's fully playable, but be prepared to cheat in stage or item unlocks if you get stuck. Report any problems you run into in the Issues tab of the repo.**

The APWorld lives under the `lethalcrisis` folder, while files that have to be written into LC's pack file are under the patch_files folder. Setup instructions and documentation are under `lethalcrisis/docs`, as usual, but you can also find them below.

## Known issues, limitations, and to-dos.
- Once you have access to 10B, _all_ of the finale stages open up, which makes it fairly trivial to just go to 17B and finish the game without playing any of the intervening stages. This is a quirk of how the intermission screen is programmed, which doesn't allow for "normal" progress through the B stages while leaving the rest of the stages available for play. This isn't insurmountable, but fixing it will require replacing INTERMISSION.LUA with a decompiled version, which is...daunting.
- The exact way AP Items were implemented means that *all* application descriptions use the English translations, even if the rest of the game is in Japanese. This can probably be detected and worked around with a separate TEXT_APMESSAGE.LUA file for JP, but for this pass I figure that odds are good anyone playing this thing speaks English.
- There is no in-game indicator when you receive items. I want to add some text in the corner or something for this, but for now you need to keep the client up elsewhere to keep on top of things.
- The only goal available right now is getting stage 17B's D rank and achieving the true ending. Earlier objectives (e.g., getting 16's D rank, the normal ending) are on the list, but not yet implemented.
- Logic definitely needs some help. I have little doubt I've left some ranks with default handling that really want a more specific pool of applications or stat limiters. Conversely, I've probably put logic on some ranks that's stricter than they actually warrant. It'll need some dialing in.
- Life and energy maxes don't update mid-stage, which is a limitation of the engine. Similarly, stage and application unlocks are flaky while in the intermission screen.
- The results screen can be behave a little strangely if you happen to get a location unlock the screen would have revealed while the screen is already up. This is most noticeable with the auto-release when you clear your goal.

## Thanks and acknowledgements
- theKeithD for [thmj3g-tools](https://github.com/theKeithD/thmj3g-tools). No code from this is directly included in the AP world, but it was still a handy starting point for modifying an AIMS game.
- viruscamp et al. for [luadec](https://github.com/viruscamp/luadec), which produced a couple of the decompiled (and subsequently modified) lua files included in the patch.
- tehtmi for [unluac](https://sourceforge.net/projects/unluac/), which didn't _directly_ produce any files used in this project, but which was invaluable for helping to untangle the logic in some files luadec couldn't handle. Looking at you, INTERMISSION.LUA.
- Similarly, x3zvawq et al. for [unluac-rs](https://github.com/x3zvawq/unluac-rs), which came in clutch right at the end of development for cleaning up a crash in INTERMISSION.LUA.
- All the many developers of Archipelago and its APWorlds, for producing such a fun environment to play around in and expand.
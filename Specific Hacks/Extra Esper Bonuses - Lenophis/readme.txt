Title: Espers Giveth, Espers Taketh
Author: Lenophis
Version: 0.2
Applies to: FF6us v1.0
Tested on: FF6us v1.0
           bsnes accuracy core
           SNES console via SD2SNES

Contents: Level Up.bps
          Level Up.ips
          Anti Level Up.bps
          Anti Level Up.ips
          levelup.asm
          readme.txt
          FF6-FWF.tbl

ROM addresses: C0/BDE2 - C0/BDF1
               C0/D7C0 - C0/D86D
               C2/0EAE - C2/0EBF
               C2/60F1 - C2/60F3
               C2/614E - C2/615D
               C2/6658 - C2/6681
               C3/5BF6 - C3/5C05
               C3/5C06 - C3/5C1B now becomes free space
               CF/FEED - CF/FF6A
               ED/FD00 - ED/FFA6

Urgency: Very urgent if you are a rom hacker and like options! Ok, maybe not
that urgent. But maybe!

--------------------------------------------------------------------------------
Description:

Adds 6 new Esper levelup bonuses to the pool.

--------------------------------------------------------------------------------
What this patch does:

The Esper bonus pool has 2 unused entries, which originally were made into
Evade + 1 and Magic Evade + 1. Eventually, it was suggested that Defense and
Magic Defense also be added to the mix. Defense and Magic Defense each have a
plus 1 and plus 2 bonus for the player.

The anti-patches effectively remove this patch.
--------------------------------------------------------------------------------
WHAT YOU NEED TO DO!

This patch is made for hack authors, not necessarily general-audience players.
You need to hack the Esper bonuses in yourself! You can do this with a hex
editor, with the bonuses at D8/6E00 in the Esper data. Otherwise, you can use
Lord J's popular FF3usME utility to add them in. In hex, the new bonuses are
hex entries 0x07, 0x08, 0x11, 0x12, 0x13, and 0x14.

Afterwards, fire up the game and have new fun leveling up.

--------------------------------------------------------------------------------
WARNING!

This patch was made specifically for the FF6 Worlds Collide randomizer. No
effort was made to make sure this patch does not conflict with any other
existing patches! In fact, count on it conflicting! Very Bad Things™ will happen
if you patch this to another hack, or apply it after patching out some bugs!

Luckily for you, the assembly file was included, so all you need to do is change
the addresses needed in bank C2, use xkas v0.6 and assemble it!

--------------------------------------------------------------------------------
SECOND WARNING!

This patch uses SRAM! It takes hold of the 48 bytes set aside for the
Japanese-exclusive SwdTech naming that went unused in the US release for FF6.
Since Gogo and Umaro cannot use Espers, it fit perfectly within all of SRAM.
Each character uses 4 bytes for their bonuses, and 12 characters can equip
Espers. Specifically, $1CF8 through $1D27 are now used for this patch.

Because of this, it is *EXTREMELY RECOMMENDED* that players start a new game
after applying said patch.

--------------------------------------------------------------------------------

Version history:

November 6, 2020
v0.2 - Added safety check.
Gogo and Umaro weren't properly accounted for when adding in the boosted values,
so their evade, magic evade, defense, and magic defense would have been tainted.
For Umaro, you may not have even noticed much of a difference because of his
natural Snow Muffler.

October 25, 2020
v0.1 - Initial version.

--------------------------------------------------------------------------------
Credits:

Cecil - Pitched the idea of Defense and Magic Defense getting their own Esper
bonuses.

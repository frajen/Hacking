|----------------------------------------------|
| Random Encounters Menu Option                |
| by: madsiur                                  |
| version: 1.1a                                |
| released on: January 30th, 2022              |
| apply to: FF3us 1.0 (no header)              |
|----------------------------------------------|

|----------------------------------------------|
| 1- Files                                     |
|----------------------------------------------|

encounters_on_off_nh.ips: IPS patch for the on/off options hack
encounters_on_off_anti_nh.ips: IPS patch to revert the on/off options hack
asm/on-off/main.asm: Main assembly file, use it to assemble the on/off options hack
asm/on-off/bank_C0.asm: Code that deals with random encounters (used by asm/on-off/main.asm)
asm/on-off/bank_C3.asm: Code that deals with the config menu option (used by asm/on-off/main.asm)

encounters_multi_nh.ips: IPS patch for the multi options hack
encounters_multi_anti_nh.ips: IPS patch to revert the multi options hack
asm/multi/main_multi.asm: Main assembly file, use it to assemble the multi options hack
asm/multi/bank_C0_multi.asm: Code that deals with random encounters (used by asm/multi/main_multi.asm)
asm/multi/bank_C3_multi.asm: Code that deals with the config menu option (used by asm/multi/main_multi.asm)

encounters_multi_dp_nh.ips: IPS patch for the multi options hack (Divergent Paths incrementors)
encounters_multi_dp_anti_nh.ips: IPS patch to revert the multi options hack (Divergent Paths incrementors)
asm/multi/bank_C0_multi_dp.asm: Code that deals with random encounters (used by asm/multi/main_multi.asm)

|----------------------------------------------|
| 2- Description                               |
|----------------------------------------------|

This hack add config menu options for random encounters. There are two hacks.
The first one was version 1.0 which had an on/off option. The second one
has 4 options respectively 0%, 50%, 100% and 150% random encounter rates.
In other words, if you select 150% for example a random battle will occur
in average 50% faster than normal. There is also a third option which is
the multi options hack but it use Divergent Paths random encounters
incrementor values (75% of vanilla values), so you can expect with that one
around 75% of the random encounters number compared to the original game.
All the hacks use free SRAM $7E1E1F to save the player's choice but this
can be changed for example in main.asm.

With the on/off options hack, you can now use the Moogle Charm relic for
something else, and the new code does no longer checks for that flag
($7E11DF bit 1) when preparing a possible random encounter. You can also
now repurpose the "no encounter" item flag.

The same apply to the multi options hack but on top of that the Charm Bangle
is no longer useful so you can repurpose it in the same mannner if you use
that hack. In the multi options hack, $7E1E1F is loaded instead of $7E11DF
when preparing a random encounter.

The multi options hack also has the difference that it edit and reorder the
8 incrementor tables in asm/multi/bank_C0_multi.asm. If you want to fine tune
the random encounter rate, it's the best place to do so. I believe some fine
tuning could be possible there; the 50% (half) and 100% (normal) tables have
been kept intact but the 150% one does a flat +50% of the 100% table, in the
same manner than the difference between the 50% and 100% table in vanilla
(the values are doubled).

The on/off options hack use 118 ($76) bytes of free space at $C3F091 and the
multi options one use 186 bytes ($BA) bytes at the same offset. For the
$C0 bank, 17($11) bytes of free space are used by the on/off options hack
and 9 bytes are used by the multi options hack. You can change those free
space offsets in the ASM files by modifying the org instructions as long as
the new offsets are in the same banks. To assemble the hack type an xkas 0.06
command such as "xkas main_multi.asm rom.smc" at the root of the asm/multi
folder.

A final note; if you use one of the three hacks you'll need to restart a new
game to have it work correctly, because the correct SRAM initialization is
done at the beginning of the game. An alternative is to use bsnes+ debugger,
load a game and before entering the main menu go to debugger -> memory editor,
then type 7E1E1F and edit the value there to a value between 00 to 01 for
the on/off options hack and 00 to 03 for the multi options hack.
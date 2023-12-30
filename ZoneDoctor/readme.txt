ZONE DOCTOR - Final Fantasy 6 Editor
Version: 3.18.4
Date: August 26, 2013
Home Page: http://home.comcast.net/~giangurgolo/ff6/
Written by giangurgolo

_______________________________________________________________________

READ THIS FIRST
_______________________________________________________________________

If this is your first time using Zone Doctor, please take the time to
read the following advice:

1. When planning a hack project, the wisest thing to do is to make sure
   you have the back-up option enabled in the settings. Click the cog icon
   and check either "Create Back-up ROM on Load" or "Create Back-up ROM on
   Save" to enable it. I often hear about users throwing in the towel when
   the application corrupts the ROM, never having bothered to use the
   back-up feature.

2. If you receive an error prompt, please follow the directions in the
   prompt window and copy ALL of the contents of the error message and
   post them to the given link in the window. Unless you do this, there is
   little hope of the bug ever being fixed unless someone else encounters
   it and posts it to the link. Keep in mind, I do read bug reports and I
   do attempt to fix the reported bugs, so your post will not be a waste
   of time.

3. If the unfortunate occasion might arise that the application
   actually does corrupt your ROM, you can try resetting the corrupted
   elements by importing those specific elements from a fresh FF6us ROM.
   Click the button "Import elements from another ROM" (a down-arrow over
   a small white box), select a fresh ROM, and check the elements you want
   to import.

Should you encounter any issues, errors, problems, or irritations using
the application, please post them to the following link:
http://www.ff6hacking.com/forums/showthread.php?tid=2282

_______________________________________________________________________

INTRODUCTION
_______________________________________________________________________

Zone Doctor is a third party .NET application written in the C# 
programming language which is capable of editing the locations and event 
scripts in the Final Fantasy 6/3 (US) ROM image file. It's code base, 
GUI, and additional features are based off of the Zone Doctor 
application, with a number of changes to accomodate the different format 
of the source ROM image. Resources and documents consulted include but 
are not limited to Evil Peer's FF6 Offsets Guide, Geiger's offsets 
compendium, Lord J's event disassembly source code, Imzogelmo's updated 
event disassembly, and Yousei's compression code. To see the complete 
history of changes made from version to version, view the changelog.txt 
file.

_______________________________________________________________________

PROGRAM REQUIREMENTS
_______________________________________________________________________

Microsoft .NET Framework 2.0 or higher must be installed on the system
for the application to run at all.
Minimal system requirements:
512MB of RAM (1GB recommended)
10MB HD space (more if ROM back-ups used)

_______________________________________________________________________

MAIN FEATURES
_______________________________________________________________________

The editor is comprised of 2 individual editors. 
The Locations portion allows the user to modify the maps of areas (aka 
locations) using a paint-like interface, the NPCs (ie the sprites in the 
maps), the exit fields (aka entrances), event fields, treasures, and the 
basic layering properties. A template creator/editor lets the user to 
store a separate portion of the map composed of all 3 layers and the 
physical layer into a single file.
The event scripts editor in Zone Doctor enable the user to modify the 
event scripts. Commands within event scripts and action scripts may be 
added, modified, deleted, moved, or copied and pasted.

_______________________________________________________________________

EXTRA FEATURES
_______________________________________________________________________

Users are able to import and export many elements from previously 
exported .dat, .bin, or .pal files in all portions of the editor as a 
means of backing up or inter-changing elements. Clearing/erasing data is 
managed as well so as to free up space for new scripts or dialogues. The 
notes database manager was written for the editor to aid the user aiming 
to create a full or partial hack. Indexes for elements such as monsters, 
levels, etc. can be added and a user-defined description provided as 
well. Adding new indexes is simplified with an option for adding a 
specific index within a portion of the editor by right- clicking the 
name list or index number. The user can also load a selected index in 
the notes database manager into its respective portion of the editor 
where it can be modified there.
A previewer for levels and event scripts lets the user load a temporary 
ROM created from the current modifications in the currently loaded ROM 
image into an emulator of choice (the only options so far are ZSNES and 
SNES9X). Zone Doctor will create a save state which, when loaded, will 
immediately enter the current level or initiate the current event or 
battle script.
There are many more smaller features which are too numerous to list
here, and are scattered throughout the editor with the purpose of
easing the use of Zone Doctor and reducing the amount of work required
to complete a task.
That's what all of these extra features are here for. Not as bells and
whistles, but for making the hacking process less headache-inducing.

_______________________________________________________________________

UNSUPPORTED FEATURES
_______________________________________________________________________

Due to the abundance of editors on the internet which are capable of
modifying most other elements in FF6, Zone Doctor will currently only
support the modification of locations and event scripts. It also must
be noted that users will likely experience difficulties modifying hacks
in Zone Doctor, particularly if those hacks have moved pointers/offsets
to custom locations (ex: dialogues).

_______________________________________________________________________

USING THE PREVIEWER
_______________________________________________________________________

Before using the previewer, do the following: 
1. Make sure all editor files are in the same folder. 
2. Configure the emulator's save-state folder to read/write to the same
folder as any loaded ROM. ZSNES by default already does this, and so
does Snes9x v1.43. However, later versions of Snes9x will by default
read/write to a "Save" folder created within the emulator's main
folder, and if not changed it will fail to load the preview save state.
Choose either the SNES9X or ZSNES emulator file to use when opening the
previewer. ZSNES will automatically load the generated save state when
the emulator is loaded from the previewer, but for SNES9X the F1 key
must be pressed manually to load the generated save state. If the
emulator has problems loading the save state, make sure the 2 steps
above have been completed. 
The latest version of ZSNES (v1.51 as of this release) is supported.
Snes9x v1.43 and/or its derivatives (rerecord, Geiger's debugger, etc.)
are preferred and should work. 

_______________________________________________________________________

FILES IN ARCHIVE
_______________________________________________________________________

*** Make sure all files stay within the same directory as each other,
or there will be problems running Zone Doctor ***


"ZONEDOCTOR.exe"

The application.


"RomPreviewBaseSave.000, RomPreviewBaseSave.zst"

These generate automatically when needed.
Base savestates for SNES9X and ZSNES, respectively. These are needed
for previewing levels, event scripts, and battle scripts using either
ZSNES or SNES9X. To avoid complications, make sure the emulators are in
the same directory as everything else and that their save directories
are configured likewise.


"changelog.txt"

All of the fixes, modifications, and additions since the earliest
versions are chronicled here.


"readme.txt"

This file.


_______________________________________________________________________

BUGS, ERRORS, EXCEPTIONS AND COMPLICATIONS IN FUNCTIONALITY.
_______________________________________________________________________

The editor may occasionally crash or not function properly due to
certain errors in the code (although with each new bugfix I am aiming
to completely remove the possibility of this ever happening). Please
remember that this is almost certainly the programmer's fault and NOT
yours, the user's. As often is the case, when an error surfaces or the
program behaves in a buggy fashion, the user tends to immediately feel
that they are to blame or the programmer is blaming them for the error.
This is not correct: almost all of the time, it's the programmer's
fault. Incidences when it might be the fault of the user may be due to
a corrupt ROM being loaded (a corrupt ROM basically means any SMRPG rom
which has been modified in any way, shape or form). This includes a ROM
edited by Zone Doctor, but errors may occur if a ROM has been modified
outside of Zone Doctor (ie. a hex editor), or often times in much older
versions of Zone Doctor (formerly known as FF6LE).
If the editor crashes, make sure it is the latest version of Zone Doctor
by clicking the "(i)" button in the main window and comparing the
version there to the version posted on the home page
(http://home.comcast.net/~giangurgolo/ff6/).
If you are using the latest version, make a new post in this
thread:
http://www.ff6hacking.com/forums/showthread.php?tid=2282
Explain exactly what you did to produce this error or cause this
disfunctionality to occur, what editor it was in, what order you did
your actions to produce this error or disfunctionality, etc. Also, when
the editor bugs out, an exception prompt appears. If you can manage to
copy the error message after this:
************** Exception Text **************
and include it in your post, it will definitely help. But most
importantly, you must explain in your post what you did. Only posting
the exception text alone will not be adequate enough.
The suggestions above are only suggestions. Sometimes only five words
might be enough for me to quickly locate the bug and fix it. Remember,
an error or bug is most likely NOT YOUR FAULT. Don't be afraid to
report an error should it occur. I do notice and try to fix every bug
that is reported, so your post won't be in vain (unless you're making a
request for an addition to the editor, which I am now ignoring due to
how time-consuming it can be).

_______________________________________________________________________

SPECIAL THANKS
_______________________________________________________________________

ff6hacking.com board - bug reports and helpful suggestions
Geiger - offset document was main source of information
Imzogelmo - beta testing, feedback, discovered many bugs with pre-release
Lenophis - data information, beta testing, checksum recalculation
LordJ - FF3usME interoperability fix code, event command documentation
Novalia Spirit - beta testing, information on unknown properties
sleepydude - map editor helped find some data
Yousei - FF3Edit source code used for (de)compression
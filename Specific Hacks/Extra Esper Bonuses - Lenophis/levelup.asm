
hirom
; no header is assumed here

table FF6-FWF.tbl,rtl
; we need our table included for the text that will be happening!

; ATTENTION PATCH USERS!
; This patch was initially made for the FF6 Worlds Collide randomizer.
; Free space used here was specifically for this randomizer, meaning I didn't bother to make sure it doesn't conflict with other patches!
; Before assembling, be sure that where these addresses do not conflict!
; Look for an 'org' with a "FREE SPACE ALERT!" to know what to change.

org $C0BDE2
; first thing's first! we must zero out all of the SwdTech names set in SRAM init!
; but guess what, they are already zeroed out before the loop even starts!
; time to work some magic
NOP
NOP  ; this removes an LDX $00
NOP
NOP
NOP
NOP  ; this removes an LDA $CF3C40,X
NOP
NOP
NOP  ; this removes an STA $1CF8,X
NOP  ; INX
NOP
NOP
NOP  ; CPX #$0030
NOP
NOP  ; BNE $BDE4
; no other code needs to change here, although there's certainly room to optimize it!

org $C0D7C0
; FREE SPACE ALERT!
; to take up as little free space as possible in C2, we're going to do the bulk of our code in C0 instead
C0evade:
C0m_evade:
; coming in, X is 0x0E or 0x10 due to *2 from indexing
; Y holds current character index from $1600
; X and Y can be trashed as needed, since PLX and PLY follow this routine
; we need to get character ID so we can properly access our evade bonuses
; fortunately, we don't need to worry about a Gogo or Umaro check here, because they've already been accounted for
LDA $1600,Y  ; get our ID
ASL A
ASL A  ; *4 because each character has four stats to boost here
TAY
CPX #$0010
BCC not_m_evade  ; if carry is set, X is #$10 so we would do magic evade instead
INY  ; add one to Y to point at magic evade instead
not_m_evade:
LDA $1CF8,Y  ; now we load up our evade boost from before
INC A
CMP #$81  ; is it at 129? cap if so. evade soft caps at 128 because nothing can touch you at that point anyway
BCC evade_max
LDA #$80
evade_max:
STA $1CF8,Y
RTL

C0def:
; we will do similar to how strength, magic, speed, and stamina get added for defense and magic defense
LDA $1600,Y
ASL A
ASL A  ; *4 because each character has four stats to boost here
TAY
TXA
LSR A
LSR A  ; if the low bit was set, we're only doing +1
LDA $1CFA,Y  ; load defense bonus
INC A
BCS def_plus_1
INC A
def_plus_1:
STA $1CFA,Y  ; at no point can defense ever get to 255 through leveling, so no need to check for wrapping
RTL

C0m_def:
; we will do similar to how strength, magic, speed, and stamina get added for defense and magic defense
LDA $1600,Y
ASL A
ASL A  ; *4 because each character has four stats to boost here
TAY
TXA
LSR A
LSR A  ; if the low bit was set, we're only doing +1
LDA $1CFB,Y  ; load magic defense bonus
INC A
BCS m_def_plus_1
INC A
m_def_plus_1:
STA $1CFB,Y  ; at no point can magic defense ever get to 255 through leveling, so no need to check for wrapping
RTL

C0add_def_bonus:
; character index is now 5 bytes into the stack at this point
; coming in, X is our indexed character info block at $ED7CAA
; Y is "derefenced" at this point. it is pushed to the stack from equipment check, but still holds whatever coming in. it can be used as scratch
; we hooked the LDA directly, so this should be easy enough
; coming in, M is clear so accumulator is 16-bit
LDA $ED7CAB,X  ; defense and magic defense
STA $11BA  ; save both for now
LDA $04,S  ; load our character index again
TAY
TDC
SEP #$20
LDA $15DB,Y  ; starts at $1600, but equipment check has its indexing set at weird points
CMP #$0C  ; is it Gogo, Umaro, or someone higher?
BCS get_out  ; branch if so, they can't get boosted
ASL A
ASL A
TAY
LDA $1CFA,Y  ; load our boosted defense
CLC
ADC $11BA
BCC def_no_wrap
LDA #$FF
def_no_wrap:
STA $11BA
LDA $1CFB,Y  ; load our boosted magic defense
CLC
ADC $11BB
BCC m_def_no_wrap
LDA #$FF
m_def_no_wrap:
STA $11BB

C0add_e_bonus:
REP #$20
LDA $ED7CAD,X
SEP #$20  ; sets M to 8 bit
STA $11A8  ; save evade for now
XBA
STA $11AA  ; save magic evade for now
LDA $1CF8,Y  ; load our boosted evade
CLC
ADC $11A8  ; add in our evade from equipment
CMP #$81  ; is it at 129? cap if so. evade soft caps at 128 because nothing can touch you at that point anyway
BCC C0evade_good
LDA #$80
C0evade_good:
STA $11A8
LDA $1CF9,Y
CLC
ADC $11AA  ; add in our magic evade from equipment
CMP #$81  ; is it at 129? cap if so. magic evade soft caps at 128 because nothing can touch you at that point anyway
BCC C0m_evade_good
LDA #$80
C0m_evade_good:
RTL

get_out:
; if we're here, our character is Gogo, Umaro, or someone higher. That means they can't get boosted stats.
REP #$20
LDA $ED7CAD,X  ; so let's load our evade and magic evade like we normally would
SEP #$20
STA $11A8  ; save evade
RTL  ; and exit out for magic evade

; --------------------------------------------------
; End of bank C0 code. Now on to bank C2
; --------------------------------------------------
org $C20EAE
; we are in the middle of the "Equipment check" function.
; at this point, 16-bit A holds evade and magic evade pulled from the character data at $ED7CAD indexed
; to clarify, the lower 8 bits hold evade, and the upper 8 bits hold magic evade
; the first two bytes on the stack hold our character index
JSL C0add_def_bonus
padbyte $EA : pad $C20EBF
; since defense, magic defense, evade, and magic evade are all back-to-back, let's just condense the bonus adding into one call and pad out the rest with NOP's
; following this is STA $11AA, we'll obviously keep it so we don't need extra code

org $C260F1
JSR (bonuses,X)

org $C2614E
; original location for the esper bonuses in vanilla
; now will be used for some JSL calls into C0 to handle the levelup bonuses
evade_m_evade_up:
JSL C0evade
RTS

def_bonus:
JSL C0def
RTS

m_def_bonus:
JSL C0m_def
RTS

org $C26658
; FREE SPACE ALERT!
; these are pointers to the levelup bonuses tied to Espers
; these are all vanilla pointers, except for the two that I am hijacking
; they were not used in vanilla
bonuses:
DW $6170  ; 0 - HP gained +10%
DW $6174  ; 1 - HP gained +30%
DW $6178  ; 2 - HP gained +50%
DW $6170  ; 3 - MP gained +10%
DW $6174  ; 4 - MP gained +30%
DW $6178  ; 5 - MP gained +50%
DW $61B0  ; 6 - HP gained x2
DW evade_m_evade_up  ; 7 - evade
DW evade_m_evade_up  ; 8 - magic evade
DW $619B  ; 9 - Strength +1
DW $619B  ; 10 - Strength +2
DW $619A  ; 11 - Speed +1
DW $619A  ; 12 - Speed +2
DW $6199  ; 13 - Stamina +1
DW $6199  ; 14 - Stamina +2
DW $6198  ; 15 - Magic+1
DW $6198  ; 16 - Magic+2
; adding in 4 new bonuses!
DW def_bonus  ; 17 - Defense +1
DW def_bonus  ; 18 - Defense +2
DW m_def_bonus  ; 19 - Magic Defense +1
DW m_def_bonus  ; 20 - Magic Defense +2

; --------------------------------------------------
; End of bank C2 code. Now on to bank C3
; --------------------------------------------------
org $C35BF6
; a little bit of optimization and also makes the pointers absolute instead of relative
LDX #esper_long_ptr
STX $E7
LDX $00
STX $EB
LDA #$ED
STA $E9
STA $ED
RTS

; --------------------------------------------------
; End of bank C3 code. Now on to the descriptions
; --------------------------------------------------
org $EDFD00
esper_long_ptr:
DW HP_10
DW HP_30
DW HP_50
DW MP_10
DW MP_30
DW MP_50
DW HP_double
DW evade_desc
DW m_evade_desc
DW str_1
DW str_2
DW agi_1
DW agi_2
DW sta_1
DW sta_2
DW mag_1
DW mag_2
DW def_1
DW def_2
DW m_def_1
DW m_def_2

; with the addition of the defense and magic defense bonuses, we have to move these descriptions back to make room
; luckily there is a ton of free space here to take advantage of it
HP_10:
DB "HP gained +10%",$00
HP_30:
DB "HP gained +30%",$00
HP_50:
DB "HP gained +50%",$00
HP_double:
DB "HP gained doubled",$00
MP_10:
DB "MP gained +10%",$00
MP_30:
DB "MP gained +30%",$00
MP_50:
DB "MP gained +50%",$00
str_1:
DB "Vigor increases by 1",$00
str_2:
DB "Vigor increases by 2",$00
mag_1:
DB "Magic increases by 1",$00
mag_2:
DB "Magic increases by 2",$00
agi_1:
DB "Speed increases by 1",$00
agi_2:
DB "Speed increases by 2",$00
sta_1:
DB "Stamina increases by 1",$00
sta_2:
DB "Stamina increases by 2",$00
evade_desc:
DB "Evade increases by 1",$00
m_evade_desc:
DB "Magic Evade increases by 1",$00
def_1:
DB "Defense increases by 1",$00
def_2:
DB "Defense increases by 2",$00
m_def_1:
DB "Magic Defense increases by 1",$00
m_def_2:
DB "Magic Defense increases by 2",$00

warnpc $EDFFD0

; --------------------------------------------------
; End of descriptions. Now on to the esper display
; --------------------------------------------------
org $CFFEED
; there's only two short bonus descriptions to change here
; we have 9 letters to work with per description
DB "Evade + 1"
DB "M",$C5,"Ev",$C5," + 1"

org $CFFF47
; now add in the defense and magic defense short bonus descriptors
DB "Def",$C5," + 1 "
DB "Def",$C5," + 2 "
DB "MDef",$C5," + 1"
DB "MDef",$C5," + 2"
; and we're done!

hirom

org $C09F78
; we are going to hijack the "get average level" routine
; to remove *specific* characters from the factoring
; the characters excluded will be a simple bitfield
JSR factor_out

org $C0D630
exclude_finish:
; the state of M, A, X, and Y are actually irrelevant here for a change
LDX $1EDE
RTS

factor_out:
REP #$21
LDA C0_characters_to_exclude  ; load the character bitfield for those we don't want to factor into level averaging
BIT $1EDE  ; have we recruited any of these characters?
BEQ exclude_finish  ; branch if not, this is a simple safety measure to make sure we don't accidently un-factor someone we don't want to.
; in theory, this shouldn't matter, but it never hurts to have checks in
LDA C0_characters_to_exclude  ; load the bit(s) of characters we want excluded
STA $1E
LDA $1EDE  ; load our roster
STA $20
TDC
TAY  ; set Y to 0
INC A  ; set A to 1
STA $1B  ; save it to scatch
character_check_loop:
LDA $1B
BIT $20  ; have we recruited this character?
BEQ character_next_iteration
; now we check to make sure whether or not we should include this character into level averaging
BIT $1E  ; is this character excluded?
BEQ character_next_iteration  ; branch if not
LDA $20  ; load roster
EOR $1E  ; flip off the bit for this character
STA $20  ; and save it to the roster
LDA $1B
character_next_iteration:
ASL $1B  ; move on to the next character to check
INY
CPY #$000E  ; have we done all 14 characters yet?
BNE character_check_loop
LDA $20  ; load our now factored-out roster
TAX
RTS

C0_characters_to_exclude:
DW $0000
; below is the bitfield of characters, it is in binary
; set the bit in the word above to remove that character from being factored into leveling
; 0000 0000 0000 0001 - Terra
; 0000 0000 0000 0010 - Locke
; 0000 0000 0000 0100 - Cyan
; 0000 0000 0000 1000 - Shadow
; 0000 0000 0001 0000 - Edgar
; 0000 0000 0010 0000 - Sabin
; 0000 0000 0100 0000 - Celes
; 0000 0000 1000 0000 - Strago
; 0000 0001 0000 0000 - Relm
; 0000 0010 0000 0000 - Setzer
; 0000 0100 0000 0000 - Mog
; 0000 1000 0000 0000 - Gau
; 0001 0000 0000 0000 - Gogo
; 0010 0000 0000 0000 - Umaro
; the highest bit is used in character data for the Merit award and is ignored here
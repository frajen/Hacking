;|----------------------------------------------|
;| Random Encounter Menu Option (on/off)        |
;| by: madsiur                                  |
;| version: 1.1a                                |
;| Released on: January 30th, 2022              |
;| apply to: FF3us 1.0 (no header)              |
;|----------------------------------------------|

; Apply with main.asm
; Code related to disabling or not ecounters depending on the menu option

;------------------------------------------------
;| SRAM initialization                          |
;------------------------------------------------
org $C0BDF1
JSR init_enc        ; Init encounters memory byte to #$00

;------------------------------------------------
;| World map encounter function                 |
;------------------------------------------------
org $C0C1FE
LDA !SRAM           ; Load encounter byte
BNE lbl_C278        ; Exit if no encounters are off
JSR lbl_D613        ; Otherwise proceed as usual
NOP

org $C0C278
lbl_C278:           ; Function exit is here

;------------------------------------------------
;| Dungeon encounter function                   |
;------------------------------------------------
org $C0C397
LDA !SRAM           ; Load encounter byte
BEQ lbl_C39D        ; Branch if encounters are on
RTS                 ; Otherwise exit
lbl_C39D:
JSR lbl_D613        ; if encounters are on, proceed as usual

;------------------------------------------------
;| Free space                                   |
;------------------------------------------------
org !FreeSpaceC0    ; You can change this free space offset as long as it is in bank $C0
lbl_D613:           ; Original code
LDA $11DF           ; Load party-wide effects
AND #$01            ; Charm Bangle effect (we no longer check for Moogle Charm effect)
ASL A
ASL A               ; Multiply by 4
ORA $1A
RTS

init_enc:           ; From $C0BDF1
STZ !SRAM           ; Init encounters memory byte
STZ $1A69           ; Original code (set esper's collected byte 1 to 0)
RTS
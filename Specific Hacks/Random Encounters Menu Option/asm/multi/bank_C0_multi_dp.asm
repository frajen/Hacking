;|----------------------------------------------|
;| Random Encounter Menu Option (4 options)     |
;| by: madsiur                                  |
;| version: 1.1a                                |
;| Released on: January 30th, 2022              |
;| apply to: FF3us 1.0 (no header)              |
;|----------------------------------------------|

; Apply with main_multi.asm
; Code related to random encounter incrementors depending on the menu option
; Incrementor values taken from FF6: Divergent Paths

;------------------------------------------------
;| SRAM initialization                          |
;------------------------------------------------
org $C0BDF1
JSR init_enc        ; Init encounters memory byte to #$02

;------------------------------------------------
;| World map encounter function                 |
;------------------------------------------------
org $C0C1FE
LDA !SRAM           ; Load encounter byte

;------------------------------------------------
;| Dungeon encounter function                   |
;------------------------------------------------
org $C0C397
LDA !SRAM           ; Load encounter byte

;------------------------------------------------
;| Overworld and dungeon incrementors           |
;------------------------------------------------
org $C0C29F

; Overworld incrementors

; "0%" encounter
dw $0000        ; normal encounters
dw $0000        ; less encounters
dw $0000        ; more encounters
dw $0000        ; no encounter

; "50%" encounters
dw $0048        ; normal encounters
dw $0024        ; less encounters
dw $0090        ; more encounters
dw $0000        ; no encounter

; "100%" encounters
dw $0090        ; normal encounters
dw $0048        ; less encounters
dw $0120        ; more encounters
dw $0000        ; no encounter

; "150%" encounters
dw $00D8        ; normal encounters
dw $006C        ; less encounters
dw $01B0        ; more encounters
dw $0000        ; no encounter

; Dungeon incrementors

; "0%" encounter
dw $0000        ; normal encounters
dw $0000        ; less encounters
dw $0000        ; more encounters
dw $0000        ; no encounter

; "50%" encounters
dw $002A        ; normal encounters
dw $0018        ; less encounters
dw $0084        ; more encounters
dw $0000        ; no encounter

; "100%" encounters
dw $0054        ; normal encounters
dw $0030        ; less encounters
dw $0160        ; more encounters
dw $0000        ; no encounter

; "150%" encounters
dw $007E        ; normal encounters
dw $0048        ; less encounters
dw $018C        ; more encounters
dw $0000        ; no encounter

;------------------------------------------------
;| Free space                                   |
;------------------------------------------------
org !FreeSpaceC0    ; You can change this free space offset as long as it is in bank $C0
init_enc:           ; From $C0BDF1
LDA #$02            ; "100%" encounter rate
STA !SRAM           ; Init encounters memory byte
STZ $1A69           ; Original code (set esper's collected byte 1 to 0)
RTS
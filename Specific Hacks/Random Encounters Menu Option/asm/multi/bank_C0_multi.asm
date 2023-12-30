;|----------------------------------------------|
;| Random Encounter Menu Option (4 options)     |
;| by: madsiur                                  |
;| version: 1.1a                                |
;| Released on: January 30th, 2022              |
;| apply to: FF3us 1.0 (no header)              |
;|----------------------------------------------|

; Apply with main_multi.asm
; Code related to random encounter incrementors depending on the menu option

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
dw $0060        ; normal encounters
dw $0030        ; less encounters
dw $00C0        ; more encounters
dw $0000        ; no encounter

; "100%" encounters
dw $00C0        ; normal encounters
dw $0060        ; less encounters
dw $0180        ; more encounters
dw $0000        ; no encounter

; "150%" encounters
dw $0120        ; normal encounters
dw $0090        ; less encounters
dw $0240        ; more encounters
dw $0000        ; no encounter

; Dungeon incrementors

; "0%" encounter
dw $0000        ; normal encounters
dw $0000        ; less encounters
dw $0000        ; more encounters
dw $0000        ; no encounter

; "50%" encounters
dw $0038        ; normal encounters
dw $0020        ; less encounters
dw $00B0        ; more encounters
dw $0000        ; no encounter

; "100%" encounters
dw $0070        ; normal encounters
dw $0040        ; less encounters
dw $0160        ; more encounters
dw $0000        ; no encounter

; "150%" encounters
dw $00A8        ; normal encounters
dw $0060        ; less encounters
dw $0210        ; more encounters
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
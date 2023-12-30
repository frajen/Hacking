;|----------------------------------------------|
;| Random Encounter Menu Option (on/off)        |
;| by: madsiur                                  |
;| version: 1.1a                                |
;| Released on: January 30th, 2022              |
;| apply to: FF3us 1.0 (no header)              |
;|----------------------------------------------|

; assemble this file with xkas 0.06

hirom
; header

!SRAM = $1E1F   ; Encounters SRAM byte (can be changed to another unused byte)
                ; #$00 = "0%" encounters (off)
                ; #$01 = "100%" encounters (on)

!FreeSpaceC0 = $C0D613  ; Bank $C0 free space offset
                        ; Can be changed, require 17 ($11) contiguous bytes

!FreeSpaceC3 = $C3F091  ; Bank $C3 free space offset
                        ; Can be changed, require 118 ($76) contiguous bytes

incsrc bank_C0.asm
incsrc bank_C3.asm
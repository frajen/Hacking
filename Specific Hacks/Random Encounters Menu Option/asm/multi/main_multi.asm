;|----------------------------------------------|
;| Random Encounter Menu Option (4 options)     |
;| by: madsiur                                  |
;| version: 1.1a                                |
;| Released on: January 30th, 2022              |
;| apply to: FF3us 1.0 (no header)              |
;|----------------------------------------------|

; assemble this file with xkas 0.06

hirom
; header

!SRAM = $1E1F   ; Encounters SRAM byte (can be changed to another unused byte)
                ; #$00 = "0%" encounters
                ; #$01 = "50%" encounters
                ; #$02 = "100%" encounters
                ; #$03 = "150%" encounters

!FreeSpaceC0 = $C0D613  ; Bank $C0 free space offset
                        ; Can be changed, require 9 contiguous bytes

!FreeSpaceC3 = $C3F091  ; Bank $C3 free space offset
                        ; Can be changed, require 186 ($BA) contiguous bytes

incsrc bank_C0_multi.asm

; comment the above line and uncomment this one
; for Divergent Paths incrementor values (75% of vanilla values)
;incsrc bank_C0_multi_dp.asm

incsrc bank_C3_multi.asm
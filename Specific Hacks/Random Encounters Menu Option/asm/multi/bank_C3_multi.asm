;|----------------------------------------------|
;| Random Encounter Menu Option (4 options)     |
;| by: madsiur                                  |
;| version: 1.1a                                |
;| Released on: January 30th, 2022              |
;| apply to: FF3us 1.0 (no header)              |
;|----------------------------------------------|

; Apply with main_multi.asm
; This code deal with the new config menu option

;------------------------------------------------
;| Bank $C3 code                                |
;------------------------------------------------

org $C322D0         ; In $C322C5 function (Sustain Config menu)
CMP #$09            ; Row 9 will now indicate if a down press trigger Config 2 screen

org $C3386B         ; In navigation data table for Config 1
db $0A              ; We now have 10 rows instead of 9

org $C33A40         ; In $C33A21 function (Scroll to Config 1)
LDA #$09            ; New row we are landing on in Config 1 when coming from Config 2

org $C32347         ; In $C32342 function (handle clicks on Config 2)
JMP (ClickTable,X)  ; Use relocated table (to make room for an extra Config 1 click)

org $C3235E         ; In jump table for clicks, after the new spot for "Encounters"
ConfigString:       ; We use this free space for the "Config" string
dw $78F9            ; "Config" position
db $82,$A8,$A7,$9F  ; "Config"
db $A2,$A0,$00

org $C33861         ; In $C3385E function (Handle D-Pad for Config 1)
LDY #CursorTable    ; Use relocated table

org $C3386C         ; In original CursorTable space
ClickTable:         ; We use this free space for the table that handle clicks on Config 2
dw $2341            ; Mag.Order  (NOP)
dw $2341            ; Window     (NOP)
dw $2388            ; Color
dw $2388            ; R
dw $2388            ; G
dw $2388            ; B

HalfEnc:            ; We use this free space for the "50%" string
dw $3E2B            ; "50%" position
db $B9,$B4,$CD,$00  ; "50%"

org $C33D43         ; In original Config1Opt space
EncString:          ; We use this free space for the "Encounters" string
dw $3E0F            ; "Encounters" position
db $84,$A7,$9C      ; "Encounters"
db $A8,$AE,$A7
db $AD,$9E,$AB
db $AC,$00

ZeroEnc:            ; We use this free space for the "0%" string
dw $3E25            ; "0%" position
db $B4,$CD,$00      ; "0%"

org $C349A1         ; In positioned text table for Config page 1
                    ; Use relocated "Config" space to the last text pointer of table above it
dw EncString        ; "Encounters" string pointer

org $C338CD         ; In $C3389E function (Draw Config menu)
LDY #ConfigString   ; Load relocated text pointer

org $C3393B         ; In $C3389E function (Draw Config menu)
JSR DrawNewStrings  ; Draw "Encounters", "0%", "50%", "100%" and "150%"

org $C33D40
JMP (Config1Opt,X)  ; Handle Config 1 options

;------------------------------------------------
;| Bank $C3 free space code                     |
;------------------------------------------------

org !FreeSpaceC3    ; You can change this free space offset as long as it is in bank $C3
CursorTable:        ; Cursor position table for Config 1
dw $2960            ; Bat.Mode
dw $3960            ; Bat.Speed
dw $4960            ; Msg.Speed
dw $5960            ; Cmd.Set
dw $6960            ; Gauge
dw $7960            ; Sound
dw $8960            ; Cursor
dw $9960            ; Reequip
dw $A960            ; Controller
dw $B960            ; Encounters (new entry)

Config1Opt:         ; Jump table for Config 1 options
dw $3D61            ; Bat.Mode
dw $3D7A            ; Bat.Speed
dw $3DAB            ; Msg.Speed
dw $3DE8            ; Cmd.Set
dw $3E01            ; Gauge
dw $3E1A            ; Sound
dw $3E4E            ; Cursor
dw $3E6D            ; Reequip
dw $3E86            ; Controller
dw EncOption        ; Encounters (new entry)

NormEnc:            ; "100%" string
dw $3E33            ; "100%" position
db $B5,$B4,$B4,$CD  ; "100%"
db $00

HighEnc:            ; "150%" string
dw $3E3D            ; "150%" position
db $B5,$B9,$B4,$CD  ; "150%"
db $00

DrawNewStrings:     ; From $C3393B
JSR $41C3           ; Draw RGB info
LDA #$24            ; Palette 1
STA $29             ; Color: Blue
LDY #EncString      ; Text pointer
JSR $02F9           ; Draw "Encounter"
JMP DrawEncOpt      ; Draw "0%", "50%", "100%" and "150%"

EncOption:          ; From jump table Config1Opt, JMP at $C33D40
JSR $0EA3           ; Sound: Cursor
LDA $0B             ; Semi-auto keys
BIT #$01            ; Pushing right?
BNE .right          ; Branch if so
LDA !SRAM           ; Load encounters byte
BEQ .min            ; branch if it is "0%"
DEC A               ; Otherwise decrement
.min
BRA .setSram        ; Branch to save the option
.right              ; We are pressing right here
LDA !SRAM           ; Load encounters byte
CMP #$03            ; Compare to max value ("150%)
BEQ .setSram        ; Branch if already max
INC A               ; Otherwise increment
.setSram
STA !SRAM           ; Save option
JMP DrawEncOpt      ; Draw "0%", "50%", "100%" and "150%" when changing option

DrawEncOpt:         ; From tag DrawNewStrings, EncOption
                    ; We draw all four options in grey first then draw the current one in white
LDA #$28            ; Color: Gray
JSR DrawZero        ; Draw "0%"
LDA #$28            ; Color: Gray
JSR DrawHalf        ; Draw "50%"
LDA #$28            ; Color: Gray
JSR DrawNorm        ; Draw "100%"
LDA #$28            ; Color: Gray
JSR DrawHigh        ; Draw "150%"
LDA !SRAM           ; Load current encounters value
BEQ .isZero         ; Branch if "0%"
CMP #$01
BEQ .isHalf         ; Branc if "50%"
CMP #$02
BEQ .isNorm         ; Branch if "100%"
LDA #$20            ; Color: User's
BRA DrawHigh        ; Draw "150%"
.isZero
LDA #$20            ; Color: User's
BRA DrawZero        ; Draw "0%"
.isHalf
LDA #$20            ; Color: User's
BRA DrawHalf        ; Draw "50%"
.isNorm
LDA #$20            ; Color: User's
BRA DrawNorm        ; Draw "100%"

DrawZero:           ; From tag EncOnMode
STA $29             ; Set palette
LDY #ZeroEnc        ; Text pointer
JSR $02F9           ; Draw "0%"
RTS

DrawHalf:           ; From tag DrawEncOpt
STA $29             ; Set palette
LDY #HalfEnc        ; Text pointer
JSR $02F9           ; Draw "50%"
RTS

DrawNorm:           ; From tag EncOnMode
STA $29             ; Set palette
LDY #NormEnc        ; Text pointer
JSR $02F9           ; Draw "100%"
RTS

DrawHigh:           ; From tag EncOnMode
STA $29             ; Set palette
LDY #HighEnc        ; Text pointer
JSR $02F9           ; Draw "150%"
RTS
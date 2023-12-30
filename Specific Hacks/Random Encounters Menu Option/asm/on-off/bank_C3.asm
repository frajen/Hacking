;|----------------------------------------------|
;| Random Encounter Menu Option (on/off)        |
;| by: madsiur                                  |
;| version: 1.1a                                |
;| Released on: January 30th, 2022              |
;| apply to: FF3us 1.0 (no header)              |
;|----------------------------------------------|

; Apply with main.asm
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

OffString:
dw $3E35            ; "Off" position
db $8E,$9F,$9F,$00  ; "Off"

org $C33D43         ; In original Config1Opt space
EncString:          ; We use this free space for the "Encounters" string
dw $3E0F            ; "Encounters" position
db $84,$A7,$9C      ; "Encounters"
db $A8,$AE,$A7
db $AD,$9E,$AB
db $AC,$00

OnString:
dw $3E25            ; "On" position
db $8E,$A7,$00      ; "On"

org $C349A1         ; In positioned text table for Config page 1
                    ; Use relocated "Config" space to put two new text pointers
dw EncString        ; "Encounters" text pointer

org $C338CD         ; In $C3389E function (Draw Config menu)
LDY #ConfigString   ; Load relocated text pointer

org $C3393B         ; In $C3389E function (Draw Config menu)
JSR DrawNewStrings  ; Draw "Config", "Encounters", "On", "Off"

org $C33D40
JMP (Config1Opt,X)  ; Handle Config 1 options

;------------------------------------------------
;| Bank $C3 free space code                     |
;------------------------------------------------
org !FreeSpaceC3     ; You can change this free space offset as long as it is in bank $C3
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

DrawNewStrings:     ; From $C3393B
JSR $41C3           ; Draw RGB info
LDA #$24            ; Palette 1
STA $29             ; Color: Blue
LDY #EncString      ; Text pointer
JSR $02F9           ; Draw "Encounter"
JMP DrawEncOpt      ; Draw "On", "Off"

EncOption:          ; From jump table Config1Opt, JMP at $C33D40
JSR $0EA3           ; Sound: Cursor
LDA $0B             ; Semi-auto keys
BIT #$01            ; Pushing right?
BNE .sub_loop       ; Branch if so
LDA #$00            ; Encounters: On
BRA .setSram        ; Branch to save the option
.sub_loop
LDA #$01            ; Encounters: Off
.setSram
STA !SRAM           ; Save option
JMP DrawEncOpt      ; Draw "On", "Off" when changing option

DrawEncOpt:         ; From tag DrawNewStrings, EncOption
LDA !SRAM           ; Load current encounters value
BEQ EncOnMode       ; Branch if encounters are on
LDA #$28            ; Color: Gray
JSR DrawOn          ; Draw "On"
LDA #$20            ; Color: User's
BRA DrawOff         ; Draw "Off"

EncOnMode:          ; From tag DrawEncOpt
LDA #$20            ; Color: User's
JSR DrawOn          ; Draw "On"
LDA #$28            ; Color: Gray
BRA DrawOff         ; Draw "Off"

DrawOn:             ; From tag EncOnMode
STA $29             ; Set palette
LDY #OnString       ; Text pointer
JSR $02F9           ; Draw "On"
RTS

DrawOff:            ; From tag DrawEncOpt, EncOnMode
STA $29             ; Set palette
LDY #OffString      ; Text pointer
JSR $02F9           ; Draw "Off"
RTS
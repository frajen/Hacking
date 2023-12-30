hirom
table vwf.tbl,rtl

; C3 Bank



; ------------------------------------------------------------------------
; dn's "Shop Hack" patch changes where to write elemental effects
org $C388CE : LDX #$7B65 ; where to write resisted elements
org $C388DA : LDX #$7BE5 ; where to write absorbed elements
org $C388E6 : LDX #$7C65 ; where to write immune elements
org $C388F2 : LDX #$7CE5 ; where to write weak elements


; #########################################################################
; Menu Label Changes (part 1.5)

; -------------------------------------------------------------------------
; dn's "Shop Hack" patch: Text pointers for gear data menu (point to new text)

org $C38D69
  dw EleResist
  dw EleAbsorb
  dw EleImmune
  dw EleWeak

; -------------------------------------------------------------------------
; Percent symbols (%) overwritten with spaces by dn's "No Percents" patch

org $C38D9B : db $FF ; replace '%' with ' '
org $C38DA5 : db $FF ; replace '%' with ' '
org $C38E26 : dw $822F : db "Bushido",$00 ; rename "SwdTech" gear attribute





; #########################################################################
; Sustain Main Shop Menu

; Modifies "buy item" list handling to update full details ("Shop Hack")
org $C3B4BD
  JSR BuyItemDetails
  RTS
DrawItemNameNMI:
  JSR $1368        ; refresh screen (NMI)
  JSR $7FD9        ; draw item name
  RTS
padbyte $FF : pad $C3B4E6


; #########################################################################
; Initialize Main Shop Menu
;
; "Shop Hack" - Insert hooks to draw gear details windows and labels and
; handle hiding the details until required.

org $C3B8C4
  JSR ShopClearBG  ; clear BG maps and draw detail windows
  NOP #6

org $C3B95A
; TODO Don't know why this is rewritten to free up 6 (unused) bytes
  JSR ClearBG3     ; clear background 3 maps
  JSR $BFD3        ; Draw title
  LDY #$C338       ; Text pointer
  JSR $02F9        ; Draw "GP"
  JSR $C2F2        ; Color: User's
  LDY $1860        ; Gold LBs
  STY $F1          ; Memorize it
  LDA $1862        ; Gold HB
  STA $F3          ; Memorize it
  JSR $0582        ; Turn into text
  LDX #$7A33       ; Text position
  JSR $04AC        ; Draw GP total
  RTS
warnpc $C3B986+1

org $C3B989 : LDY #HelpText
org $C3BABA : NOP #3 ; skip drawing "Power" info on buy order menu
org $C3BAC9 : JSR DrawItemNameNMI ; refresh screen before name draw
org $C3C037 : db $2F,$06,$00      ; change text shifting for shop "Shop Hack"

; #########################################################################
; Shop Menu equippability UI

org $C3C29C : BRA $3F ; Never show equipped/up/down/equal icons

; #########################################################################
; Draw "Owned" and "Equipped" window
;
; dn's "Shop Hack" interrupts drawing "Owned and "Equipped" window

org $C3C2E1 : JSR DrawDetailsLabels

; #########################################################################
; Positioned Text for Shop Menu

org $C3C357 : dw $7B8F : db "Attack",$00



org $C3F850
OffensiveHelp:
  JSR $87EB      ; [displaced] draw evasions
  JSR $C2F7      ; [optimized] set blue palette
  LDY #$8E1D     ; [displaced] text pointer
  JSR $02F9      ; [displaced] draw "Attack"
  JMP $88A0      ; [displaced] draw elements

UpdateTxtColor:
  BEQ .gray      ; branch to gray if property missing
  LDA #$20       ; "user's color" palette (white)
  BRA .done      ; set ^
.gray
  LDA #$24       ; grey text
.done
  STA $29        ; set palette ID
  RTS

ItemProperties:
  LDX $2134        ; item index
  LDA $D85013,x    ; byte to look at
  RTS

DrawTextData:
  STY $E7
  JSR $8795
  RTS

ShopClearBG:
  JSR $6A28        ; clear bg2 map a
  JSR $6A2D        ; clear bg2 map b
  JSR $6A32        ; clear bg2 map c
  JSR $6A37        ; clear bg2 map d
  LDY #GearWindow  ; offset to main gear window specs
  JSR $0341        ; draw window ^
  LDY #GearActors  ; offset to actor window specs
  JSR $0341        ; draw window ^
  LDY #GearNameBox ; offset to name window specs
  JSR $0341        ; draw window ^
  LDY #GearDesc    ; offset to desc window specs
  JSR $0341        ; draw window ^
ClearBG3:
  JSR $6A3C        ; clear bg3 map a
  JSR $6A41        ; clear bg3 map b
  JSR $6A46        ; clear bg3 map c
  JSR $6A4B        ; clear bg3 map d
  RTS

draw_title_dupe:
  JSR $02FF        ; draw title

BuyItemDetails:
  LDA #$10         ; reset/stop desc
  TSB $45          ; set menu flags
  JSR $0F39        ; queue text upload
  JSR $1368
  JSR $0F4D        ; queue text upload 2
  JSR $B8A6        ; handle d-pad
  JSR check_stats
  JSR $BC84        ; draw quantity owned
  JSR $BCA8        ; draw quantity worn
;Handle hold Y
shop_handle_y:
  LDA $0D
  BIT #$40         ; holding Y?
  BEQ .handle_b    ; branch if not
  REP #$20         ; 16-bit A
  LDA #$0100       ; BG2 scroll position
  STA $3B          ; BG2 Y position
  STA $3D          ; BG3 X position
  SEP #$20         ; 8-bit A
  LDA #$04         ; bit 2
  TRB $45          ; set bit in menu flags A
  JSR gear_desc
  RTS
;Fork: Handle B
.handle_b
  STZ $3C
  STZ $3E
  LDA #$04
  TSB $45
  LDA $09          ; No-autofire keys
  BIT #$80         ; Pushing B?
  BEQ .handle_a    ; Branch if not
  JSR $0EA9        ; Sound: Cursor
  JMP $B760        ; Exit submenu
;Fork: Handle A
.handle_a
  LDA $08          ; no-autofire keys
  BIT #$80         ; pushing (A)
  BEQ .exit        ; exit if not ^
  JSR $B82F        ; set buy limit
  JSR $B7E6        ; test GP, stock
.exit
  RTS

DrawDetailsLabels:
  JSR $1368        ; trigger NMI
  JSR $C2F7        ; [displaced] color: blue
  LDY #VigorText   ; text: vigor
  JSR $02F9        ; draw text
  LDY #SpeedText   ; text: speed
  JSR $02F9        ; draw text
  LDY #StaminaText ; text: stamina
  JSR $02F9        ; draw text
  LDY #MagicText   ; text: magic
  JSR $02F9        ; draw text
  LDY #DefText     ; text: defense
  JSR $02F9        ; draw text
  LDY #MDefText    ; text: magic defense
  JSR $02F9        ; draw text
  LDY #EvadeText   ; text: evasion
  JSR $02F9        ; draw text
  LDY #MEvadeText  ; text: magic evasion
  JSR $02F9        ; draw text
  LDY #PowerText   ; text: bat.pow.
  JSR $02F9        ; draw text
  JSR $BFC2        ; get item ID in A [TODO why]
  RTS

check_stats:
  PHA               ; store A
  PHX               ; store X
  PHY               ; store Y
  PHP               ; store flags
  JSR $C2F2         ; set palette to white
  JSR $BFC2         ; get item
  JSR $8321         ; Compute index
  LDX $2134         ; Load it
  TDC               ; Terminator
  STA $7E9E8D       ; Set mod B3
  STA $7E9E8E       ; Set mod B4
  REP #$20          ; 16-bit A
  LDA #$8223        ; Tilemap ptr
  STA $7E9E89       ; Set position
  SEP #$20          ; 8-bit A
  TDC               ; Clear A
  LDA $D85010,X     ; Stat mods LB
  PHA               ; Memorize them
  AND #$0F          ; Vigor index
  ASL A             ; Double it
  JSR $8836         ; Draw modifier
  REP #$20          ; 16-bit A
  LDA #$8323        ; Tilemap ptr
  STA $7E9E89       ; Set position
  SEP #$20          ; 8-bit A
  TDC               ; Clear A
  PLA               ; Stat mods LB
  AND #$F0          ; Speed index
  LSR A             ; Put in b3-b6
  LSR A             ; Put in b2-b5
  LSR A             ; Put in b1-b4
  JSR $8836         ; Draw modifier
  REP #$20          ; 16-bit A
  LDA #$83A3        ; Tilemap ptr
  STA $7E9E89       ; Set position
  SEP #$20          ; 8-bit A
  LDX $2134         ; Item index
  TDC               ; Clear A
  LDA $D85011,X     ; Stats mods HB
  PHA               ; Memorize them
  AND #$0F          ; Stamina index
  ASL A             ; Double it
  JSR $8836         ; Draw modifier
  REP #$20          ; 16-bit A
  LDA #$82A3        ; Tilemap ptr
  STA $7E9E89       ; Set position
  SEP #$20          ; 8-bit A
  TDC               ; Clear A
  PLA               ; Stat mods HB
  AND #$F0          ; Mag.Pwr index
  LSR A             ; Put in b3-b6
  LSR A             ; Put in b2-b5
  LSR A             ; Put in b1-b4
  JSR $8836         ; Draw modifier

;draw defensive properties
  LDX $2134         ; Item index
  LDA $D85000,X     ; Properties
  AND #$07          ; Get class
  BEQ not_weapon    ; branch if tool
  CMP #$01          ; Weapon?
  BEQ is_weapon     ; Branch if so
  CMP #$06          ; item?
  BEQ not_weapon    ; branch if so
  LDA $D85014,X     ; Defense
  JSR $04E0         ; Turn into text
  LDX #$823F        ; Text position
  JSR $04C0         ; Draw 3 digits
  LDX $2134         ; Item index
  LDA $D85015,X     ; Mag.Def
  JSR $04E0         ; Turn into text
  LDX #$833F        ; Text position
  JSR $04C0         ; Draw 3 digits
  LDY #PowerDash
  JSR $02f9
is_weapon:
  TDC
  LDX $2134        ; item index
  LDA $D85000,x    ; properties
  AND #$07
  CMP #$01
  BNE not_weapon
  LDA #$20       ; Palette 0
  STA $29        ; Color: User's
  CMP #$51       ; Dice?
  BEQ hide_bpow      ; Hide if so
  LDX $2134
  LDA $D85014,X  ; Bat.Pwr
  JSR $04E0      ; Turn into text
  LDX #$813F        ; Text position
  JSR $04C0      ; Draw 3 digits
  LDY #DefDash
  JSR $02F9
  LDY #MDefDash
  JSR $02F9
  BRA not_weapon

hide_bpow:
  LDY #UnknownTxt     ; Text pointer
  JSR $02F9      ; Draw "???"

not_weapon:
  JSR all_dashes
  REP #$20       ; 16-bit A
  LDA #$82BF     ; Tilemap ptr
  STA $7E9E89    ; Set position
  SEP #$20       ; 8-bit A
  LDX $2134      ; Item index
  TDC            ; Clear A
  LDA $D8501A,X  ; Evasion mods
  PHA            ; Memorize them
  AND #$0F       ; Evade index
  ASL A          ; x2
  ASL A          ; x4
  JSR $881A      ; Draw modifier
  REP #$20       ; 16-bit A
  LDA #$83BF     ; Tilemap ptr
  STA $7E9E89    ; Set position
  SEP #$20       ; 8-bit A
  LDX $2134      ; Item index
  TDC            ; Clear A
  PLA            ; Evasion mods
  AND #$F0       ; MBlock index
  LSR A          ;
  LSR A          ;
  TAX            ; Index it
  LDA $C38854,X  ; Sign
  STA $7E9E8B    ; Add to string
  LDA $C38855,X  ; Tens digit
  STA $7E9E8C    ; Add to string
  LDA $C38856,X  ; Ones digit
  STA $7E9E8D    ; Add to string
  JSR $8847      ; Draw modifier

; name and cleanup
  REP #$20
  LDA #$810D        ; tilemap ptr
  STA $7E9E89
  SEP #$20        
  JSR $BFC2        ; get item
  JSR $C068        ; load item name
  JSR $7FD9
  PLP
  PLY
  PLX
  PLA
  JSR $BC92
  RTS

all_dashes:
  LDX $2134
  LDA $D85000,x
  AND #$07
  CMP #$06
  BNE skip_all_dashes
  LDY #PowerDash
  JSR $02F9
  LDY #DefDash
  JSR $02F9
  LDY #MDefDash
  JSR $02F9
skip_all_dashes:
  RTS
gear_desc:
  LDA $02
  CMP $4B
  BNE gear_desc_end
  JSR gear_desc2    ; build description tilemap for shop menu
  JSR $B4E6        ; set description flags
  JSR $B4EF        ; load item description for buy menu
gear_desc_end:
  LDA $4B
  STA $02
  RTS

gear_desc2:
  LDX #$7849     ; Base: 7E/7849
  STX $EB        ; Set map ptr LBs
  LDA #$7E       ; Bank: 7E
  STA $ED        ; Set ptr HB
  LDY #$0CBC     ; Ends at 30,19
  STY $E7        ; Set row's limit
  LDY #$0C84     ; Starts at 3,19
  LDX #$3500     ; Tile 256, pal 5
  STX $E0        ; Priority enabled
  JSR $A783      ; Do line 1, row 1
  LDY #$0CFC     ; Ends at 30,20
  STY $E7        ; Set row's limit
  LDY #$0CC4     ; Starts at 3,20
  LDX #$3501     ; Tile 257, pal 5
  STX $E0        ; Priority enabled
  JSR $A783      ; Do line 1, row 2
  LDY #$0D3C     ; Ends at 30,21
  STY $E7        ; Set row's limit
  LDY #$0D04     ; Starts at 3,21
  LDX #$3538     ; Tile 312, pal 5
  STX $E0        ; Priority enabled
  JSR $A783      ; Do line 2, row 1
  LDY #$0D7C     ; Ends at 30,22
  STY $E7        ; Set row's limit
  LDY #$0D44     ; Starts at 3,22
  LDX #$3539     ; Tile 313, pal 5
  STX $E0        ; Priority enabled
  JMP $A783      ; Do line 2, row 2

HelpText:
  dw $791F : db "Hold",$FE,"Y",$FE,"for",$FE,"details.",$00 ; TODO: Why FE?
VigorText:
  dw $820D : db "Vigor",$00
SpeedText:
  dw $830D : db "Speed",$00
StaminaText:
  dw $838D : db "Stamina",$00
MagicText:
  dw $828D : db "Magic",$00
DefText:
  dw $822B : db "Defense",$00
MDefText:
  dw $832B : db "M.Def.",$00
EvadeText:
  dw $82AB : db "Evade",$00
MEvadeText:
  dw $83AB : db "M.Evade",$00
PowerText:
  dw $812B : db "Attack",$00,$00 ; TODO Remove extra $00 here
UnknownTxt:
  dw $813F : db "???",$00
PowerDash:
  dw $813F : db "---",$00
DefDash:
  dw $823F : db "---",$00
MDefDash:
  dw $833F : db "---",$00
EleResist:
  dw $7B8D : db "Resist:",$00
EleAbsorb:
  dw $7C0D : db "Absorb:",$00
EleImmune:
  dw $7C8D : db "Nullify:",$00
EleWeak:
  dw $7D0D : db "Weakness:",$00

; Window layout data
GearWindow:  : dw $718B : db $1C,$06
GearActors:  : dw $750B : db $1C,$06
GearNameBox: : dw $708B : db $1C,$02
GearDesc:    : dw $738B : db $1C,$04

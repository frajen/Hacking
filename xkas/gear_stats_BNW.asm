hirom
table ff6_snes_menu_a.tbl,rtl

org $c388ce  ; where to write resisted elements
ldx #$7B5d
org $c388da  ; where to write absorbed elements
ldx #$7bdd
org $c388e6  ; where to write immune elements
ldx #$7C5d
org $c388f2  ; where to write weak elements
ldx #$7cdd

org $c3baba
nop #3

org $c38746
;Fork: Draw offensive properties
C38746:	JSR $879C      ; Draw Bat.Pwr
		jsr gear_stats_evasion_attack_elements
		jsr load_item_index
		and #$80
		jsr check_text_color
		ldy #$8e30
		jsr process_text
		jsr load_item_index
		and #$40
		jsr check_text_color
		ldy #$8e38
		jsr process_text
		jsr load_item_index
		and #$02
		jsr check_text_color
		ldy #$8e26
		jsr process_text
		rts
padbyte $FF : pad $C38795
		
org $c3b4bd
		jsr handle_shop_stats
		rts
check_nmi:
		jsr $1368		; NMI
		jsr $7fd9		; draw name (from BAC9)
		rts
padbyte $FF : pad $c3b4e6

org $c3b8c4
		jsr clear_screen_bg2
		nop #6
		
org $C3B95a
		jsr clear_screen_bg3
C3B963:	JSR $BFD3      ; Draw title
C3B969:	LDY #$C338     ; Text pointer
C3B96C:	JSR $02F9      ; Draw "GP"
C3B96F:	JSR $C2F2      ; Color: User's
C3B972:	LDY $1860      ; Gold LBs
C3B975:	STY $F1        ; Memorize it
C3B977:	LDA $1862      ; Gold HB
C3B97A:	STA $F3        ; Memorize it
C3B97C:	JSR $0582      ; Turn into text
C3B97F:	LDX #$7A33     ; Text position
C3B982:	JSR $04AC      ; Draw GP total
C3B985:	RTS

org $c3b989
		ldy #HelpText
org $C3BABA : NOP #3 ; skip drawing "Power" info on buy order menu
		
org $c3bac9
		jsr check_nmi
		
org $c3bfd3
;draw shop title, define shop index
C3BFD3:	JSR $C2F7      ; Color: Blue
C3BFD6:	LDA $4212      ; PPU status
C3BFD9:	AND #$40       ; H-Blank?
C3BFDB:	BEQ C3BFD6      ; Loop if not
C3BFDD:	LDA $0201      ; Shop number
C3BFE0:	STA $211B      ; Set matrix A LB
C3BFE3:	STZ $211B      ; Clear HB
C3BFE6:	LDA #$09       ; Shop data size
C3BFE8:	STA $211C      ; Set matrix B
C3BFEB:	STA $211C      ; ...
C3BFEE:	LDX $2134      ; Index product
C3BFF1:	STX $67        ; Set shop index
C3BFF3:	LDA $C47AC0,X  ; Shop flags
C3BFF7:	AND #$07       ; Title number
C3BFF9:	ASL A          ; Double it
C3BFFA:	TAX            ; Index it
C3BFFB:	REP #$20       ; 16-bit A
C3BFFD:	LDA $C3C00C,X  ; Text pointer
C3C001:	STA $E7        ; Set src LBs
C3C003:	SEP #$20       ; 8-bit A
C3C005:	LDA #$C3       ; Bank: C3
C3C007:	STA $E9        ; Set src HB
C3C009:	JMP $02FF      ; Draw title

org $c3c037
		db $2f,06,00
org $c3c2e1
		jsr DrawDetailsLabels
;;;;;; testing
;org $c3f850  ;for WC start at c3fc8c as per free space analysis
org $c3fc8c
gear_stats_evasion_attack_elements:
  JSR $87EB      ; [displaced] draw evasions
  JSR $C2F7      ; [optimized] set blue palette
  LDY #$8E1D     ; [displaced] text pointer
  JSR $02F9      ; [displaced] draw "Attack"
  JMP $88A0      ; [displaced] draw elements
		
check_text_color:
		beq grey_text_color
user_text_color:
		lda #$20		; palette 0
		bra store_tcolor
grey_text_color:
		lda #$24		; grey text
store_tcolor:
		sta $29			; color: user's
		rts
		
load_item_index:
		ldx $2134		; item index
		lda $d85013,x	; byte to look at
		rts
		
process_text:
		sty $e7
		jsr $8795
		rts
		
clear_screen_bg2:
		jsr $6a28		; clear bg2 map a
		jsr $6a2d		; clear bg2 map b
		jsr $6a32		; clear bg2 map c
		jsr $6a37		; clear bg2 map d
		ldy #GearWindow
		jsr $0341		; draw shop gear window
		ldy #GearActors
		jsr $0341		; draw actors' window
		ldy #GearNameBox
		jsr $0341
		ldy #GearDesc
		jsr $0341
clear_screen_bg3:
		jsr $6a3c		; clear bg3 map a
		jsr $6a41		; clear bg3 map b
		jsr $6a46		; clear bg3 map c
		jsr $6a4b		; clear bg3 map d
		rts
		
draw_title_dupe:
		
		jsr $02ff		; draw title
handle_shop_stats:
handle_buy_item_list:
		lda #$10		; reset/stop desc
		tsb $45			; set menu flags
		jsr $0f39		; queue text upload
		jsr $1368
		jsr $0f4d		; queue text upload 2
		jsr $b8a6		; handle d-pad
		jsr check_stats
		jsr $bc84		; draw quantity owned
		jsr $bca8		; draw quantity worn
;Handle hold Y
shop_handle_y:
		lda $0D
		bit #$40		; holding Y?
		beq shop_handle_b ; branch if not
		rep #$20		; 16-bit A
		lda #$0100		; BG2 scroll position
		sta $3b			; BG2 Y position
		sta $3d			; BG3 X position
		sep #$20		; 8-bit A
		lda #$04		; bit 2
		trb $45			; set bit in menu flags A
		jsr gear_desc
		rts
;Fork: Handle B
shop_handle_b:
		stz $3c
		stz $3e
		lda #$04
		tsb $45
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
; 1f 79
; 87 a8 a5 9d fe, 98 fe, 9f a8 ab fe, 9d 9e ad 9a a2 a5 ac c5 00
VigorText:
  dw $820D : db "Vigor",$00
; 0d 82
; 95 a2 a0 a8 ab 00
SpeedText:
  dw $830D : db "Speed",$00
; 0d 83
; 92 a9 9e 9e 9d 00
StaminaText:
  dw $838D : db "Stamina",$00
; 8d 83
; 92 ad 9a a6 a2 a7 9a 00
MagicText:
  dw $828D : db "Magic",$00
; 8d 82
; 8c 9a a0 a2 9c 00
DefText:
  dw $822B : db "Defense",$00
; 2b 82
; 83 9e 9f 9e a7 ac 9e 00
MDefText:
  dw $832B : db "M.Def.",$00
; 2b 83
; 8c c5 83 9e 9f c5 00
EvadeText:
  dw $82AB : db "Evade",$00
; ab 82
; 84 af 9a 9d 9e 00
MEvadeText:
  dw $83AB : db "M.Evade",$00
; ab 83
; 8c c5 84 af 9a 9d 9e 00
PowerText:
  dw $812B : db "Attack",$00,$00 ; TODO Remove extra $00 here
; 2b 81
; 80 ad ad 9a 9c a4 00 00
UnknownTxt:
  dw $813F : db "???",$00
; 3f 81
; bf bf bf 00
PowerDash:
  dw $813F : db "---",$00
; 3f 81
; c4 c4 c4 00
DefDash:
  dw $823F : db "---",$00
; 3f 82
; c4 c4 c4 00
MDefDash:
  dw $833F : db "---",$00
; 3f 83
; c4 c4 c4 00
EleResist:
  dw $7B8D : db "Resist:",$00
; 8d 7b
; 91 9e ac a2 ac ad c1 00
EleAbsorb:
  dw $7C0D : db "Absorb:",$00
; 0d 7c
; 80 9b ac a8 ab 9b c1 00
EleImmune:
  dw $7C8D : db "Nullify:",$00
; 8d 7c
; 8d ae a5 a5 a2 9f b2 c1 00
EleWeak:
  dw $7D0D : db "Weakness:",$00
; 0d 7d 
; 96 9e 9a a4 a7 9e ac ac c1 00

; Window layout data
GearWindow:  : dw $718B : db $1C,$06
; 8b 71 1c 06
GearActors:  : dw $750B : db $1C,$06
; 0b 75 1c 06
GearNameBox: : dw $708B : db $1C,$02
; 8b 70 1c 02
GearDesc:    : dw $738B : db $1C,$04
; 8b 73 1c 04

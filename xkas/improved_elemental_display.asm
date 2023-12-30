hirom

; we are going to make a few hooks to finish adding in the Elemental Display QoL hack

; these are all the necessary hooks, because we are going to optimize some code further down. this way no free space is taken up
; also the code executes a bit faster and just looks better overall
org $C386BC
JSR C38836

org $C386D1
JSR C38836

org $C386EB
JSR C38836

org $C38700
JSR C38836

org $C38730
JSR C388A0
JSR C38959

org $C38756
JSR C388A0

org $C3881B
LDA evade_bonus,X
STA $7E9E8B
LDA evade_bonus+1,X
STA $7E9E8C
LDA evade_bonus+2,X
STA $7E9E8D
JMP $7FD9

C38836:
TAX
LDA stat_boost,X
STA $7E9E8B
LDA stat_boost+1,X
STA $7E9E8C
LDY #$9E89
JMP $7FD9  ; utilize what the game has

C388AE:	LDY #$AA8D
C388B1:	STY $2181
C388B4:	STZ $E0
C388B6:	LDY #$0008
C388B9:	ROL A
C388BA:	BCC C388C3
C388BC:	PHA 
C388BD:	LDA $E0
C388BF:	STA $2180
C388C2:	PLA 
C388C3:	INC $E0
C388C5:	DEY 
C388C6:	BNE C388B9
C388C8:	LDA #$FF
C388CA:	STA $2180
C388CD:	RTS

C388A0:
LDX $2134
TDC
LDA $D8500F,X  ; weapon elemental properties
JSR C388AE
BRA C388D3

C388E8:
LDX $2134
TDC
LDA $D8500F,X  ; weapon elemental properties
JSR C388AE
C388CE:	LDX #$7B5D
BRA C388E0

C388D3:	LDX #$7BDD
C388D6:	BRA C388E0

C388D8:	LDX #$7C5D
BRA C388E0

C38959:	LDX $2134
TDC
LDA $D85016,X  ; load armor's absorbing elements
JSR C388AE  ; get all elements absorbed
JSR C388CE
LDX $2134
TDC
LDA $D85017,X  ; load armor's nullifying elements
JSR C388AE
JSR C388D8
LDX #$7CDD
C388E0:	STX $EB
C388E2:	LDA #$7E
C388E4:	STA $ED

C388FE:	TDC
C388FF:	TAX
C38900:	; TDC
C38901:	LDA $7EAA8D,X
C38905:	BMI C38926  ; branch if no elements to display
C38907:	PHX
C38908:	REP #$20
C3890A:	ASL A
C3890B:	TAX
C3890C:	LDA C38927,X
C38910:	STA $E0
C38912:	; JSR C38937  ; output element icons to tilemap
C38937:	TDC
C38938:	TAY
C38939:	LDA $E0  ; load icon
C3893B:	STA [$EB],Y
C3893D:	INC $E0
C3893F:	LDY #$0040
C38942:	LDA $E0
C38944:	STA [$EB],Y
C38946:	INC $E0
C38948:	LDY #$0002
C3894B:	LDA $E0
C3894D:	STA [$EB],Y
C3894F:	INC $E0
C38951:	LDY #$0042
C38954:	LDA $E0
C38956:	STA [$EB],Y
C38915:	LDA $EB
C38917:	CLC
C38918:	ADC #$0004  ; add 2 spaces
C3891B:	STA $EB
C3891D:	SEP #$20
C3891F:	PLX
	TDC  ; clean upper A
C38920:	INX
C38921:	CPX #$0008  ; have we checked all 8 elements?
C38924:	BNE C38900  ; branch if not
C38926:	RTS

evade_bonus:
DB "+10",$00
DB "+20",$00
DB "+30",$00
DB "+40",$00
DB "+50",$00
DB "-10",$00
DB "-20",$00
DB "-30",$00
DB "-40",$00
DB "-50",$00
stat_boost:
C38880:	DB " 0"
C38882:	DB "+1"
C38884:	DB "+2"
C38886:	DB "+3"
C38888:	DB "+4"
C3888A:	DB "+5"
C3888C:	DB "+6"
C3888E:	DB "+7"
C38890:	DB " 0"
C38892:	DB "-1"
C38894:	DB "-2"
C38896:	DB "-3"
C38898:	DB "-4"
C3889A:	DB "-5"
C3889C:	DB "-6"
C3889E:	DB "-7"

; VWF icons for elemental display properties
C38927:	DW $3580
C38929:	DW $3584
C3892B:	DW $3588
C3892D:	DW $358C
C3892F:	DW $3590
C38931:	DW $3594
C38933:	DW $3598
C38935:	DW $359C

padbyte $FF : pad $C38983

; now change the 3 text pointers further down in bank C3 to
; 1) be clearer about what they do
; 2) also change their tilemap position
org $C38D6B
DW C3Absorb
DW C3Nullify
DW C3Weak

org $C38DF1
C3Resist: DW $7C0D : DB "Resist",$00
C3Absorb: DW $7B8D : DB "Absorb",$00
C3Nullify: DW $7C8D : DB "Nullify",$00
C3Weak: DW $7D0D : DB "Weak",$00
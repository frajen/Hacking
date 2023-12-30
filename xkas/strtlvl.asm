hirom

org $C0A10B
; we are hijacking a JSR to "get the level average of the party"
; simply because we are going to manually set the level of this character
; but then there's the level factoring code as well
; it no longer serves a purpose, so let's get rid of it
LDA $EC  ; get our character from our event argument
STA $1600,Y  ; save it as ID
TAX
LDA C0get_level,X
BNE level_not_zero
LDA #$01  ; enfore a minimum level of 1
level_not_zero:
CMP #$63  ; 99 or higher?
BCC level_not_99
LDA #$63
level_not_99:
STA $1608,Y
JSR $A27E  ; get max HP
REP #$20
LDA $160B,Y  ; max HP
STA $1609,Y  ; save as current
SEP #$20
TDC
JSR $A2BC  ; get max MP
REP #$20
LDA $160F,Y  ; max MP
STA $160D,Y  ; save as current
SEP #$20
TDC
JSR $A235  ; determine experience needed for next level
TYX
JSR $9DF0
LDA $087C,Y
AND #$F0
ORA #$01
STA $087C,Y
LDA $0868,Y
ORA #$01
STA $0868,Y
TDC
STA $0867,Y
TXY
JSR $A17F  ; natural magic and abilities
LDA #$03
JMP $9B5C  ; advance event queue 3 bytes

C0get_level:
DB $19  ; Terra
DB $19  ; Locke
DB $19  ; Cyan
DB $19  ; Shadow
DB $19  ; Edgar
DB $19  ; Sabin
DB $19  ; Celes
DB $19  ; Strago
DB $19  ; Relm
DB $19  ; Setzer
DB $19  ; Mog
DB $19  ; Gau
DB $19  ; Gogo
DB $19  ; Umaro

padbyte $EA : pad $C0A17F
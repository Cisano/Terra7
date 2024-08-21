;Copyright 2024 Cisano Carmelo
;
;This file is part of Terra7
;
;    Terra7 is free software: you can redistribute it and/or modify
;    it under the terms of the GNU General Public License as published by
;    the Free Software Foundation, either version 3 of the License, or
;    (at your option) any later version.
;
;    Terra7  is distributed in the hope that it will be useful,
;    but WITHOUT ANY WARRANTY; without even the implied warranty of
;    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
;    GNU General Public License for more details.
;
;    You should have received a copy of the GNU General Public License
;    along with Terra7. If not, see <http://www.gnu.org/licenses/>.


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;        
;MACRO init vars begin game
    MAC SET_ALL_VARS_BEGIN_GAME
    lda #%10000000 ;fire?
    bit INPT4
    bne .exit ; !=0 no pressed
    ;lda #0
    ;sta BooleanGameOver
    jsr InitAll
.exit
    ENDM
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; MACRO sound generator
    MAC PLAY_SOUND_MACRO
;if Victory Song, stop all sounds and play it
.victorySongCH0
    lda BooleanGameOver
    cmp #%10000111
    bne .chanel0
    ldy #18
    jmp .playCH0
;CHANEL 0
.chanel0
    ;ldx #0 ;chanel
    lda TempoCH0 ;sound until the tempo not reach the zero
    beq .introCH0
    dec TempoCH0 ;end of any sound effect
    bne .endCH0
.continuePlayCH0
    jsr SoundEffectCH0
    jmp .endCH0
;inizialize one of the sounds
.introCH0
    lda BooleanGameOver
    cmp #%01000000
    bne .myFireCH0
    ;in CH1
    ;lda #0
    ;sta BooleanGameOver
    ldy #15 ;IntroSongCh0
    jmp .playCH0
.myFireCH0
    lda MyFire
    beq .otherSfxCH0
    lda #0
    sta MyFire
    ldy #11 ;MyFire
    jmp .playCH0
.otherSfxCH0
    lda #$ff
    cmp IdSfx
    beq .endCH0
    ldy IdSfx
    sta IdSfx ;store #$ff
.playCH0
    lda TableSfxLow,y
    sta SoundDataLow0
    lda TableSfxHi,y
    sta SoundDataHi0
    lda #0
    sta CursorSound0
    jsr SoundEffectCH0
.endCH0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;CHANEL 1
.victorySongCH1
    lda BooleanGameOver
    cmp #%10000111
    bne .chanel1
    lda #%00000111
    sta BooleanGameOver
    ldy #19
    jmp .playCH1
.chanel1
    ;ldx #1 ;chanel
    lda TempoCH1 ;sound until the tempo not reach the zero
    beq .introCH1
    dec TempoCH1 ;end of any sound effect
    bne .endCH1
.continuePlayCH1
    jsr SoundEffectCH1
    jmp .endCH1
;inizialize one of the sounds
.introCH1
    lda BooleanGameOver
    cmp #%01000000
    bne .myFireCH1
    lda #0
    sta BooleanGameOver
    ldy #16 ;IntroSongCh1
    jmp .playCH1
.myFireCH1
    lda MyFire
    beq .otherSfxCH1
    lda #0
    sta MyFire
    ldy #11 ;MyFire
    jmp .playCH1
.otherSfxCH1
    lda #$ff
    cmp IdSfx
    beq .endCH1
    ldy IdSfx
    sta IdSfx ;store #$ff
.playCH1
    lda TableSfxLow,y
    sta SoundDataLow1
    lda TableSfxHi,y
    sta SoundDataHi1
    lda #0
    sta CursorSound1
    jsr SoundEffectCH1
.endCH1
    lda #0
    sta MyFire
    ENDM

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;SUBROUTINE show only Enemies on screen for end game
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    MAC ONLYENEMIES
BeginRowEndGame
;scanline21
    sta WSYNC
    ldy IdKind
    ldx YRow0,y ;used for get the Y coordinate of MyRobot among the rows
    stx TempX
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;Check collisions GRP0Laser-GRP1
    lda CXPPMM
    asl ;put a possible 7bit=1 in the carry
    ror CollisionPP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ldy IdKind
    lda CoordXGRP1Row0,y

positioningGRP1EndGame
    sec
    sta WSYNC
    NOP 3 ;sty ENAM0 ;enable here for the right scanline
    ldx #1 ;necessary for right positioning
.DivideLoop2255
    sbc #15
    bcs .DivideLoop2255
    eor #7
    asl
    asl
    asl
    asl
    sta RESP0,x ;fix coarse position
;new scanline
    sta WSYNC
;drawingGRP0
    sta HMP1 ;here is better, no AC is used before
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;check collision not necessary
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ldy IdKind ;TempY
    lda CoordXM1Row0,y
;drawingGRP0
positioningM1EndGame
    sec
    sta WSYNC
    NOP 3 ;sty ENAM0 ;enable here for the right scanline
    ldx #1 ;necessary for right positioning
.DivideLoop2266
    sbc #15
    bcs .DivideLoop2266
    eor #7
    asl
    asl
    asl
    asl
    sta RESM0,x ;fix coarse position
;new scanline
    sta WSYNC
    sta HMM1 ;here is better, no AC is used before
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
definePointerEnemyEndGame
    ldy IdKind ;define Y
    inc IdKind ;increase the Id
    lda KindInRow0,y ;load data for know the kind of grp1
    and #%00001111 ;using the first 4bit
    tay ;new Id generated for read in the table the grp1
    lda TablePointerEnemiesLow,y ;read the data
    sta PointerMultiUseTwoLow
    lda TablePointerEnemiesHi,y
    sta PointerMultiUseTwoHi
    
    lda TablePointerColorEnemiesLow,y ;read the colors
    sta PointerMultiUseOneLow
    lda TablePointerColorEnemiesHi,y
    sta PointerMultiUseOneHi
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;new scanline
    sta WSYNC
    sta HMOVE
    ;inc TempY
;initialize the remaining scanline for strip
    lda #16; it is #21 at the begin
    sta ScanLine
    
;all togheter for 8 lines!
    ldy #0
ScanLoopEndGame
    lda (PointerMultiUseOneLow),y ;ColorEnemy0,y
    sta WSYNC
    sta COLUP1
    sta ENAM1
    lda (PointerMultiUseTwoLow),y ;Enemy0,y
    sta GRP1
    cpy #8 ;compare y for the end of the sprite
    beq noIncrementYEndGame ;if zero, it has zero in the register
    iny
noIncrementYEndGame
    dec ScanLine
    bne ScanLoopEndGame
    dec StripNumber
    bmi goTerra ;PreLoopTerra7 ;exit
    jmp BeginRowEndGame ;begins with another row
goTerra    
    rts
    ENDM
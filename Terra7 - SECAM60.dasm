;Copyright 2024 Cisano Carmelo
;
;This file is part of Terra7
;
;    Terra7 is free software: you can redistribute it and/or modify
;    it under the terms of the GNU General Public License as published by
;    the Free Software Foundation, either version 3 of the License, or
;    (at your option) any later version.
;
;    Terra7 is distributed in the hope that it will be useful,
;    but WITHOUT ANY WARRANTY; without even the implied warranty of
;    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;    GNU General Public License for more details.
;
;    You should have received a copy of the GNU General Public License
;    along with Terra7. If not, see <http://www.gnu.org/licenses/>.

	processor 6502
	include "vcs.h"
	include "macro.h"
    include "my_macro.asm"
    include "joystick_macro.asm"
	include "energy_macro.asm"

;===============================================================================
; Define Some Colors - SECAM60
;===============================================================================
BLACK = #$00
BLUE = #$92
LIGHTBLUE = #$a2 ;Energy hit - flashlight
DARKYELLOW = #$fc ;SmartBomb hit - flashlight
RED = #$f4 ;Astronaut killed by bazooka - flashlight
DARKBLUE = #$9a
HORIZON = #$9a
COLORLASER = #$f4 ;Laser satellite
COLORSCORE = #$fe
COLORLOGO = #$fc
;===============================================================================
; Define Constants
;===============================================================================
SCREEN_BEGINNING = #0
SCREEN_ENDING = #160
END_OF_LINE_MISSILE = #1
INITIAL_SHIELDS = #5
MAXIMUM_SHIELDS = #5
TOT_NUM_ROWS = #4 ;0..1..2..3..4 = 5
X_POS_ICON = #60
X_POS_COUNTER = #69
Y_INIT_COORD_MYROBOT = #22
VOLUME = #6
NUM_BATTERIES = #10
X_INIT_COORD_SATELLITE = #11
ARRIVAL_POINT_SATELLITE = #120
;limits ON SCREEN of MyRobot
UP_LIMIT_MYROBOT = #0
DOWN_LIMIT_MYROBOT = #88
LEFT_LIMIT_MYROBOT = #18
RIGHT_LIMIT_MYROBOT = #110
;===============================================================================
    SEG.U VARS
    org $80
;===============================================================================
;;;;;;;;;;;;;;; RAM ;;;;;;;;;;;;;;;;
Astronaut0 ds 1 ;$80 used for the astronaut in ram - don't touch
Astronaut1 ds 1
Astronaut2 ds 1
Astronaut3 ds 1
Astronaut4 ds 1
Astronaut5 ds 1
Astronaut6 ds 1
Astronaut7 ds 1
Astronaut8 ds 1

KindInRow0 ds 1
KindInRow1 ds 1
KindInRow2 ds 1
KindInRow3 ds 1
KindInRow4 ds 1

TimerRow0 ds 1
TimerRow1 ds 1
TimerRow2 ds 1
TimerRow3 ds 1
TimerRow4 ds 1

TimerMissileRow0 ds 1
TimerMissileRow1 ds 1
TimerMissileRow2 ds 1
TimerMissileRow3 ds 1
TimerMissileRow4 ds 1

TimerTitleScreen ds 1
TimerForAll ds 1
TimerForAstronaut ds 1 ;also used for Energy and SmartBomb

CoordXGRP1Row0 ds 1
CoordXGRP1Row1 ds 1
CoordXGRP1Row2 ds 1
CoordXGRP1Row3 ds 1
CoordXGRP1Row4 ds 1

CoordXM1Row0 ds 1
CoordXM1Row1 ds 1
CoordXM1Row2 ds 1
CoordXM1Row3 ds 1
CoordXM1Row4 ds 1

CoordXLeftToRight0 ds 1
CoordXLeftToRight1 ds 1
CoordXLeftToRight2 ds 1
CoordXLeftToRight3 ds 1
CoordXLeftToRight4 ds 1

YRow0 ds 1
YRow1 ds 1
YRow2 ds 1
YRow3 ds 1
YRow4 ds 1
YRow5 ds 1

CoordXSatellite ds 1

PointerMultiUseOneLow ds 1
PointerMultiUseOneHi ds 1
PointerMultiUseTwoLow ds 1
PointerMultiUseTwoHi ds 1

;BooleanGameOver #%00000001 set Game Over with/without Laser
;BooleanGameOver #%00000010 set Satellite in final position
;BooleanGameOver #%00000100 set Battery Full
;BooleanGameOver #%01000000 set Intro Song
;BooleanGameOver #%10000000 set Victory Song
BooleanGameOver ds 1
BooleanMissileMyRobotIsRunning ds 1
EventFireButtonUp ds 1

VicortySongSwitch ds 1

ScanLine ds 1
TempX ds 1
TempY ds 1

CoordXMyRobot ds 1
CoordYMyRobot ds 1

MaskDifficult ds 1
LevelOfDifficult ds 1

StripNumber ds 1

CursorSound0 ds 1
CursorSound1 ds 1
SoundDataLow0 ds 1
SoundDataHi0 ds 1
SoundDataLow1 ds 1
SoundDataHi1 ds 1
TempoCH0 ds 1
TempoCH1 ds 1

ShieldNumber ds 1

IdKind ds 1
CollisionPP ds 1
CollisionM0P1 ds 1
CollisionM1P0 ds 1
IdNextSprite ds 1

MyFire ds 1
IdSfx ds 1

MaskAstorm ds 1
MaskTimer ds 1
MaskSpeed ds 1

EnemyHitCounter ds 1

BatteryCharging ds 1
TwentyFiveStep ds 1
MaskDecimalBattery ds 1

;**************************************************
    SEG CODE
	org $f000
;**************************************************
MyRobot
	.byte $00 ; |        |
	.byte $00 ; |        |
	.byte $00 ; |        |
	.byte $00 ; |        |
	.byte $00 ; |        |
	.byte $00 ; |        |
	.byte $00 ; |        |
	.byte $00 ; |        |
	.byte $00 ; |        |
	.byte $00 ; |        |
	.byte $00 ; |        |
	.byte $00 ; |        |
	.byte $00 ; |        |
	.byte $00 ; |        |
	.byte $00 ; |        |
	.byte $00 ; |        |
	.byte $00 ; |        |
	.byte $00 ; |        |
	.byte $00 ; |        |
	.byte $00 ; |        |
	.byte $00 ; |        |
	.byte $00 ; |        |
	.byte $70 ; | XXX    |
	.byte $30 ; |  XX    |
	.byte $70 ; | XXX    |
	.byte $20 ; |  X     |
	.byte $F8 ; |XXXXX   |
	.byte $88 ; |X   X   |
	.byte $FF ; |XXXXXXXX|
	.byte $FF ; |XXXXXXXX|
	.byte $36 ; |  XX XX |
	.byte $70 ; | XXX    |
	.byte $50 ; | X X    |
	.byte $50 ; | X X    |
	.byte $90 ; |X  X    |
	.byte $A0 ; |X X     |
	.byte $A0 ; |X X     |
	.byte $A0 ; |X X     |
	.byte $00 ; |        |
	.byte $00 ; |        |
	.byte $00 ; |        |
	.byte $00 ; |        |
	.byte $00 ; |        |
ColorMyRobot
	.byte $00
	.byte $00
	.byte $00
	.byte $00
	.byte $00
	.byte $00
	.byte $00
	.byte $00
	.byte $00
	.byte $00
	.byte $00
	.byte $00
	.byte $00
	.byte $00
	.byte $00
	.byte $00
	.byte $00
	.byte $00
	.byte $00
	.byte $00
	.byte $00
	.byte $00
	.byte $0C
	.byte $04
	.byte $0C
	.byte $0C
	.byte $08
	.byte $08
	.byte $0E
	.byte $0E
	.byte $08
	.byte $0C
	.byte $0C
	.byte $0C
	.byte $0C
	.byte $0C
	.byte $0C
	.byte $0C
	.byte $00
	.byte $00
	.byte $00
	.byte $00
;	.byte $00
;	.byte $00
;	.byte $00
;	.byte $00
;	.byte $00
;	.byte $00
;	.byte $00
;	.byte $00
;	.byte $00
;	.byte $00
;   .byte $00
;   .byte $00
;	.byte $00
;	.byte $00
;	.byte $00
;	.byte $00
;	.byte $00
;	.byte $00
;	.byte $00
;	.byte $00
;	.byte $00
;   .byte $00
;   .byte $00

; share all the zero in the table, saving space - the 4 doesn't show missile by color ;)
TableCollisionToId
;if 00011111 then collision at the first row. The 31th element gives 0 (row0)
	.byte #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #4, #0, #0, #0, #0, #0, #0, #0, #3, #0, #0, #0, #2, #0, #1, #0
PointerValueRows
    .byte #21, #43, #65, #87, #109, #131
TablePtrNumberLow
	.byte <Number0, <Number1, <Number2, <Number3, <Number4, <Number5, <Number6, <Number7, <Number8, <Number9, <Number0
TablePtrNumberHi
	.byte >Number0, >Number1, >Number2, >Number3, >Number4, >Number5, >Number6, >Number7, >Number8, >Number9, >Number0
TablePointerEnemiesLow
    .byte <Asteroid, <Enemy0, <Enemy1, <Enemy2, <Enemy3, <Enemy4, <Enemy5, <Enemy6, <Energy, <$80, <SmartBomb ;$80 Astronaut in RAM 
TablePointerEnemiesHi
    .byte >Asteroid, >Enemy0, >Enemy1, >Enemy2, >Enemy3, >Enemy4, >Enemy5, >Enemy6, >Energy, >$00, >SmartBomb
TablePointerColorEnemiesLow
    .byte <ColorAsteroid, <ColorEnemy0, <ColorEnemy1, <ColorEnemy2, <ColorEnemy3, <ColorEnemy4, <ColorEnemy5, <ColorEnemy6, <ColorEnergy, <ColorAstronaut, <ColorSmartBomb 
TablePointerColorEnemiesHi
    .byte >ColorAsteroid, >ColorEnemy0, >ColorEnemy1, >ColorEnemy2, >ColorEnemy3, >ColorEnemy4, >ColorEnemy5, >ColorEnemy6, >ColorEnergy, >ColorAstronaut, >ColorSmartBomb
TableSfxLow
	.byte <SfxAsteroid, <SfxEnemy, <SfxEnemy, <SfxEnemy, <SfxEnemy, <SfxEnemy, <SfxEnemy, <SfxEnemy, <SfxCatchEnergy
    .byte <SfxCatchAstronaut, <SfxAstronautDead, <SfxMyFire, <SfxDamageMyRobot, <SfxHitSmartBomb, <SfxHitEnergy
	.byte <IntroSongCh0, <IntroSongCh1, <SfxLaserSatellite, <VictorySongCH0, <VictorySongCH1
TableSfxHi
	.byte >SfxAsteroid, >SfxEnemy, >SfxEnemy, >SfxEnemy, >SfxEnemy, >SfxEnemy, >SfxEnemy, >SfxEnemy, >SfxCatchEnergy
    .byte >SfxCatchAstronaut, >SfxAstronautDead, >SfxMyFire, >SfxDamageMyRobot, >SfxHitSmartBomb, >SfxHitEnergy
	.byte >IntroSongCh0, >IntroSongCh1, >SfxLaserSatellite, >VictorySongCH0, >VictorySongCH1 

Start CLEAN_START

initializingMainVariables
    lda #0
	sta AUDV0
	sta AUDV1
	;Playfield and Ball setting
	lda #%00110101
    sta CTRLPF
setGameOver
	lda #%00000001
    sta BooleanGameOver
;set mask for the first time showing the battery in the score
	lda #%11110000
	sta MaskDecimalBattery
;KERNEL OF THE GAME
NextFrame
	VERTICAL_SYNC

verifyReset
	lsr SWCHB ;test Game Reset switch
	bcs setTimer ;reset?
	jmp Start

setTimer
    lda #44 ;37 lines x 76 cycles per lines = 2812 cycles / 64 = 43
    sta TIM64T

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;begin game not appear all at once
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	lda CoordXSatellite
	cmp #X_INIT_COORD_SATELLITE
	bne increaseTimer
	lda TimerRow0 ;at begin have all the same value
	cmp #60 ;this number is a good choise
	bne increaseTimer
	lda IdNextSprite
	ldx #4
setTimersFirstWave
	ror
	sta TimerRow0,x
	dex
	bpl setTimersFirstWave
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

increaseTimer
	inc TimerForAll

copyAstronautInRam
    ldx #8
	ldy #8 ;pointer at the first frame
    lda TimerForAll
    and #%00010000 ;change every 16 tv frames
    beq copyAstronaut
    ldy #17 ;pointer at the second frame
copyAstronaut
	lda AstronautFrame0,y ;read the data
    sta $80,x ;copy in RAM
    dey ;inc data id
    dex
    bpl copyAstronaut

	lda #TOT_NUM_ROWS
	sta StripNumber
;the Game Over has 2 choice
;come back to the title screen if laser not charged
;show laser in action!
checkForLogoScreen
    lda BooleanGameOver
    beq checkJoy
	cmp #%00000111
	beq noRobotOnScreen
	cmp #%00000011
	beq checkForTitleScreen
	cmp #%00000101
	beq checkForTitleScreen
	cmp #%00000001
	beq checkForTitleScreen
	bne checkJoy

checkForTitleScreen
	lda TimerTitleScreen ;first start has the value for the logo screen
	bne noRobotOnScreen
	jmp drawLogo

noRobotOnScreen
;My Robot disappears if Game Over
	ldy #5
	lda #0
loopSetZeroPointersRobot
	sta YRow0,y
	dey
	bpl loopSetZeroPointersRobot

	inc TimerTitleScreen ;increase timer
	jmp veryfyAstronautLost

checkJoy
    JOYSTICK_MACRO
positionigMyRobot

;pos in Y
;
;How it works:
;Only 2 variables are written in the loop.
;The others remain zero.
;The 2 variables are in the rows can have the P0.
;The first point to where start in the row
;The second where start in the next row
    ldy #$ff
loopRowsSet
    iny ;at first start = 0
	lda PointerValueRows,y ;.byte #21, #42, #63, #84, #105, #126
	clc
	sbc CoordYMyRobot
	bmi loopRowsSet
	sta YRow0,y
	clc
	adc #22
    iny
	sta YRow0,y

;if MyRobot not catch Astronaut
veryfyAstronautLost
	ldx #TOT_NUM_ROWS
loopAstronautLost
	lda KindInRow0,x
	cmp #%00001001 ;Astronaut
	bne checkAnotherRow
	lda CoordXGRP1Row0,x
	cmp #2 ;coord on screen
	bne updateMyMissile

	lda #10 ;SfxAstronautDead
	sta IdSfx
	jsr decShield

	jmp updateMyMissile
checkAnotherRow
	dex
	bpl loopAstronautLost

updateMyMissile
    lda #%01000000
    and CXM0FB ;check collision with M0 and ball
	ora CollisionM0P1 ;or collision with any P1
	beq positionigMyMissile ;if zero no collisions then move missile
	lda #2 ;collision detect
	sta RESMP0 ;lock missile on grp0
    lda #0
	sta HMM0 ;otherwhise can appear after the ball
	sta BooleanMissileMyRobotIsRunning ;possible to shoot again now
	jmp endUpdateMyMissile
positionigMyMissile
	lda BooleanMissileMyRobotIsRunning ;set in joystick_macro
	beq endUpdateMyMissile ;if 0 the missile is not running
	;otherwhise the missile start some pixels after GRP0 :|
	lda MyFire
	beq secondFrameMissile
	lda #%00000000 ;position missile some pixel back at first frame
	jmp storeMissilePos
secondFrameMissile
	lda #%10010000; second frame right position - speed MyMissile
storeMissilePos
	sta HMM0
endUpdateMyMissile
;end positioning MyMissile
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;update positions enemies
	ldx #TOT_NUM_ROWS
updateEnemy
	lda CoordXGRP1Row0,x ;check every row
	;cmp #SCREEN_BEGINNING ;if not arrived at the end
	bne moveP1 ;skip update new ship
manageEntryTimer
	lda KindInRow0,x
	and #%10000000 ;no new grp1 if missile still alive
	bne checkAnother
	;timer start when boolean is false
	dec TimerRow0,x ;no missile so decrease the timer
	bne checkAnother ;no zero then no new entry
	;;;;;;;;;;;;;;;;;;;;;;
	jsr loadNextSprite ;load new entry when timer is zero
	;;;;;;;;;;;;;;;;;;;;;;

;initialize position
rightToLeft
	lda #SCREEN_ENDING ;new coordinate to P1/M1
	sta CoordXGRP1Row0,x ;save grp1 coordinate
	lda #END_OF_LINE_MISSILE ;#SCREEN_ENDING+1 otherwhise the missile is not covered by the ball
	sta CoordXM1Row0,x ;save missile coordinate
leftToRight
;initial coordinate for possible slow Asteroid
	lda #SCREEN_BEGINNING
	sta CoordXLeftToRight0,x
moveP1
	dec	CoordXGRP1Row0,x ;here the speed of movement
	inc CoordXLeftToRight0,x ;asteroid left to right
	lda KindInRow0,x ;get data for the speed
	and #%01000000 ;check the bit of speed
	beq checkAnother ;if zero normal speed
	dec	CoordXGRP1Row0,x ;if 1 double speed so dec again
checkAnother
	dex
	bpl updateEnemy
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;update positions missiles
	ldx #TOT_NUM_ROWS
updateEnemyMissile
	lda KindInRow0,x
	and #%10000000 ;bit7=1 missile - 0 no missile, double speed or asteroid
	beq loopDex ;if not alive esc
timerMissile
	lda TimerMissileRow0,x ;check timer M1,x
	beq moveMissile ;if zero then must run
	dec TimerMissileRow0,x ;decrease timer

 	;before it moves I set right position of M1
	lda CoordXGRP1Row0,x
	sta CoordXM1Row0,x ;grp1 and M1 stay togheter
	inc CoordXM1Row0,x
	jmp loopDex

moveMissile
    dec CoordXM1Row0,x ;bullet speed
    dec CoordXM1Row0,x

	lda CoordXM1Row0,x ;check if M1 arrived
	sec
	sbc #4 ;#SCREEN_BEGINNING
	bcc endMissile
	jmp loopDex
endMissile
	lda KindInRow0,x
	and #%01111111 ;turn off M1
	sta KindInRow0,x
	lda #END_OF_LINE_MISSILE
	sta CoordXM1Row0,x
loopDex
    dex
    bpl updateEnemyMissile
;end update positions enemy missiles
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;now verify collisions in all the rows between P0 and P1
verifyCollisionPP
	lda CollisionPP ;can be 11111000
	beq exitCollisionPP ;if 0 no collision
    lsr ;now 01111100
	lsr ;now 00111110
	lsr ;now 00011111
	tay
	ldx TableCollisionToId,y
	lda #SCREEN_BEGINNING
	sta CoordXGRP1Row0,x ;every kind collides go under the ball
	;lda #0
	sta CoordXLeftToRight0,x
	jsr manageCollisionPP ;dec ShieldNumber
	;manage possible enemy missile
	jsr stopPossibleMissile
exitCollisionPP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;now verify collisions in all the rows between M0 and P1
verifyCollisionM0P1
	lda CollisionM0P1 ;load the stored collision
	beq exitCollisionM0P1 ;if 0 no collision
    lsr ;now 01111100
	lsr ;now 00111110
	lsr ;now 00011111
	tay
	ldx TableCollisionToId,y ;gives back the row

;avoid sound effect when GRP1 is under the ball
checkIfOnScreen
	lda CoordXGRP1Row0,x
	beq exitCollisionM0P1 ;no on the screen	
	cmp #SCREEN_ENDING
	beq exitCollisionM0P1 ;no on the screen	
	;it is on the screen!
storeValureForSfx
    lda KindInRow0,x ;check which kind of object in the row
	and #%00001111 ;mask with 4 bits define the object
	sta IdSfx ;set Sound Effect
    beq exitCollisionM0P1 ;if 0 means asteroid not destructible
	;no asteroid
	jsr manageCollisionM0P1
	lda #SCREEN_BEGINNING ;no asteroid
	sta CoordXGRP1Row0,x
	;lda #0
	sta CoordXLeftToRight0,x
	;manage possible enemy missile
	jsr stopPossibleMissile
exitCollisionM0P1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;now verify collisions in all the rows between M1 and P0
verifyCollisionM1P0
	lda CollisionM1P0 ;load the stored collision
	beq exitCollisionM1P0 ;if 0 no collision
	lsr ;now 01111100
	lsr ;now 00111110
	lsr ;now 00011111
	tay
	ldx TableCollisionToId,y
	lda #4 ;#SCREEN_BEGINNING
	sta CoordXM1Row0,x

	lda #12 ;SfxDamageMyRobot
	sta IdSfx
	jsr decShield ;inside manageCollisionPP
exitCollisionM1P0

preLoopa
;;;;;;;;;;;;;;;;;;;;;;;;;;
	ldy #TOT_NUM_ROWS
swapEnter
	lda KindInRow0,y
	and #%01001111 ;mask for check slow asteroid
	bne checkSwapEnter
	ldx CoordXGRP1Row0,y
	lda CoordXLeftToRight0,y
	sta CoordXGRP1Row0,y
	stx CoordXLeftToRight0,y
checkSwapEnter
	dey
	bpl swapEnter
;;;;;;;;;;;;;;;;;;;;;;;;;;
Loopa
    lda INTIM
    bne Loopa
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Disable VBLANK
    sta WSYNC
    lda #0
    sta VBLANK
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;DrawScore
setColoryCounters
	lda #COLORSCORE
	sta COLUP0
	sta COLUP1
setPositionCounters
	lda #X_POS_ICON
	ldy #0
	jsr PositionElement
	lda #X_POS_COUNTER
	ldy #1
	jsr PositionElement

	DEF_NUMBERS_POINTERS_MACRO ;inside sta HMOVE

    lda BooleanGameOver
	beq showData
	cmp #%00000111 ;Game Over with Victory
	beq showData
	cmp #%00000100 ;battery full only
	beq showData

	ldy #0
showMessage
	SHOW_MESSAGE_MACRO
    cpy #7
	bne showMessage
	jmp endShowData

showData
	ldy #0
showShield
	SHOW_ENERGY_MACRO
    cpy #7
	bne showShield

endShowData
	lda #0
	sta GRP0
	sta GRP1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    sta WSYNC
    sta HMCLR
defineSizeMissile
    lda #%00110000 ;big missile and 1 copy P0
    sta NUSIZ0
	lda #%00100000 ;small missile and 1 copy P1
    sta NUSIZ1

checkPositionSatellite
	lda #36
	sta TIM8T
	lda TimerForAll
	bne positionSatellite ;when timer=0 then move satellite
    ;every 256cycles, increase TimerAstronaut
    inc TimerForAstronaut
    lda #ARRIVAL_POINT_SATELLITE
    cmp CoordXSatellite
    beq setFlagSatelliteGameOver ;if zero then end game
    inc CoordXSatellite
	jmp positionSatellite

setFlagSatelliteGameOver
	;set Game Over flag
	lda BooleanGameOver
	ora #%00000011 ;means final position satellite
	sta BooleanGameOver

positionSatellite
	lda CoordXSatellite
    ldy #0 ;grp0
	jsr PositionElement; PositionTwoCopiesSprite
    lda CoordXSatellite
    clc
	adc #8
    ldy #1 ;grp1
	jsr PositionElement; PositionTwoCopiesSprite

waitTimerAfterSatellite
    lda INTIM
    bne waitTimerAfterSatellite

    sta WSYNC
    sta HMOVE
    sta WSYNC
    sta HMCLR
	lda #8
	sta REFP1 ;right side of satellite
	ldx #0
drawSatellite
    sta WSYNC
	lda Satellite,x ;load gfx data
	sta GRP0
	sta GRP1
	lda ColorSatellite,x
	sta COLUP0
	sta COLUP1
	inx
    cpx #8
    bne drawSatellite

positioningLaser
	lda #%10110000
	sta HMP0
loopWsyncBeforeRows
	sta WSYNC
    sta HMOVE
    ldy #0 ;GRP0
	sty REFP1 ;reset reflect after satellite
    lda #20 ;(16linees x 76cycles)/64=20
    sta TIM64T

    ;chek which GameOver can be
    lda BooleanGameOver
	cmp #%00000111 ;show laser if Satellite in final position and Battery full
    bne setPositionMyRobot

	lda #%11111100 ;laser beam wide 6bit
	sta GRP0
	lda #COLORLASER
	adc CollisionPP ;laser beam change color when hit :)
    sta COLUP0
    jmp loopTimerAfterLaser

setPositionMyRobot
    lda CoordXMyRobot
    ldy #0 ;GRP0
    jsr PositionElement
	sta WSYNC
	sta HMOVE

loopTimerAfterLaser
    lda INTIM
    bne loopTimerAfterLaser

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	sta WSYNC
;the first time nothing must be showen
	ldx #0
	stx IdKind ;initialize the id used by Y for kind of grp1 in row
resetCollisions
    stx CollisionPP ;reset collisions can happen in 5 rows
    stx CollisionM0P1 ;reset collisions can happen in 5 rows
	stx CollisionM1P0 ;reset collisions can happen in 5 rows
	sta CXCLR ;clear all collisions

	stx TempY
	sta HMCLR

    ;endgame
	;if Shield=0 or Satellite in final position
	;then show only enemies
    lda BooleanGameOver
	and #%00000011
    beq BeginRow
	jsr onlyEnemies
    jmp PreLoopTerra7

BeginRow
;scanline21
    sta WSYNC
    lda MyRobot,x
    sta GRP0
    lda ColorMyRobot,x
    sta COLUP0
    sta ENAM0

	ldy IdKind
	ldx YRow0,y ;used for get the Y coordinate of MyRobot among the rows
    stx TempX
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;Check collisions GRP0-GRP1
	lda CXPPMM
	asl ;put a possible 7bit=1 in the carry
	ror CollisionPP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	ldy IdKind
	lda CoordXGRP1Row0,y
;drawingGRP0
	SLEEP 10
	ldy MyRobot,x ;draw it in the wrong scanline
	sty GRP0 ;but necessary because no time after
	ldy ColorMyRobot,x
	sty COLUP0
positioningGRP1
	sec
	sta WSYNC
	sty ENAM0 ;enable here for the right scanline
    ldx #1 ;necessary for right positioning
.DivideLoop225
	sbc #15
	bcs .DivideLoop225
	eor #7
	asl
	asl
	asl
	asl
	sta RESP0,x
;new scanline
	sta WSYNC
    ldx TempX ;load X
    inx ;increase the pointer data GRP0
;drawingGRP0
	ldy MyRobot,x
	sty GRP0
	ldy ColorMyRobot,x
	sty ENAM0
	sty COLUP0
	sta HMP1 ;here is better, no AC is used before
	inx ;increase the pointer data GRP0
	
	stx TempX ;save X
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;check collision M0 and P1
	lda CXM0P
	asl ;$30 ;put a possible 7bit=1 in the carry
	ror CollisionM0P1
	;check collision M1 and P0
	lda CXM1P
	asl ;$31 ;put a possible 7bit=1 in the carry
	ror CollisionM1P0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ldy IdKind
	lda CoordXM1Row0,y
;drawingGRP0
	ldy MyRobot,x ;prepare it in the wrong scanline
	sty GRP0 ;but necessary because no time after
	ldy ColorMyRobot,x
	sty COLUP0
positioningM1
	sec
	sta WSYNC
	sty ENAM0 ;enable here for the right scanline
	ldx #1 ;necessary for right positioning
.DivideLoop226
	sbc #15
	bcs .DivideLoop226
	eor #7
	asl
	asl
	asl
	asl
	sta RESM0,x
;new scanline
	sta WSYNC
	ldx TempX
	inx
;drawingGRP0
	ldy MyRobot,x
	sty GRP0
	ldy ColorMyRobot,x
	sty ENAM0
	sty COLUP0
	sta HMM1 ;here is better, no AC is used before
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
definePointerEnemy
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
	inx
	lda MyRobot,x ;load data for sprite
	sta GRP0 ;write data for sprite
	lda ColorMyRobot,x ;color my ship
	sta COLUP0
	sta ENAM0 ;enable possible missile
	inx
;initialize the remaining scanline for strip
	lda #16; it is #21 at the begin
    sta ScanLine

    lda #1
    sta VDELP1
    
;all togheter for 8 lines!
	ldy #0
ScanLoop
    lda (PointerMultiUseTwoLow),y ;Enemy0,y
	sta GRP1
	lda (PointerMultiUseOneLow),y ;ColorEnemy0,y
		sta WSYNC
    sta COLUP1
    sta ENAM1
	lda MyRobot,x
    sta GRP0 ;sta GRP1 by VDELP1
    lda ColorMyRobot,x
    sta COLUP0
    sta ENAM0

    inx
    cpy #8 ;compare y for the end of the sprite
    beq noIncrementY ;if zero, it has zero in the register
	iny
noIncrementY

	dec ScanLine
	bne ScanLoop
    dec StripNumber
    bmi PreLoopTerra7 ;exit
	jmp BeginRow ;begins with another row

PreLoopTerra7
	ldy #8
loopNineLines
    sta WSYNC
	dey
	bpl loopNineLines

	lda #HORIZON
	sta COLUBK
	lda #DARKBLUE
	sta COLUPF
    ldx #0
	stx ENABL
    stx GRP0 ;turn off laser beam

	;ldy #0
drawPlanet
	sta WSYNC
	lda #BLUE
	sta COLUBK
    lda PlayfieldPlanet,x
    sta PF0
	inx
    lda PlayfieldPlanet,x
    sta PF1
    inx
	lda PlayfieldPlanet,x
    sta PF2
	inx
	sta WSYNC
	cpx #39
	bne drawPlanet
	sta WSYNC
; Clear the background color and sprites before overscan
	sta WSYNC
	lda #BLACK ;0
    sta COLUBK
	sta COLUPF
	sta PF0
	sta PF1
	sta PF2
	;sta ENABL
	sta GRP0
	sta GRP1
    ;sta REFP1
	sta ENAM0
	sta ENAM1
    ;necessary after the screen logo
    sta VDELP0
	sta VDELP1

; 30 lines of overscan
LVOver
	sta WSYNC
	lda #2
	sta VBLANK

setBallBorderScreen
	lda #2
    sta ENABL ;used for left side of the screen
    lda #4 ;coord
    ldy #4 ;ball
    jsr PositionElement

	lda #34 ;29 lines x 76 cycles per line = 2204 cycles / 64 = 34
	sta TIM64T
	sta WSYNC
	sta HMOVE
;;;;;;;;;;;;;;;;;;;;;;;;;;
	ldy #TOT_NUM_ROWS
swapEnterTwo
	lda KindInRow0,y
    and #%01001111 ;mask for check slow asteroid
	bne checkSwapEnterTwo
	ldx CoordXGRP1Row0,y
	lda CoordXLeftToRight0,y
	sta CoordXGRP1Row0,y
	stx CoordXLeftToRight0,y
checkSwapEnterTwo
	dey
	bpl swapEnterTwo
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
storeCollisionPPLastRow
	lda CXPPMM
	asl ;put a possible 7bit=1 in the carry
	ror CollisionPP ;carry enters in bit7
storeCollisionM0P1LastRow
	lda CXM0P
	asl ;put a possible 7bit=1 in the carry
	ror CollisionM0P1 ;carry enters in bit7
storeCollisionM1P0LastRow
	lda CXM1P
	asl ;put a possible 7bit=1 in the carry
	ror CollisionM1P0 ;carry enters in bit7
;end check collision in last row
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Manage Victory Song
	lda BooleanGameOver
	cmp #%00000111
	bne soundEffect
	lda VicortySongSwitch
	ora BooleanGameOver ;now #%10000111
	sta BooleanGameOver
	lda #0
	sta VicortySongSwitch ;it works once!
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
soundEffect
	PLAY_SOUND_MACRO
	jsr manageDifficult

LoopaOverscan
	lda INTIM
	bne LoopaOverscan
; Go back and do another frame
	sta HMCLR
	jmp NextFrame

;*********************************************************************
; SUBROUTINE
;*********************************************************************
PositionElement
;ac is the X position 
;y is the graphic object
	sec
	sta WSYNC
	bit 0
.DivideLoop2
	sbc #15
	bcs .DivideLoop2
	eor #7
	asl
	asl
	asl
	asl
	sta RESP0,y ;fix coarse position
	sta HMP0,y
	rts
;*********************************************************************
; SUBROUTINE
; bit6=0 normal speed - 1 double speed
; bit7=1 missile - 0 no missile
;*********************************************************************
loadNextSprite
    ;check time for Astronaut or Energy
    lda TimerForAstronaut
maybeEnergy
	and #%00001111
	cmp #15
	bne maybeSmartBomb
    inc TimerForAstronaut
    lda #%00001000 ;bit3 Energy - bit6 & bit7 normal speed and no missile :)
	jmp storeValueRow
maybeSmartBomb
	and #%00000111
    cmp #7
    bne maybeAstronaut
    inc TimerForAstronaut
    lda #%00001010 ;bit1&bit3 smartBomb - bit6 & bit7 normal speed and no missile :)
    jmp storeValueRow
maybeAstronaut
    and #%00000111
    cmp #4
    bne nextElement
    inc TimerForAstronaut
    lda #%00001001 ;bit0&bit3 astronaut - bit6 & bit7 normal speed and no missile :)
    jmp storeValueRow
nextElement
	;bit0/3 kind of sprite
    inc IdNextSprite ;inc the id used to read the rom ;)
	ldy IdNextSprite ;load the id in Y
maybeAsteroid	
	lda storeCollisionPPLastRow,y ;must begin somewhere :)
	and #%00000111 ;mask for objects 0...7
    bne surelyShip ;if !=0 then no asteroid
    lda storeCollisionPPLastRow,y ;maybe asteroid slow or fast, so no missile!
    and #%01000000 ;bit7=0 no missile - asteroid fast or slow
    jmp storeValueRow
	;beq storeValueRow ;slow Asteroid, then left to right Asteroid
surelyShip
	lda storeCollisionPPLastRow,y
    and #%01000111 ;mask + if bit6=1
	cmp #%00111111 ;if >0 then double speed then no missile
	bpl storeValueRow
	ora #%10000000 ;then <0 set bit7=1 for missile
	;mask for speed of ship
	eor MaskSpeed
	;jmp storeValueRow
storeValueRow
	;mask for Asteroid Storm
	and MaskAstorm
	sta KindInRow0,x

randomTimer
	;random generator used for missile timer
	lda storeCollisionPPLastRow,y ;seed
    asl
    bcc noEor
    eor #$1d
noEor
	and #%01111111 ;manage the difficult, but not important
	sta TimerMissileRow0,x

	;mask timer entrance grp1
	and MaskTimer ;manage the difficult
	ora #%00111000 ;with this no possible timer=0
storeTimer
    sta TimerRow0,x
return	
	rts

;*********************************************************************
; SUBROUTINE set SFX for Collision PP - M1P0 (only decShield is used)
;*********************************************************************
manageCollisionPP
	lda #17 ;SfxLaserSatellite
	sta IdSfx
	lda BooleanGameOver
	cmp #%00000111 ;if Game Over with Laser no inc/dec shield
	beq continueGame

	lda KindInRow0,x
collisionAsteroid
	and #%00001111
	sta IdSfx ;ok for Asteroid, Enemy, Astronaut, Energy
	beq decShield

collisionEnergy
	cmp #%00001000 ;check collision with Energy
	bne collisionAstronaut
	lda ShieldNumber
	beq continueGame
    cmp #MAXIMUM_SHIELDS
    beq continueGame
	inc ShieldNumber
	rts

collisionAstronaut
	cmp #%00001001 ;check collision with Astronaut
	bne setSoundDamageRobot ;set sound damage Robot, after decShield because hit ship or asteroid
	rts
setSoundDamageRobot
	lda #12 ;SfxDamageMyRobot
	sta IdSfx
decShield
	lda ShieldNumber
	beq continueGame ;must not go under zero
	dec ShieldNumber
	bne continueGame

	lda BooleanGameOver
	ora #%00000001
	sta BooleanGameOver

continueGame
	rts

;*********************************************************************
; SUBROUTINE set SFX for Collision M0P1
;*********************************************************************
manageCollisionM0P1
    ;lda KindInRow0,x
	;and #%00001111
maybeHitEnergy
	cmp #%00001000 ;Energy
	bne maybeHitSmartBomb
	lda #LIGHTBLUE
	sta COLUBK
		lda #14 ;SfxHitEnergy
		sta IdSfx
	rts
maybeHitSmartBomb
	cmp #%00001010 ;SmartBomb
	bne maybeKillAstronaut
	lda #DARKYELLOW
	sta COLUBK
	ldy #4 ;destroy 5 lines
	jsr resetAllPositionsAndTimers

	inc EnemyHitCounter
	inc EnemyHitCounter
		lda #13 ;SfxHitSmartBomb
		sta IdSfx
	jmp checkIfBatteryIsFull
maybeKillAstronaut
	cmp #%00001001 ;Astronaut
	bne checkIfBatteryIsFull
	lda #RED
	sta COLUBK
		lda #10 ;SfxAstronautDead
		sta IdSfx
	jmp decShield ;rts inside this
	;rts

checkIfBatteryIsFull
    lda BatteryCharging
    cmp #NUM_BATTERIES
	beq endCollisionM0P1 ;if exit then already killed all!

	inc EnemyHitCounter ;ship hit
checkIfToChargeBattery
	lda EnemyHitCounter
	cmp TwentyFiveStep
	bmi endCollisionM0P1
	clc
	adc #25 ;increase the the next check point
	sta TwentyFiveStep ;250 max value = 10 BatteryCharging
	inc BatteryCharging ;increase every 25 enemies hit

	;set in advance
	ldy #%11110000 ;hide the number 1 near the battery icon
    lda BatteryCharging
    cmp #NUM_BATTERIES
	bne storeValueDecimalMask
	;set Game Over flag
	lda BooleanGameOver
	ora #%00000100 ;means Battery Full in Game Over
	sta BooleanGameOver

	ldy #%11111111 ;show the number 1 near the battery icon
storeValueDecimalMask
	sty MaskDecimalBattery
endCollisionM0P1
    rts

;*********************************************************************
; SUBROUTINE define vars for difficult levels
;*********************************************************************
manageDifficult
	lda CoordXSatellite
easyLevel
	cmp #18
	bpl stormOne
	lda #%01111111 ;MaskTimer
	ldx #%11111111 ;MaskAstorm
	ldy #%00000000 ;MaskSpeed
	jmp storeDataLevel
stormOne
	cmp #20
	bpl mediumLevel
	lda #%00011100 ;MaskTimer
	ldx #%01110000 ;MaskAstorm
	ldy #%00000000 ;MaskSpeed
	jmp storeDataLevel
mediumLevel
	cmp #36
	bpl stormTwo
	lda #%00001111 ;MaskTimer
	ldx #%11111111 ;MaskAstorm
	ldy #%00000000 ;MaskSpeed
	jmp storeDataLevel
stormTwo
	cmp #40
	bpl easyLevelTwo
	lda #%00001100 ;MaskTimer
	ldx #%01111000 ;MaskAstorm
	ldy #%11000000 ;MaskSpeed
	jmp storeDataLevel
easyLevelTwo
	cmp #45
	bpl mediumLevelTwo
	lda #%01111111 ;MaskTimer
	ldx #%11111111 ;MaskAstorm
	ldy #%00000000 ;MaskSpeed
	jmp storeDataLevel
mediumLevelTwo
	cmp #55
	bpl stormThree
	lda #%00001111 ;MaskTimer
	ldx #%11111111 ;MaskAstorm
	ldy #%00000000 ;MaskSpeed
	jmp storeDataLevel
stormThree
	cmp #58
	bpl mediumLevelThree
	lda #%00001100 ;MaskTimer
	ldx #%01111000 ;MaskAstorm
	ldy #%11000000 ;MaskSpeed
	jmp storeDataLevel
mediumLevelThree
	cmp #72
	bpl easyLevelThree
	lda #%00001111 ;MaskTimer
	ldx #%11111111 ;MaskAstorm
	ldy #%00000000 ;MaskSpeed
	jmp storeDataLevel
easyLevelThree
	cmp #85
	bpl hardLevel
	lda #%01111111 ;MaskTimer
	ldx #%11111111 ;MaskAstorm
	ldy #%00000000 ;MaskSpeed
	jmp storeDataLevel
hardLevel
	lda #%00001000 ;MaskTimer
	ldx #%11111111 ;MaskAstorm
	ldy #%11000000 ;MaskSpeed

storeDataLevel
	sta MaskTimer
	stx MaskAstorm
	sty MaskSpeed
	rts

;*********************************************************************
; SUBROUTINE reset position all ships missiles
;*********************************************************************
resetAllPositionsAndTimers
	ldy #4
loopInitialPosition
	lda #4 ;coord X missile
	sta CoordXM1Row0,y
	lda #SCREEN_BEGINNING ;coord X enemies
	sta CoordXGRP1Row0,y
	;lda #0
	sta CoordXLeftToRight0,y ;reset coord slow asteroid
	sta TimerMissileRow0,y
	dey
	bpl loopInitialPosition ;for all the missiles and enemies
	rts

;*********************************************************************
; SUBROUTINE if timer missile=0 maybe missile on screen
;*********************************************************************
stopPossibleMissile
	lda TimerMissileRow0,x ;timer=0 maybe missile on the screen
	beq exitStopPossibleMissile ;leave it running
	lda #0 ;timer is running to zero, grp1 killed then stop timer missile
	sta TimerMissileRow0,x ;no missile can start now
	lda #4 ;set position missile at #SCREEN_BEGINNING
	sta CoordXM1Row0,x
exitStopPossibleMissile
	rts
;*********************************************************************
;SUBROUTINE INIT VARS FOR NEW GAME
;*********************************************************************
InitAll
    lda #VOLUME
	sta AUDV0
    sta AUDV1

	lda #%01000000 ;set value for intro song
    sta BooleanGameOver
	;asl BooleanGameOver
setBeginNextSequence    
    lda TimerForAll
	sta IdNextSprite ;to have different sequence in every new game

	lda #1
	sta TimerTitleScreen
    sta EventFireButtonUp ;no missile and sound at the first start!
MyRobotPositionNewGame
;MyRobot position in X and Y
	lda #LEFT_LIMIT_MYROBOT
	sta CoordXMyRobot
	lda #Y_INIT_COORD_MYROBOT
	sta CoordYMyRobot
missile0Position
	lda #2
	sta RESMP0 ;lock M0 to P0
	ldy #TOT_NUM_ROWS
initialPosition
	jsr resetAllPositionsAndTimers
;**********************************************************
;with 255 the ships not appear before the end of the jingle
	lda #255
	ldy #4
resetTimers
	sta TimerRow0,y
	dey
	bpl resetTimers
;**********************************************************
otherVarsNeedZero
	lda #0
	sta TimerForAll
	sta LevelOfDifficult
    sta TimerForAstronaut
	sta BooleanMissileMyRobotIsRunning
	sta TempoCH0
	sta TempoCH1
	sta EnemyHitCounter
	sta BatteryCharging
otherNeedsNotZero
	lda #%10000000
	sta VicortySongSwitch
	lda #25
	sta TwentyFiveStep
	lda #%11110000
	sta MaskDecimalBattery
    lda #$ff
    sta IdSfx
setPosSatellite
	lda #X_INIT_COORD_SATELLITE
	sta CoordXSatellite
assignShieldNumbers
	lda #INITIAL_SHIELDS
	sta ShieldNumber
	rts
;*********************************************************************
; Display the name of the game
drawLogo
	lda INTIM
	bne drawLogo
	;sta HMCLR
	sta WSYNC
	; Disable VBLANK
	lda #0
	sta VBLANK

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;DrawScore
setColorCountersGameOver
	lda #COLORSCORE
	sta COLUP0
	sta COLUP1
setPositionCountersGameOver
	lda #X_POS_ICON
	ldy #0
	jsr PositionElement
	lda #X_POS_COUNTER
	ldy #1
	jsr PositionElement

	DEF_NUMBERS_POINTERS_MACRO ;inside sta HMOVE

	ldy #0
showShieldGameOver
	SHOW_ENERGY_MACRO
    cpy #7
	bne showShieldGameOver

	lda #0
	sta GRP0
	sta GRP1
	sta GRP0
	sta GRP1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	ldy #42
deltaFrameUp
	sta WSYNC
	dey
	bne deltaFrameUp

	lda #3
	sta NUSIZ0
	sta NUSIZ1	; both players have 3 copies
	;lda #1
	sta VDELP0
	sta VDELP1
	lda #59
	ldy #0
	jsr PositionElement ;position GRP0

	lda #67
	ldy #1
	jsr PositionElement ;position GRP1

	sta WSYNC
	sta HMOVE

	lda #25 ;logo dimension
	sta TempX

.drawLoopLogo
	ldy TempX ;counts backwards
	lda logo_5,y ;6th
	sta TempY

	sta WSYNC
	lda #COLORLOGO
	sta COLUP0
	sta COLUP1

	lda logo_0,y ;1st
	sta GRP0
	lda logo_1,y ;2nd
	sta GRP1
	lda logo_2,y ;3rd
	sta GRP0
	lda logo_4,y ;5th
	tax
	lda logo_3,y ;4th
	ldy TempY
	sta GRP1 ;4th
	stx GRP0 ;5th
	sty GRP1 ;6th
	sta GRP0
	dec TempX ;go to next line

	bpl .drawLoopLogo ;repeat until < 0

	lda #85 ;71lines*76cycles/64T=85
	sta TIM64T

	SET_ALL_VARS_BEGIN_GAME
loopWsync
	lda TIM64T
	bne loopWsync
	jmp PreLoopTerra7
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;SUBROUTINE called by PLAY_SOUND_MACRO
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SoundEffectCH0
	ldy CursorSound0
	;last 3 datas must be zero, so all the sounds stop
	lda (SoundDataLow0),y
	sta AUDC0
	iny
	lda (SoundDataLow0),y
	sta AUDF0
	iny
	lda (SoundDataLow0),y
	sta TempoCH0
	beq .endSoundCH0
	iny
	sty CursorSound0
.endSoundCH0
	rts
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;SUBROUTINE called by PLAY_SOUND_MACRO
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SoundEffectCH1
	ldy CursorSound1
	;last 3 datas must be zero, so all the sounds stop
	lda (SoundDataLow1),y
	sta AUDC1
	iny
	lda (SoundDataLow1),y
	sta AUDF1
	iny
	lda (SoundDataLow1),y
	sta TempoCH1
	beq .endSoundCH1
	iny
	sty CursorSound1
.endSoundCH1
	rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;SUBROUTINE show only enemies for endgame
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
onlyEnemies	
	ONLYENEMIES
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;SoundFX
SfxAsteroid
    .byte $02,$05,$04,  $02,$1d,$02,  $02,$1e,$02,  $02,$1f,$02,  $02,$10,$02,  $02,$11,$02,  $00,$00,$00
SfxEnemy
	.byte $06,$02,$03,  $06,$0b,$02,  $06,$02,$02,  $06,$0b,$02,  $06,$02,$02,  $06,$0b,$02,  $00,$00,$00
SfxCatchEnergy
	.byte $06,$07,$02,  $06,$05,$02,  $06,$07,$02,  $06,$05,$02,  $06,$03,$02,  $06,$05,$02,  $06,$03,$02,  $06,$01,$02,  $06,$03,$02,  $00,$00,$00
SfxCatchAstronaut
    .byte $06,$0f,$02,  $06,$10,$02,  $06,$0e,$02,  $06,$0f,$02,  $06,$0d,$02,  $06,$0e,$02,  $06,$0c,$02,  $06,$0d,$02,  $06,$0c,$02,  $00,$00,$00
SfxAstronautDead
    .byte $06,$0c,$02,  $06,$0d,$02,  $06,$0c,$02,  $06,$0e,$02,  $06,$0d,$02,  $06,$0f,$02,  $06,$0e,$02,  $06,$10,$02,  $06,$0f,$02,  $00,$00,$00
SfxMyFire
	.byte $03,$03,$01,  $06,$1a,$01,  $03,$05,$01,  $06,$0a,$01,  $03,$07,$01,  $03,$09,$01,  $03,$0b,$01,  $03,$0d,$01,  $03,$0f,$01,  $03,$11,$01,  $03,$13,$01,  $03,$15,$01,  $00,$00,$00
SfxDamageMyRobot
	.byte $0f,$1f,$02,  $0e,$01,$02,  $0f,$19,$02,  $0e,$03,$01,  $08,$1a,$01,  $0e,$07,$01,  $08,$1d,$01,  $00,$00,$00
SfxHitSmartBomb
	.byte $06,$04,$03,  $06,$03,$03,  $06,$04,$03,  $06,$03,$03,  $06,$02,$03,  $06,$05,$03,  $06,$02,$02,  $00,$00,$00
SfxHitEnergy
    .byte $06,$03,$02,  $06,$01,$02,  $06,$03,$02,  $06,$05,$02,  $06,$03,$02,  $06,$05,$02,  $06,$07,$02,  $06,$05,$02,  $06,$07,$02,  $00,$00,$00
IntroSongCh0
    .byte $06,$05,$30,  $06,$02,$30,  $06,$05,$08,  $00,$00,$00
IntroSongCh1
    .byte $06,$07,$06,  $06,$08,$06,  $06,$07,$06,  $06,$08,$06,  $06,$07,$06,  $06,$08,$06,  $06,$07,$06,  $06,$08,$06
    .byte $06,$07,$06,  $06,$08,$06,  $06,$07,$06,  $06,$08,$06,  $06,$07,$06,  $06,$08,$06,  $06,$07,$06,  $06,$08,$06
    .byte $06,$08,$08,  $00,$00,$00
SfxLaserSatellite
	.byte $0e,$0e,$01,  $08,$0e,$01,  $06,$0e,$01,  $0e,$0b,$02,  $08,$0b,$02,  $06,$0b,$02,  $0e,$0e,$01,  $08,$0e,$01,  $06,$0e,$01,  $0e,$0e,$02,  $08,$0e,$02,  $00,$00,$00
VictorySongCH0
	.byte $06,$0b,$80,  $06,$0b,$60,  $08,$0b,$03,  $06,$0b,$1e,  $06,$0e,$80,  $06,$0e,$60,  $08,$0b,$03,  $06,$0e,$1e,  $06,$11,$c0,  $06,$10,$40,  $06,$0f,$ff
	.byte $08,$0b,$03,  $06,$0b,$7d
	.byte $00,$00,$00
VictorySongCH1
	.byte $06,$02,$80,  $06,$01,$60,  $06,$02,$1e,  $08,$0b,$03,  $06,$02,$80,  $06,$05,$60,  $06,$04,$1e,  $08,$0b,$03,  $06,$05,$c0,  $06,$04,$40,  $06,$03,$80
	.byte $06,$00,$08,  $06,$01,$08,  $06,$02,$08,  $06,$01,$08,  $06,$00,$08,  $06,$01,$08,  $06,$02,$08,  $06,$01,$0a,  $06,$00,$0c,  $06,$01,$0e,  $06,$02,$12,  $06,$01,$12     
	.byte $06,$02,$80
	.byte $00,$00,$00
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;align $100
Shield0
	.byte $FE ; |XXXXXXX |
	.byte $FE ; |XXXXXXX |
	.byte $FA ; |XXXXX X |
	.byte $F2 ; |XXXX  X |
	.byte $64 ; | XX  X  |
	.byte $28 ; |  X X   |
	.byte $10 ; |   X    |

Shield1
	.byte $47 ; | X   XXX|
	.byte $E7 ; |XXX  XXX|
	.byte $E3 ; |XXX   XX|
	.byte $E3 ; |XXX   XX|
	.byte $E3 ; |XXX   XX|
	.byte $E3 ; |XXX   XX|
	.byte $E3 ; |XXX   XX|

Number0
	.byte $7E ; | XXXXXX |
	.byte $66 ; | XX  XX |
	.byte $66 ; | XX  XX |
	.byte $66 ; | XX  XX |
	.byte $66 ; | XX  XX |
	.byte $66 ; | XX  XX |
	.byte $7E ; | XXXXXX |
Number1
	.byte $38 ; |  XXX   |
	.byte $38 ; |  XXX   |
	.byte $18 ; |   XX   |
	.byte $18 ; |   XX   |
	.byte $18 ; |   XX   |
	.byte $18 ; |   XX   |
	.byte $18 ; |   XX   |
Number2
	.byte $7E ; | XXXXXX |
	.byte $06 ; |     XX |
	.byte $06 ; |     XX |
	.byte $7E ; | XXXXXX |
	.byte $60 ; | XX     |
	.byte $60 ; | XX     |
	.byte $7E ; | XXXXXX |
Number3
	.byte $7E ; | XXXXXX |
	.byte $06 ; |     XX |
	.byte $06 ; |     XX |
	.byte $1E ; |   XXXX |
	.byte $06 ; |     XX |
	.byte $06 ; |     XX |
	.byte $7E ; | XXXXXX |
Number4
	.byte $60 ; | XX     |
	.byte $66 ; | XX  XX |
	.byte $66 ; | XX  XX |
	.byte $7E ; | XXXXXX |
	.byte $06 ; |     XX |
	.byte $06 ; |     XX |
	.byte $06 ; |     XX |
Number5
	.byte $7E ; | XXXXXX |
	.byte $60 ; | XX     |
	.byte $60 ; | XX     |
	.byte $7E ; | XXXXXX |
	.byte $06 ; |     XX |
	.byte $06 ; |     XX |
	.byte $7E ; | XXXXXX |
Number6
	.byte $7E ; | XXXXXX |
	.byte $60 ; | XX     |
	.byte $60 ; | XX     |
	.byte $7E ; | XXXXXX |
	.byte $66 ; | XX  XX |
	.byte $66 ; | XX  XX |
	.byte $7E ; | XXXXXX |
Number7
	.byte $7E ; | XXXXXX |
	.byte $06 ; |     XX |
	.byte $06 ; |     XX |
	.byte $06 ; |     XX |
	.byte $06 ; |     XX |
	.byte $06 ; |     XX |
	.byte $06 ; |     XX |
Number8
	.byte $7E ; | XXXXXX |
	.byte $66 ; | XX  XX |
	.byte $66 ; | XX  XX |
	.byte $7E ; | XXXXXX |
	.byte $66 ; | XX  XX |
	.byte $66 ; | XX  XX |
	.byte $7E ; | XXXXXX |
Number9
	.byte $7E ; | XXXXXX |
	.byte $66 ; | XX  XX |
	.byte $66 ; | XX  XX |
	.byte $7E ; | XXXXXX |
	.byte $06 ; |     XX |
	.byte $06 ; |     XX |
	.byte $7E ; | XXXXXX |
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;align $100
PlayfieldPlanet
	.byte $00,$00,$00 ;|                    | (  0)
	.byte $00,$17,$01 ;|       X XXXX       | (  2)
	.byte $80,$17,$03 ;|   X   X XXXXX      | (  3)
	.byte $C0,$83,$03 ;|  XXX     XXXX      | (  4)
	.byte $C0,$E3,$03 ;|  XXXXX   XXXX      | (  5)
	.byte $C0,$E0,$01 ;|  XXXXX     X       | (  6)
	.byte $E0,$F0,$00 ;| XXXXXXX            | (  7)
	.byte $E0,$F8,$08 ;| XXXXXXXX      X    | (  8)
	.byte $E0,$F8,$0C ;| XXXXXXXX     XX    | (  9)
	.byte $E0,$F9,$06 ;| XXXXXXXX  X XX     | ( 10)
	.byte $C0,$FB,$30 ;|  XXXXXXX XX    XX  | ( 11)
	.byte $C0,$F3,$39 ;|  XXXXXX  XXX  XXX  | ( 12)
	.byte $80,$E7,$7D ;|   XXXX  XXXX XXXXX | ( 13)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Asteroid
	.byte $3C ; |  XXXX  |
	.byte $7A ; | XXXX X |
	.byte $F5 ; |XXXX X X|
	.byte $FB ; |XXXXX XX|
	.byte $FF ; |XXXXXXXX|
	.byte $5B ; | X XX XX|
	.byte $6E ; | XX XXX |
	.byte $3C ; |  XXXX  |
	.byte $00 ; |        |
Enemy0
	.byte $AE ; |X X XXX |
	.byte $1F ; |   XXXXX|
	.byte $16 ; |   X XX |
	.byte $7F ; | XXXXXXX|
	.byte $7F ; | XXXXXXX|
	.byte $16 ; |   X XX |
	.byte $1F ; |   XXXXX|
	.byte $AE ; |X X XXX |
	.byte $00 ; |        |
Enemy1
	.byte $03 ; |      XX|
	.byte $0F ; |    XXXX|
	.byte $3E ; |  XXXXX |
	.byte $7D ; | XXXXX X|
	.byte $EA ; |XXX X X |
	.byte $7D ; | XXXXX X|
	.byte $3E ; |  XXXXX |
	.byte $0F ; |    XXXX|
	.byte $00 ; |        |
Enemy2
	.byte $07 ; |     XXX|
	.byte $FD ; |XXXXXX X|
	.byte $1F ; |   XXXXX|
	.byte $09 ; |    X  X|
	.byte $09 ; |    X  X|
	.byte $1F ; |   XXXXX|
	.byte $FD ; |XXXXXX X|
	.byte $07 ; |     XXX|
	.byte $00 ; |        |
Enemy3
	.byte $FF ; |XXXXXXXX|
	.byte $0e ; |    XXX |
	.byte $1F ; |   XXXXX|
	.byte $36 ; |  XX XX |
	.byte $36 ; |  XX XX |
	.byte $1F ; |   XXXXX|
	.byte $0e ; |    XXX |
	.byte $FF ; |XXXXXXXX|
	.byte $00 ; |        |
Enemy4
	.byte $03 ; |      XX|
	.byte $06 ; |     XX |
	.byte $1E ; |   XXXX |
	.byte $6E ; | XX XXX |
	.byte $F3 ; |XXXX  XX|
	.byte $7E ; | XXXXXX |
	.byte $0E ; |    XXX |
	.byte $03 ; |      XX|
	.byte $00 ; |        |
Enemy5
	.byte $18 ; |   XX   |
	.byte $34 ; |  XX X  |
	.byte $7A ; | XXXX X |
	.byte $7E ; | XXXXXX |
	.byte $FF ; |XXXXXXXX|
	.byte $BF ; |X XXXXXX|
	.byte $4E ; | X  XXX |
	.byte $3C ; |  XXXX  |
	.byte $00 ; |        |
Enemy6
	.byte $7F ; | XXXXXXX|
	.byte $8E ; |X   XXX |
	.byte $1C ; |   XXX  |
	.byte $1E ; |   XXXX |
	.byte $1E ; |   XXXX |
	.byte $1C ; |   XXX  |
	.byte $8E ; |X   XXX |
	.byte $7F ; | XXXXXXX|
	.byte $00 ; |        |
Energy
	.byte $00 ; |        |
	.byte $BD ; |X XXXX X|
	.byte $C3 ; |XX    XX|
	.byte $5E ; | X XXXX |
	.byte $C7 ; |XX   XXX|
	.byte $5E ; | X XXXX |
	.byte $C3 ; |XX    XX|
	.byte $BD ; |X XXXX X|
	.byte $00 ; |        |
AstronautFrame0
	.byte $18 ; |   XX   |
	.byte $18 ; |   XX   |
	.byte $02 ; |      X |
	.byte $7C ; | XXXXX  |
	.byte $18 ; |   XX   |
	.byte $38 ; |  XXX   |
	.byte $28 ; |  X X   |
	.byte $08 ; |    X   |
	.byte $00 ; |        |
AstronautFrame1
	.byte $18 ; |   XX   |
	.byte $18 ; |   XX   |
	.byte $40 ; | X      |
	.byte $3E ; |  XXXXX |
	.byte $18 ; |   XX   |
	.byte $18 ; |   XX   |
	.byte $28 ; |  X X   |
	.byte $20 ; |  X     |
	.byte $00 ; |        |
SmartBomb
	.byte $00 ; |        |
	.byte $1D ; |   XXX X|
	.byte $73 ; | XXX  XX|
	.byte $EE ; |XXX XXX |
	.byte $E3 ; |XXX   XX|
	.byte $FA ; |XXXXX X |
	.byte $67 ; | XX  XXX|
	.byte $1D ; |   XXX X|
	.byte $00 ; |        |
Satellite
	.byte $FC ; |XXXXXX  |
	.byte $FD ; |XXXXXX X|
	.byte $FF ; |XXXXXXXX|
	.byte $FD ; |XXXXXX X|
	.byte $FD ; |XXXXXX X|
	.byte $03 ; |      XX|
	.byte $07 ; |     XXX|
	.byte $00 ; |        |

ColorAsteroid
    .byte $Fc
    .byte $Fc
    .byte $Fc
    .byte $Fc
    .byte $Fc
    .byte $Fc
    .byte $Fc
    .byte $Fc
	.byte $00
ColorEnemy0
	.byte $0C
	.byte $0E
	.byte $0C
	.byte $0C
	.byte $0C
	.byte $0C
	.byte $0E
	.byte $0C
	.byte $00
ColorEnemy1
    .byte $04
    .byte $04
    .byte $04
    .byte $04
    .byte $2F
    .byte $04
    .byte $04
    .byte $04
	.byte $00
ColorEnemy2
	.byte $0C
	.byte $0A
	.byte $08
	.byte $08
	.byte $08
	.byte $08
	.byte $0A
	.byte $0C
	.byte $00
ColorEnemy3
	.byte $02
	.byte $08
	.byte $08
	.byte $08
	.byte $08
	.byte $08
	.byte $08
	.byte $02
	.byte $00
ColorEnemy4
	.byte $08
	.byte $04
	.byte $04
	.byte $0C
	.byte $0A
	.byte $04
	.byte $04
	.byte $08
	.byte $00
ColorEnemy5
	.byte $0C
	.byte $0C
	.byte $0C
	.byte $0C
	.byte $0E
	.byte $08
	.byte $08
	.byte $08
	.byte $00
ColorEnemy6
    .byte $0C
    .byte $06
    .byte $04
    .byte $04
    .byte $04
    .byte $04
    .byte $06
    .byte $0C
	.byte $00
ColorEnergy
	.byte $00
	.byte $0E
	.byte $0C
	.byte $0C
	.byte $0A
	.byte $0A
	.byte $08
	.byte $08
	.byte $00
ColorAstronaut
	.byte $0E
	.byte $0E
	.byte $0E
	.byte $0E
	.byte $0E
	.byte $0E
	.byte $0E
	.byte $0E
	.byte $00
ColorSmartBomb
	.byte $00
	.byte $0A
	.byte $0E
	.byte $0E
	.byte $0E
	.byte $0E
	.byte $0E
	.byte $0C
	.byte $00
ColorSatellite
	.byte $0A
	.byte $02
	.byte $02
	.byte $02
	.byte $02
	.byte $0E
	.byte $0E
	.byte $00
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;YOU LOST chars
char_0
	.byte $05 ; |     X X|
	.byte $05 ; |     X X|
	.byte $05 ; |     X X|
	.byte $05 ; |     X X|
	.byte $02 ; |      X |
	.byte $02 ; |      X |
	.byte $02 ; |      X |
char_1
	.byte $EA ; |XXX X X |
	.byte $AA ; |X X X X |
	.byte $AA ; |X X X X |
	.byte $AA ; |X X X X |
	.byte $AA ; |X X X X |
	.byte $AA ; |X X X X |
	.byte $EE ; |XXX XXX |
char_2
	.byte $47 ; | X   XXX|
	.byte $45 ; | X   X X|
	.byte $45 ; | X   X X|
	.byte $45 ; | X   X X|
	.byte $45 ; | X   X X|
	.byte $45 ; | X   X X|
	.byte $77 ; | XXX XXX|
char_3
	.byte $EE ; |XXX XXX |
	.byte $84 ; |X    X  |
	.byte $84 ; |X    X  |
	.byte $E4 ; |XXX  X  |
	.byte $24 ; |  X  X  |
	.byte $24 ; |  X  X  |
	.byte $E4 ; |XXX  X  |
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	align $100
logo_0
	.byte %00000000
	.byte %11101110
	.byte %10100010
	.byte %11101110
	.byte %10001010
	.byte %10001010
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00111000
	.byte %00000000
	.byte %00111000
	.byte %00000000
	.byte %00111000
	.byte %00000000
	.byte %00111000
	.byte %00000000
	.byte %00111000
	.byte %00000000
	.byte %00111000
	.byte %00000000
	.byte %11111110
	.byte %00000000
	.byte %11111110
logo_1
	.byte %00000000
	.byte %01110101
	.byte %01000100
	.byte %01000101
	.byte %01000101
	.byte %01110101
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %11111101
	.byte %00000000
	.byte %11111101
	.byte %00000000
	.byte %11000001
	.byte %00000000
	.byte %11111001
	.byte %00000000
	.byte %11111001
	.byte %00000000
	.byte %11000001
	.byte %00000000
	.byte %11111101
	.byte %00000000
	.byte %11111101
logo_2
	.byte %00000000
	.byte %11010101
	.byte %01010101
	.byte %11011101
	.byte %00010101
	.byte %11011101
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %10001101
	.byte %00000000
	.byte %10001101
	.byte %00000000
	.byte %10001101
	.byte %00000000
	.byte %11111001
	.byte %00000000
	.byte %11111101
	.byte %00000000
	.byte %10001101
	.byte %00000000
	.byte %11111101
	.byte %00000000
	.byte %11111001
logo_3
	.byte %00000000
	.byte %01011100
	.byte %01010100
	.byte %01010100
	.byte %01010100
	.byte %11011100
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %10001101
	.byte %00000000
	.byte %10001101
	.byte %00000000
	.byte %10001101
	.byte %00000000
	.byte %11111001
	.byte %00000000
	.byte %11111101
	.byte %00000000
	.byte %10001101
	.byte %00000000
	.byte %11111101
	.byte %00000000
	.byte %11111000
logo_4
	.byte %00000000
	.byte %01110111
	.byte %01000101
	.byte %01110101
	.byte %00010101
	.byte %01110111
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %10001100
	.byte %00000000
	.byte %10001100
	.byte %00000000
	.byte %10001100
	.byte %00000000
	.byte %11111100
	.byte %00000000
	.byte %11111100
	.byte %00000000
	.byte %10001101
	.byte %00000000
	.byte %11111101
	.byte %00000000
	.byte %11111001
logo_5
	.byte %00000000
	.byte %01110001
	.byte %01000001
	.byte %01110111
	.byte %00010101
	.byte %01110100
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00111000
	.byte %00000000
	.byte %00111000
	.byte %00000000
	.byte %00111000
	.byte %00000000
	.byte %00011100
	.byte %00000000
	.byte %00011100
	.byte %00000000
	.byte %11001110
	.byte %00000000
	.byte %11111111
	.byte %00000000
	.byte %11111111
	
	.byte %00000000
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	org $fffc
	.word Start
	.word Start


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

    MAC JOYSTICK_MACRO
CheckJoy0Left
    lda CoordXMyRobot
    cmp #LEFT_LIMIT_MYROBOT
    beq CheckJoy0Right
    
    lda #%01000000 ;left?
    bit SWCHA
    bne CheckJoy0Right
    dec CoordXMyRobot
    jmp CheckJoy0Up
CheckJoy0Right
    lda CoordXMyRobot 
    cmp #RIGHT_LIMIT_MYROBOT
    beq CheckJoy0Up
    
    lda #%10000000 ;right?
    bit SWCHA
    bne CheckJoy0Up
    inc CoordXMyRobot
CheckJoy0Up
    lda CoordYMyRobot 
    cmp #UP_LIMIT_MYROBOT
    beq CheckJoy0Down
    
    lda #%00010000 ;up?
    bit SWCHA
    bne CheckJoy0Down
    dec CoordYMyRobot
    jmp CheckFire
CheckJoy0Down
    lda CoordYMyRobot 
    cmp #DOWN_LIMIT_MYROBOT
    beq CheckFire
    
    lda #%00100000 ;down?
    bit SWCHA
    bne CheckFire
    inc CoordYMyRobot
CheckFire
    lda #%10000000 ;fire?
    bit INPT4
    bne preEndJoy0 ;no pressed then set EventFireButtonUp to false
    
    lda BooleanMissileMyRobotIsRunning ;check if missile0 is running
    ;bne EndJoy0 ;if already running then exit
    
    ora EventFireButtonUp
    bne EndJoy0
    
    lda #0
    sta RESMP0 ;missile0 unlocked from P0
    ;lda CoordXMyRobot ;missile starts where the robot IS
    ;sta CoordXMyMissile
    lda #1 ;if not running..
    sta BooleanMissileMyRobotIsRunning ;set it is running now
    sta EventFireButtonUp ;set true button pressed
    sta MyFire ;set Sfx
    jmp EndJoy0
preEndJoy0
    lda BooleanMissileMyRobotIsRunning ;set EventFireButtonUp
    bne EndJoy0 ;only with no missile on screen
    lda #0 ;no missile then
    sta EventFireButtonUp ;set false because no pressed
EndJoy0
    ENDM
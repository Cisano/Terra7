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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    MAC DEF_NUMBERS_POINTERS_MACRO
    sta WSYNC
    sta HMOVE
    
    ldx #2 ;2 copies
    
    lda BooleanGameOver
    cmp #%00000111 ;if Game Over with Laser no flash battery
    beq .setGRP
    and #%00000011 ;if game over message you lost not flashing
    bne .setGRP
    
    lda BatteryCharging
    cmp #NUM_BATTERIES
    bne .setGRP
    ;flashing battery
    lda TimerForAll
    and #%00010000 ;change every 16 tv frames
    beq .setGRP
    ldx #0 ;1 copy
.setGRP
    sta WSYNC
    stx NUSIZ1     ;2 copies
    stx NUSIZ0     ;2 copies
    
    ldy ShieldNumber
    lda TablePtrNumberLow,y
    sta PointerMultiUseTwoLow
    lda TablePtrNumberHi,y
    sta PointerMultiUseTwoHi
    ;at 10 the table point to 0
    ldy BatteryCharging
    lda TablePtrNumberLow,y
    sta PointerMultiUseOneLow
    lda TablePtrNumberHi,y
    sta PointerMultiUseOneHi
    
    ENDM

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    MAC SHOW_ENERGY_MACRO
    sta WSYNC
    SLEEP 19
    lda (PointerMultiUseOneLow),y
    tax
    lda Shield0,y
    sta GRP0
    lda (PointerMultiUseTwoLow),y
    sta GRP1
    
    lda Shield1,y
    and MaskDecimalBattery
    sta GRP0
    stx GRP1
    iny
    ENDM

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    MAC SHOW_MESSAGE_MACRO
    sta WSYNC   
    SLEEP 19
    lda char_3,y
    tax
    lda char_0,y
    sta GRP0
    lda char_1,y
    sta GRP1
    
    lda char_2,y
    sta GRP0
    stx GRP1
    iny
    ENDM
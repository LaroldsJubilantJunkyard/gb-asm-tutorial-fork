
; ANCHOR: bullets-top
include "src/main/utils/hardware.inc"
include "src/main/utils/constants.inc"

SECTION "ObjectsGetter", ROM0

GetSpeedByteInB::
    push hl

    ; move to the speed byte
    ld a, l
    add a, object_speedByte
    ld l, a

    ; store the speed value in b
    ld a, [hl]
    ld b, a
    pop hl

    ret


GetObjectAtHLIsOutOfBounds::
    push bc
    push hl

    ; move to the y low byte
    ld a, l
    add a, object_yLowByte
    ld l, a


    ; Get the y position
    ld a, [hli]
    ld b,a
    ld a, [hl]
    ld c,a
    
    ; Descale our y position
    REPT 4
    srl c
    rr b
    ENDR
   
    ld a, b

    pop hl
    pop bc


    cp a, 200

    ret

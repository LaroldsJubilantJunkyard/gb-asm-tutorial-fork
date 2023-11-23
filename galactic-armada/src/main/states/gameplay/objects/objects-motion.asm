
; ANCHOR: bullets-top
include "src/main/utils/hardware.inc"
include "src/main/utils/constants.inc"

SECTION "ObjectsMotion", ROM0

MoveObjectAtHL_Up::

    ; Remember the starting address for the object
    push bc

    call GetSpeedByteInB

    push hl

    ; move to the speed byte
    ld a, l
    add a, object_yLowByte
    ld l, a

    jp Decrease

MoveObjectAtHL_Down::

    ; Remember the starting address for the object
    push bc

    call GetSpeedByteInB

    push hl

    ; move to the speed byte
    ld a, l
    add a, object_yLowByte
    ld l, a

    jp Increase

MoveObjectAtHL_Left::

    ; Remember the starting address for the object
    push bc

    call GetSpeedByteInB

    push hl

    ; move to the x low byte
    inc hl 

    jp Decrease

MoveObjectAtHL_Right::

    ; Remember the starting address for the object
    push bc

    call GetSpeedByteInB

    push hl

    ; move to the x low byte
    inc hl 

    jp Increase

Increase:

    ; decrease the value in the low byte by 'b'
    ld a, [hl]
    add a, b
    ld [hli], a

    ; decrease the value in the high byte by tyhe carry over from the previous
    ld a, [hl]
    adc a,0
    ld [hl], a

    jp EndMove

Decrease:

    ; decrease the value in the low byte by 'b'
    ld a, [hl]
    sub a, b
    ld [hli], a

    ; decrease the value in the high byte by tyhe carry over from the previous
    ld a, [hl]
    sbc a,0
    ld [hl], a

EndMove:

    ; return to the front of the object
    pop hl
    pop bc

    ret
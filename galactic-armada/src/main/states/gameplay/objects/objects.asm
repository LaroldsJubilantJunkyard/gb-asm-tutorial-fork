
; ANCHOR: bullets-top
include "src/main/utils/hardware.inc"
include "src/main/utils/constants.inc"

SECTION "Objects", ROM0

InitializeObjectAtHL::

   
    ld a, 0
    ld [hli], a ;  active byte
    ld [hli], a  ; x byte (low)
    ld [hli], a  ; x byte (high)
    ld [hli], a  ; y byte (low)
    ld [hli], a  ; y byte (high)
    ld [hli], a  ; metasprite byte (low)
    ld [hli], a  ; metasprite byte (high)
    ld [hli], a  ; speed
    ld [hli], a  ; health

    ret;

SetObjectAtHL_SpeedInB::

    push bc
    push hl

    ; move to the speed byte
    ld a, l
    add a, object_speedByte
    ld l, a

    ld a, b
    ld [hl], a

    pop hl
    pop bc

    ret;

SetObjectAtHL_MetaspriteInDE::

    push de
    push hl

    ; move to the metasprite low byte
    ld a, l
    add a, object_metaspriteLowByte
    ld l, a

    ld a, d
    ld [hli], a

    ld a, e
    ld [hli], a

    pop hl
    pop de

    ret;

PlaceObjectAtHL_YPositionDE::

    push de
    push hl

    ; move to the metasprite low byte
    inc hl 
    inc hl 
    inc hl 


    ld a, d
    ld [hli], a

    ld a, e
    ld [hli], a

    pop hl
    pop de

    ret;

PlaceObjectAtHL_XPositionDE::

    push de
    push hl

    ; move to the x low byte
    inc hl 

    ld a, d
    ld [hli], a

    ld a, e
    ld [hli], a

    pop hl
    pop de

    ret;

GetSpeedByteInB:
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

DrawObjectAtHL::

    push hl

    ld a, l
    add a, object_metaspriteLowByte
    ld l, a


    ; Save the address of the metasprite into the 'wMetaspriteAddress' variable
    ; Our DrawMetasprites functoin uses that variable
    ld a, [hli]
    ld [wMetaspriteAddress+0], a
    ld a, [hli]
    ld [wMetaspriteAddress+1], a



    pop hl
    push hl
    
    inc hl


    ; Save the x position
    ld a, [hli]
    ld c,a
    ld a, [hli]
    ld d,a

    ; Descale our xposition
    REPT 4
    srl d
    rr c
    ENDR

    ld a, c
    ld [wMetaspriteX],a

    ; Save the y position
    ld a, [hli]
    ld c,a
    ld a, [hl]
    ld d,a

    
    ; Descale our y position
    REPT 4
    srl d
    rr c
    ENDR

    ld a, c
    ld [wMetaspriteY],a

    ; Actually call the 'DrawMetasprites function
    call DrawMetasprites;

    pop hl

    ret
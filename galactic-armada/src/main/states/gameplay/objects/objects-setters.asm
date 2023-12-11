
; ANCHOR: bullets-top
include "src/main/utils/hardware.inc"
include "src/main/utils/constants.inc"

SECTION "ObjectsSetter", ROM0

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


    
; Damage the object at hl
DamageObjectAtHL::

    push hl

    ld a, l
    add a, object_damageByte
    ld l, a

    ld a, 40
    ld [hl], a

    pop hl

    push hl

    ld a, l
    add a, object_healthByte
    ld l, a

    ld a, [hl]
    cp a
    jp z, DamageObjectAtHL_Done

    ; Decrease and update
    dec a
    ld [hl], a

DamageObjectAtHL_Done:

    pop hl

    ret
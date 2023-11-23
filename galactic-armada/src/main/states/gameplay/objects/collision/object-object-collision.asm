
; ANCHOR: enemy-bullet-collision-start
include "src/main/utils/hardware.inc"
include "src/main/utils/constants.inc"
include "src/main/utils/hardware.inc"


SECTION "ObjectObjectCollisionVariables", WRAM0


SECTION "ObjectObjectCollision", ROM0

CheckObjectAtHLAgainstObjectAtDE::

    ld a,0
    ld [wSize], a

GetObject1X:

    push de
    push hl

    ld a, l
    add a, object_xLowByte
    ld l, a

    ld a,[hli]
    ld d,a

    ld a,[hl]
    ld e,a

    srl e
    rr d
    srl e
    rr d
    srl e
    rr d
    srl e
    rr d

    ld a, d
    ld [wObject1Value], a

    pop hl
    pop de

GetObject1HalfWidth:

    push de
    push hl

    ld a, l
    add a, object_halfWidthByte
    ld l, a

    ld a, [hl]
    ld [wSize], a

    pop hl
    pop de

GetObject2X:

    push hl

    ; copy de to hl
    push de
    pop hl

    ld a, l
    add a, object_xLowByte
    ld l, a

    ld a,[hli]
    ld d,a

    ld a,[hl]
    ld e,a

    srl e
    rr d
    srl e
    rr d
    srl e
    rr d
    srl e
    rr d

    ld a, d
    ld [wObject2Value], a
    
    pop hl

GetObject2HalfWidth:

    push de
    push hl

    ; copy de to hl
    push de
    pop hl

    ld a, l
    add a, object_halfWidthByte
    ld l, a

    ld a, [wSize]
    ld b, a
    ld a, [hl]
    add a, b
    ld [wSize], a

    pop hl
    pop de


CheckDifferences:

    call CheckObjectPositionDifference

    ld a, [wResult]
    cp a, 0
    jp z, NoCollision

CheckYAxis:


    ld a,0
    ld [wSize], a

GetObject1Y:

    push de
    push hl

    ld a, l
    add a, object_yLowByte
    ld l, a

    ld a,[hli]
    ld d,a

    ld a,[hl]
    ld e,a

    srl e
    rr d
    srl e
    rr d
    srl e
    rr d
    srl e
    rr d

    ld a, d
    ld [wObject1Value], a

    pop hl
    pop de

GetObject1HalfHeight:

    push de
    push hl

    ld a, l
    add a, object_halfHeightByte
    ld l, a

    ld a, [hl]
    ld [wSize], a

    pop hl
    pop de

GetObject2Y:

    push hl

    ; copy de to hl
    push de
    pop hl

    ld a, l
    add a, object_yLowByte
    ld l, a

    ld a,[hli]
    ld d,a

    ld a,[hl]
    ld e,a

    srl e
    rr d
    srl e
    rr d
    srl e
    rr d
    srl e
    rr d

    ld a, d
    ld [wObject2Value], a
    
    pop hl

GetObject2HalfHeight:

    push de
    push hl

    ; copy de to hl
    push de
    pop hl

    ld a, l
    add a, object_halfHeightByte
    ld l, a

    ld a, [wSize]
    ld b, a
    ld a, [hl]
    add a, b
    ld [wSize], a

    pop hl
    pop de


CheckDifferences2:

    call CheckObjectPositionDifference

    ld a, [wResult]
    cp a, 0
    jp z, NoCollision

    ld a, 1
    cp a

    ret
    
NoCollision::

    ld a, 0
    cp a
    ret

; ANCHOR_END: result
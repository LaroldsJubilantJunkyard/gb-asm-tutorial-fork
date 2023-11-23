
; ANCHOR: bullets-top
include "src/main/utils/hardware.inc"
include "src/main/utils/constants.inc"

SECTION "Objects", ROM0

InitializeObjectAtHL::

    push hl
   
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
    ld [hli], a  ; damage

    pop hl

    ret;

DrawObjectAtHL::

    push hl

DrawObjectAtHL_CheckDamaged:

    ld a, l
    add a, object_damageByte
    ld l, a
    
    ld a, [hl]
    cp a
    jp z, DrawObjectAtHL_Draw

    ; Decrease and update the variable
    dec a
    ld [hl], a

    ld a, [mGlobalIsVisibleDuringFlashing]
    cp a
    jp nz, DrawObjectAtHL_Draw

    pop hl
    ret z


DrawObjectAtHL_Draw:

    pop hl
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
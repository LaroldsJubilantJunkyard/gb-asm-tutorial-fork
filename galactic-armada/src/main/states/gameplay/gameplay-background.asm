; ANCHOR: gameplay-background-initialize
INCLUDE "src/main/utils/hardware.inc"
INCLUDE "src/main/utils/macros/text-macros.inc"

SECTION "BackgroundVariables", WRAM0

mBackgroundScroll:: dw

SECTION "GameplayBackgroundSection", ROM0

InitializeBackgroundAndProgressCurrentWaveItem::

	; Get the address of the current wave item type
	ld a, [wCurrentWaveItem]
	ld h, a
	ld a, [wCurrentWaveItem+1]
	ld l, a

	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a

	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	
	push hl

	; Copy the tilemap
	ld hl, $9340
    call CopyDEintoMemoryAtHL

	pop hl

	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a

	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a

	; Update our current wave item
	ld a, h
	ld  [wCurrentWaveItem], a
	ld a, l
	ld [wCurrentWaveItem+1], a

	; Copy the tilemap
	ld hl, $9800
    call CopyDEintoMemoryAtHL_With52Offset

	ld a, 0
	ld [mBackgroundScroll+0],a
	ld a, 0
	ld [mBackgroundScroll+1],a

	ret
; ANCHOR_END: gameplay-background-initialize

; ANCHOR: gameplay-background-update-start
; This is called during gameplay state on every frame
UpdateBackground::

	; Increase our scaled integer by 5
	; Get our true (non-scaled) value, and save it for later usage in bc
	ld a , [mBackgroundScroll+0]
	add a , 5
    ld b,a
	ld [mBackgroundScroll+0], a
	ld a , [mBackgroundScroll+1]
	adc a , 0
    ld c,a
	ld [mBackgroundScroll+1], a
; ANCHOR_END: gameplay-background-update-start

; ANCHOR: gameplay-background-update-end
    ; Descale our scaled integer 
    ; shift bits to the right 4 spaces
    srl c
    rr b
    srl c
    rr b
    srl c
    rr b
    srl c
    rr b

    ; Use the de-scaled low byte as the backgrounds position
    ld a,b
	ld [rSCY], a

	ret
; ANCHOR_END: gameplay-background-update-end
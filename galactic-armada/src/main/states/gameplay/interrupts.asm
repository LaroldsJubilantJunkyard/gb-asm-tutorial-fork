
; ANCHOR: interrupts-start
INCLUDE "src/main/utils/hardware.inc"
INCLUDE "src/main/utils/macros/wave-macros.inc"

 SECTION "Interrupts", ROM0

 DisableInterrupts::
	ld a, 0
	ldh [rSTAT], a
	di
	ret

InitStatInterrupts::

    ld a, IEF_STAT
	ldh [rIE], a
	xor a, a ; This is equivalent to `ld a, 0`!
	ldh [rIF], a
	ei

	; This makes our stat interrupts occur when the current scanline is equal to the rLYC register
	ld a, STATF_LYC
	ldh [rSTAT], a

	; We'll start with the first scanline
	; The first stat interrupt will call the next time rLY = 0
	ld a, 0
	ldh [rLYC], a

    ret
; ANCHOR_END: interrupts-start

; ANCHOR: interrupts-section
; Define a new section and hard-code it to be at $0048.
SECTION "Stat Interrupt", ROM0[$0048]
StatInterrupt:

	push af
	push hl

	; Check if we are on the first scanline
	ldh a, [rLYC]
	cp 0
	jp z, LYCEqualsZero

	
LYCEqualsNotEqualsZero:

	; Get the address of the current wave item type
	ld a, [wCurrentWaveItem]
	ld h, a
	ld a, [wCurrentWaveItem+1]
	ld l, a

	; if it's an level end type
	ld a, [hl]
	cp a, WAVE_DEFINITION
	jp z, LYCEqualsNotEqualsZero_DefaultGameplay

	; Don't call the next stat interrupt until scanline 8
	ld a, 0
	ldh [rLYC], a

	; Turn the LCD on including sprites. But no window
	ld a, LCDCF_ON | LCDCF_BGON | LCDCF_WINON | LCDCF_WIN9C00
	ldh [rLCDC], a

	jp EndStatInterrupts

LYCEqualsNotEqualsZero_DefaultGameplay:

	; Don't call the next stat interrupt until scanline 8
	ld a, 0
	ldh [rLYC], a

	; Turn the LCD on including sprites. But no window
	ld a, LCDCF_ON | LCDCF_BGON | LCDCF_OBJON | LCDCF_OBJ16 | LCDCF_WINOFF | LCDCF_WIN9C00
	ldh [rLCDC], a

	jp EndStatInterrupts

LYCEqualsZero:



	; Get the address of the current wave item type
	ld a, [wCurrentWaveItem]
	ld h, a
	ld a, [wCurrentWaveItem+1]
	ld l, a

	; if it's an level end type
	ld a, [hl]
	cp a, WAVE_DEFINITION
	jp z, LYCEqualsZero_DefaultGameplayHUD

LYCEqualsZero_DialgoueGameplayHUD:


	; Don't call the next stat interrupt until the top of the window
	ld a, [rWY]
	ldh [rLYC], a


	; Turn the LCD on including the window. But no sprites
	ld a, LCDCF_ON | LCDCF_BGON | LCDCF_OBJON | LCDCF_OBJ16| LCDCF_WINOFF
	ldh [rLCDC], a
	
	jp EndStatInterrupts
	
LYCEqualsZero_DefaultGameplayHUD:

	; Don't call the next stat interrupt until scanline 8
	ld a, 7
	ldh [rLYC], a

	; Turn the LCD on including the window. But no sprites
	ld a, LCDCF_ON | LCDCF_BGON | LCDCF_OBJOFF | LCDCF_OBJ16| LCDCF_WINON | LCDCF_WIN9C00
	ldh [rLCDC], a


EndStatInterrupts:

	pop hl
	pop af

	reti;
; ANCHOR_END: interrupts-section
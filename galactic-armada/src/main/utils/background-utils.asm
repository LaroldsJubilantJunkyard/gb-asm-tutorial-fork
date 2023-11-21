; ANCHOR: background-utils
include "src/main/utils/hardware.inc"

SECTION "Background", ROM0



HalfClearBackground::

	call WaitForVBlankStart

	; Turn the LCD off
	ld a, 0
	ld [rLCDC], a

	ld bc,256
	ld hl, $9920

	jp ClearBackgroundLoop

ClearBackground::

	call WaitForVBlankStart

	; Turn the LCD off
	ld a, 0
	ld [rLCDC], a


	ld bc,1024
	ld hl, $9800

ClearBackgroundLoop:

	ld a,0
	ld [hli], a
	
	dec bc
	ld a, b
	or a, c

	jp nz, ClearBackgroundLoop

	; Turn the LCD on
	ld a, LCDCF_ON  | LCDCF_BGON|LCDCF_OBJON | LCDCF_OBJ16
	ld [rLCDC], A
	ret
; ANCHOR_END: background-utils



ClearWindow::

	call WaitForVBlankStart

	; Turn the LCD off
	ld a, 0
	ld [rLCDC], a


	ld bc,1024
	ld hl, _SCRN1

ClearWindowLoop:

	ld a,0
	ld [hli], a
	
	dec bc
	ld a, b
	or a, c

	jp nz, ClearWindowLoop

	; Turn the LCD on
	ld a, LCDCF_ON  | LCDCF_BGON|LCDCF_OBJON | LCDCF_OBJ16 | LCDCF_WINON | LCDCF_WIN9C00|LCDCF_BG9800
	ld [rLCDC], A
	ret
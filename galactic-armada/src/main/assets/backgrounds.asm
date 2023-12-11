
INCLUDE "src/main/utils/hardware.inc"
SECTION "Backgrounds",  ROM0

ljjSplashScreenTileData: INCBIN "src/generated/backgrounds/ljj-splash-screen.2bpp"
ljjSplashScreenTileDataEnd:
 
ljjSplashScreenTileMap: INCBIN "src/generated/backgrounds/ljj-splash-screen.tilemap"
ljjSplashScreenTileMapEnd:

DrawLaroldsJubilantJunkyardSplashScreen::

    ; Copy the tile data
	ld de, ljjSplashScreenTileData ; de contains the address where data will be copied from;
	ld hl, $9000 ; hl contains the address where data will be copied to;
	ld bc, ljjSplashScreenTileDataEnd - ljjSplashScreenTileData ; bc contains how many bytes we have to copy.
	call CopyDEintoMemoryAtHL;
	
	; Copy the tilemap
	ld de, ljjSplashScreenTileMap ; de contains the address where data will be copied from;
	ld hl, $9800 ; hl contains the address where data will be copied to;
	ld bc, ljjSplashScreenTileMapEnd - ljjSplashScreenTileMap ; bc contains how many bytes we have to copy.
	call CopyDEintoMemoryAtHL
	
	ret

titleScreenTileData: INCBIN "src/generated/backgrounds/title-screen.2bpp"
titleScreenTileDataEnd:
 
titleScreenTileMap: INCBIN "src/generated/backgrounds/title-screen.tilemap"
titleScreenTileMapEnd:

DrawTitleScreen::

    ; Copy the tile data
	ld de, titleScreenTileData ; de contains the address where data will be copied from;
	ld hl, $9340 ; hl contains the address where data will be copied to;
	ld bc, titleScreenTileDataEnd - titleScreenTileData ; bc contains how many bytes we have to copy.
	call CopyDEintoMemoryAtHL;
	
	; Copy the tilemap
	ld de, titleScreenTileMap ; de contains the address where data will be copied from;
	ld hl, $9800 ; hl contains the address where data will be copied to;
	ld bc, titleScreenTileMapEnd - titleScreenTileMap ; bc contains how many bytes we have to copy.
	call CopyDEintoMemoryAtHL_With52Offset

	ret
; ANCHOR_END: draw-title-screen

starFieldMap:: INCBIN "src/generated/backgrounds/star-field.tilemap"
starFieldMapEnd::
 
starFieldTileData:: INCBIN "src/generated/backgrounds/star-field.2bpp"
starFieldTileDataEnd::

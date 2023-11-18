
SECTION "Backgrounds", ROM0
 

	
; ANCHOR: draw-title-screen

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

starFieldMap: INCBIN "src/generated/backgrounds/star-field.tilemap"
starFieldMapEnd:
 
starFieldTileData: INCBIN "src/generated/backgrounds/star-field.2bpp"
starFieldTileDataEnd:

DrawStarField::

	; Copy the tile data
	ld de, starFieldTileData ; de contains the address where data will be copied from;
	ld hl, $9340 ; hl contains the address where data will be copied to;
	ld bc, starFieldTileDataEnd - starFieldTileData ; bc contains how many bytes we have to copy.
    call CopyDEintoMemoryAtHL

	; Copy the tilemap
	ld de, starFieldMap
	ld hl, $9800
	ld bc, starFieldMapEnd - starFieldMap
    call CopyDEintoMemoryAtHL_With52Offset

    ret
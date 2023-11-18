MACRO SetTilesAndShowTilemap

    ; Copy the tile data
	ld de, \1 ; de contains the address where data will be copied from;
	ld hl, $9340 ; hl contains the address where data will be copied to;
	ld bc, \2 - \1 ; bc contains how many bytes we have to copy.
	call CopyDEintoMemoryAtHL;
	
	; Copy the tilemap
	ld de, \3
	ld hl, $9800
	ld bc, \4 - \3
	call CopyDEintoMemoryAtHL_With52Offset

    ENDM
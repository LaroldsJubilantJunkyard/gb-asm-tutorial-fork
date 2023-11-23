

; ANCHOR: bullets-top
include "src/main/utils/hardware.inc"
include "src/main/utils/constants.inc"


SECTION "Sprites", ROM0

bulletTileData:: INCBIN "src/generated/sprites/bullet.2bpp"
bulletTileDataEnd::


AddBulletTileDataToVRAM::
    
    ; Copy the bullet tile data intto vram
	ld de, bulletTileData
	ld hl, BULLET_TILES_START
	ld bc, bulletTileDataEnd - bulletTileData
    call CopyDEintoMemoryAtHL

    ret
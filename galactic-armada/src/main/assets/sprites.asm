

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

enemyShipTileData:: INCBIN "src/generated/sprites/enemy-ship.2bpp"
enemyShipTileDataEnd::

AddEnemyTileDataToVRAM::
    ld de, enemyShipTileData
	ld hl, ENEMY_TILES_START
	ld bc, enemyShipTileDataEnd - enemyShipTileData
    call CopyDEintoMemoryAtHL
    ret

playerShipTileData: INCBIN "src/generated/sprites/player-ship.2bpp"
playerShipTileDataEnd:

    
CopyPlayerTileDataIntoVRAM::
    ; Copy the player's tile data into VRAM
	ld de, playerShipTileData
	ld hl, PLAYER_TILES_START
	ld bc, playerShipTileDataEnd - playerShipTileData
    call CopyDEintoMemoryAtHL

    ret;
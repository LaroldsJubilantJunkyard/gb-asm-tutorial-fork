
include "src/main/utils/hardware.inc"
include "src/main/utils/constants.inc"
SECTION "Metasprites", ROM0

bulletMetasprite::
    .metasprite1    db 0,0,8,0
    .metaspriteEnd  db 128

enemyShipMetasprite::
    .metasprite1    db 0,0,4,0
    .metasprite2    db 0,8,6,0
    .metaspriteEnd  db 128

AddEnemyTileDataToVRAM::
    ld de, enemyShipTileData
	ld hl, ENEMY_TILES_START
	ld bc, enemyShipTileDataEnd - enemyShipTileData
    call CopyDEintoMemoryAtHL
    ret
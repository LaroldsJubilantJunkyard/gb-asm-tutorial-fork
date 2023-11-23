; ANCHOR: player-start
include "src/main/utils/hardware.inc"
include "src/main/utils/hardware.inc"
include "src/main/utils/constants.inc"

SECTION "PlayerVariables", WRAM0

; first byte is low, second is high (little endian)
wPlayerPositionX:: dw
wPlayerPositionY:: dw
wPlayerObject::ds PER_OBJECT_BYTES_COUNT

mPlayerFlash: dw
; ANCHOR_END: player-start
; ANCHOR: player-data
SECTION "Player", ROM0

playerShipTileData: INCBIN "src/generated/sprites/player-ship.2bpp"
playerShipTileDataEnd:

playerTestMetaSprite::
    .metasprite1    db 0,0,0,0
    .metasprite2    db 0,8,2,0
    .metaspriteEnd  db 128
; ANCHOR_END: player-data

; ANCHOR: player-initialize
InitializePlayer::

    ; initialize the players object
    ld hl, wPlayerObject
    call InitializeObjectAtHL

    ; set the players position
    ld d,0
    ld e, 5
    ld hl, wPlayerObject
    call PlaceObjectAtHL_XPositionDE
    call PlaceObjectAtHL_YPositionDE
    
    ; set the players metasprite
    
    ld hl, wPlayerObject
    ld d, LOW(playerTestMetaSprite)
    ld e, HIGH(playerTestMetaSprite)
    call SetObjectAtHL_MetaspriteInDE

    ; Set the players speed
    ld hl, wPlayerObject
    ld b, PLAYER_MOVE_SPEED
    call SetObjectAtHL_SpeedInB

    ld a, 0
    ld [mPlayerFlash+0],a
    ld [mPlayerFlash+1],a
    
CopyPlayerTileDataIntoVRAM:
    ; Copy the player's tile data into VRAM
	ld de, playerShipTileData
	ld hl, PLAYER_TILES_START
	ld bc, playerShipTileDataEnd - playerShipTileData
    call CopyDEintoMemoryAtHL

    ret;
; ANCHOR_END: player-initialize

; ANCHOR: player-update-start
UpdatePlayer::

    ld hl, wPlayerObject

	ld a, [wCurKeys]
	and a, PADF_LEFT
	call nz, MoveObjectAtHL_Left

	ld a, [wCurKeys]
	and a, PADF_RIGHT
	call nz, MoveObjectAtHL_Right

	ld a, [wCurKeys]
	and a, PADF_DOWN
	call nz, MoveObjectAtHL_Down

	ld a, [wCurKeys]
	and a, PADF_UP
	call nz, MoveObjectAtHL_Up

	ld a, [wNewKeys]
	and a, PADF_A
    call nz, FireNextBullet;
    
    call DrawObjectAtHL

    ret

; ANCHOR_END: player-update-start
    
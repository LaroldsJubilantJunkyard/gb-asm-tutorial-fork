; ANCHOR: enemies-start
include "src/main/utils/hardware.inc"
include "src/main/utils/constants.inc"

SECTION "EnemyVariables", WRAM0

wCurrentEnemyX:: db  
wCurrentEnemyY:: db  

wSpawnCounter:: db  
wEnemiesKilled:: db  
wNextEnemyXPosition:: ds 2
wActiveEnemyCounter::db
wUpdateEnemiesCounter:db
wUpdateEnemiesCurrentEnemyAddress::dw

; Bytes: active, x , y (low), y (high), speed, health
wEnemies:: ds MAX_ENEMY_COUNT*PER_OBJECT_BYTES_COUNT
wEnemiesEnd:: db

; ANCHOR_END: enemies-start
; ANCHOR: enemies-tile-metasprite
SECTION "Enemies", ROM0

; ANCHOR_END: enemies-tile-metasprite

; ANCHOR: enemies-initialize
InitializeEnemies::

    call InitializeGlobalEnemiesVariables
	call AddEnemyTileDataToVRAM

    ld b, 0

    ld hl, wEnemies

InitializeEnemies_Loop:

    call InitializeObjectAtHL    
    call MoveToNextObject

    ; Check for the wEnemiesEnd value of 255
    ; Stop looping when we read it
    ld a, [hl]
    cp a, 255
    ret z

    jp InitializeEnemies_Loop
; ANCHOR_END: enemies-initialize

; ANCHOR: enemies-update-start
UpdateEnemies::

	call TryToSpawnEnemies

    ; Make sure we have active enemies
    ; or we want to spawn a new enemy
    ld a, [wNextEnemyXPosition]
    ld b, a
    ld a, [wNextEnemyXPosition+1]
    ld c, a
    ld a, [wActiveEnemyCounter]
    or a, b
    or a, c
    cp a, 0
    ret z
    
    ld a, 0
    ld [wUpdateEnemiesCounter], a

    ld hl, wEnemies

    jp UpdateEnemies_PerEnemy
; ANCHOR_END: enemies-update-start
; ANCHOR: enemies-update-loop
UpdateEnemies_Loop:

    call MoveToNextObject

    ; Check for the wEnemiesEnd value of 255
    ; Stop looping when we read it
    ld a, [hl]
    cp a, 255
    ret z

    ; Compare against the active count
    ld a, [wUpdateEnemiesCounter]
    cp a, MAX_ENEMY_COUNT
    ret nc
 
; ANCHOR_END: enemies-update-loop


; ANCHOR: enemies-update-per-enemy
UpdateEnemies_PerEnemy:

    ; The first byte is if the current object is active
    ; If it's not zero, it's active, go to the normal update section
    ld a, [hl]
    cp 0
    jp nz, UpdateEnemies_PerEnemy_Update

UpdateEnemies_SpawnNewEnemy:

    ; If this enemy is NOT active
    ; Check If we want to spawn a new enemy
    ld a, [wNextEnemyXPosition]
    ld a, b
    ld a, [wNextEnemyXPosition+1]
    or a, b
    cp 0

    ; If we don't want to spawn a new enemy, we'll skip this (deactivated) enemy
    jp z, UpdateEnemies_Loop

    call SpawnDeactivatedEnemy

; ANCHOR_END: enemies-update-per-enemy

; ANCHOR: enemies-update-per-enemy2
UpdateEnemies_PerEnemy_Update:

    call MoveObjectAtHL_Down
    call DrawObjectAtHL

    ; check if it's out of bounds
    call GetObjectAtHLIsOutOfBounds
    jp nc, UpdateEnemies_DeActivateEnemy

    ld de, wPlayerObject
    call CheckObjectAtHLAgainstObjectAtDE
    call z, DamageObjectAtHL
    
    ; If we don't want to spawn a new enemy, we'll skip this (deactivated) enemy
    jp UpdateEnemies_Loop

; ANCHOR_END: enemies-update-per-enemy2
    

; ANCHOR: enemies-update-deactivate
UpdateEnemies_DeActivateEnemy:

    ; Set as inactive
    ld a, 0
    ld [hl], a

    ; Decrease counter
    ld a,[wActiveEnemyCounter]
    dec a
    ld [wActiveEnemyCounter], a

    jp UpdateEnemies_Loop

; ANCHOR_END: enemies-update-deactivate

InitializeGlobalEnemiesVariables::
    

    ld a, 255
    ld [wEnemiesEnd], a

    ld a, 0
    ld [wEnemiesKilled], a

    ld a, 0
    ld [wSpawnCounter], a
    ld [wActiveEnemyCounter], a
    ld [wNextEnemyXPosition+0], a
    ld [wNextEnemyXPosition+1], a
    ret

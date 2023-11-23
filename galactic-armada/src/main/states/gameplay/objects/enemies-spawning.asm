; ANCHOR: enemies-start
include "src/main/utils/hardware.inc"
include "src/main/utils/constants.inc"

; ANCHOR_END: enemies-start
; ANCHOR: enemies-tile-metasprite
SECTION "EnemiesSpawning", ROM0


; ANCHOR: enemies-spawn
TryToSpawnEnemies::
	ld a, [wCurrentWaveItem]
	ld h, a
	ld a, [wCurrentWaveItem+1]
	ld l, a
    inc hl

	ld a, [wEnemiesKilled]
	ld b, a
	ld a, [hl]
	cp a, b

    ret c

    ; Increase our spwncounter
    ld a, [wSpawnCounter]
    inc a
    ld [wSpawnCounter], a

    ; Check our spawn acounter
    ; Stop if it's below a given value
    ld a, [wSpawnCounter]
    cp a, ENEMY_SPAWN_DELAY_MAX
    ret c

    ; Check our next enemy x position variable
    ; Stop if it's non zero
    ld a, [wNextEnemyXPosition]
    cp a, 0
    ret nz

    ; Make sure we don't have the max amount of enmies
    ld a, [wActiveEnemyCounter]
    cp a, MAX_ENEMY_COUNT
    ret nc

TryToSpawnEnemies_GetSpawnPosition:

    ; Generate a semi random value
    call rand
    
    ; make sure it's not above 150
    ld a,b
    cp a, 150
    ret nc

    ; make sure it's not below 24
    ld a, b
    cp a, 24
    ret c

    ; reset our spawn counter
    ld a, 0
    ld [wSpawnCounter], a
    
    ld c, 0

    REPT 4

    sla b
    rl c

    ENDR

    ld a, b
    ld [wNextEnemyXPosition+0], a

    ld a, c
    ld [wNextEnemyXPosition+1], a


    ret
; ANCHOR_END: enemies-spawn
SpawnDeactivatedEnemy::

    push hl

    ; If they are deactivated, and we want to spawn an enemy
    ; activate the enemy
    ld a, 1
    ld [hl], a

    ld b, BULLET_MOVE_SPEED
    call SetObjectAtHL_SpeedInB

    ; Put the value for our enemies x position
    ld a, [wNextEnemyXPosition]
    ld d, a
    ld a, [wNextEnemyXPosition+1]
    ld e, a
    call PlaceObjectAtHL_XPositionDE

    ld d, 0
    ld e, 0
    call PlaceObjectAtHL_YPositionDE


    ld d, LOW(enemyShipMetasprite)
    ld e, HIGH(enemyShipMetasprite)
    call SetObjectAtHL_MetaspriteInDE

    ld a, 0
    ld [wNextEnemyXPosition], a
    ld [wNextEnemyXPosition+1], a

    pop hl
    
    ; Increase counter
    ld a,[wActiveEnemyCounter]
    inc a
    ld [wActiveEnemyCounter], a

    ret
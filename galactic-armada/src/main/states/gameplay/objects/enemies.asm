; ANCHOR: enemies-start
include "src/main/includes/hardware.inc"
include "src/main/includes/constants.inc"

SECTION "EnemyVariables", WRAM0

wCurrentEnemyX:: db  
wCurrentEnemyY:: db  

wSpawnCounter: db  
wNextEnemyXPosition: db
wActiveEnemyCounter::db
wUpdateEnemiesCounter:db
wUpdateEnemiesCurrentEnemyAddress::dw

; ANCHOR_END: enemies-start
SECTION "Enemies", ROM0

; ANCHOR: enemies-update-per-enemy2
UpdateEnemy::

    ; get the start of our object back in hl
    ld h,b
    ld l, c

    ; Save our first bytye
    push hl

    ; Get our y position
    ld bc, object_yLowByte
    add hl, bc

    ; add 10 to our y position
    ld a, [hl]
    add a, 10
    ld [hli], a
    ld a, [hl]
    adc a, 0
    ld [hl], a

    
    ; If our high byte is below 10, we're not offscreen
    ld a, [hl]
    pop hl

    cp a, 10
    jp nc, DeactivateEnemy


.UpdateEnemy_CheckPlayerCollision

    push hl


    ld a, 16
    ld [wSizeX], a
    ld [wSizeY], a
    ld de, wObjects
    call CheckCollisionWithObjectsInHL_andDE

    pop hl
    jp nz, EnemyPlayerCollision

.UpdateEnemy_CheckAllBulletCollision

    ld b,MAX_BULLET_COUNT
    ld de, wObjects+BULLETS_START

UpdateEnemy_CheckBulletCollision:

    ; Save the start of our enemy's bytes
    ; Save the current bullet counter
    ; Save which bullet we are looking at
    push hl
    push bc
    push de

    ld a, 16
    ld [wSizeX], a
    ld [wSizeY], a
    call CheckCollisionWithObjectsInHL_andDE

    ; Retrieve the curernt bullet counter
    ; Return hl to the start of our enemies bytes
    ; Retrieve which object we were looking at
    pop de
    pop bc
    pop hl

    push hl

    jp nz, DamageEnemy

    pop hl

MoveToNextEnemy:

    ; Decrease b
    ; return if it reaches zero
    ld a, b
    dec a
    ld b, a
    and a
    ret z

    ; Move to the next object
    ld a, e
    add a, PER_OBJECT_BYTES_COUNT
    ld e, a

    jp UpdateEnemy_CheckBulletCollision

EnemyPlayerCollision::

    push hl
    push bc

    call DamagePlayer
	
    ld hl, wLives
    ld de, $9C13 ; The window tilemap starts at $9C00
	ld b, 1
	call DrawBDigitsHL_OnDE

    pop bc
    pop hl

    jp DeactivateEnemy

KillEnemy::

    ; Deactivate our bullet in de
    ld a,0
    ld [de], a 

    push hl
    push bc
    
    call IncreaseScore;

    ld hl, wScore
    ld de, $9C06 ; The window tilemap starts at $9C00
	ld b, 6
	call DrawBDigitsHL_OnDE

    pop bc
    pop hl
    
DeactivateEnemy::

    ld a,0
    ld [hl], a

    ret

DamageEnemy:

    push de
    ld de, object_healthByte
    add hl, de
    ld a, [hl]
    dec a

    pop hl
    pop de
    cp a, 255
    jp z, KillEnemy

    ld [hl], a

    push de
    ld de, object_damageByte-object_healthByte
    add hl, de
    pop de

    ld a, 128
    ld [hl], a

    jp MoveToNextEnemy

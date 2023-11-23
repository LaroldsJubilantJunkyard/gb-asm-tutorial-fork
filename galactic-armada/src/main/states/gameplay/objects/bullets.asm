
; ANCHOR: bullets-top
include "src/main/utils/hardware.inc"
include "src/main/utils/constants.inc"

SECTION "BulletVariables", WRAM0

; Do we want to spawn a bullet?
wSpawnBullet:db

; how many bullets are currently active
wActiveBulletCounter:: db

wBullets:: ds MAX_BULLET_COUNT*PER_OBJECT_BYTES_COUNT
wBulletsEnd: db ; we'll manually set this to 255 so we can easily loop through bullets

SECTION "Bullets", ROM0

; ANCHOR_END: bullets-top

; ANCHOR: bullets-initialize
InitializeBullets::

    call InitializeGlobalBulletVariables
    call AddBulletTileDataToVRAM

    ld hl, wBullets

InitializeBullets_Loop:

    call InitializeObjectAtHL

    ; Set the movespeed now
    ld b, BULLET_MOVE_SPEED
    call SetObjectAtHL_SpeedInB

    ; Set the metasprite now
    ld d, LOW(bulletMetasprite)
    ld e, HIGH(bulletMetasprite)
    call SetObjectAtHL_MetaspriteInDE

    call MoveToNextObject

    ; Check for the wBulletsEnd value of 255
    ; Stop looping when we read it
    ld a, [hl]
    cp a, 255
    ret z

    jp InitializeBullets_Loop
; ANCHOR_END: bullets-initialize

; ANCHOR: bullets-update-start
UpdateBullets::

    ; Make sure we have SOME active enemies
    ; OR we want to spawn a bullet
    ld a, [wSpawnBullet]
    ld b, a
    ld a, [wActiveBulletCounter]
    or a,b
    cp a, 0
    ret z

    ; Get the address of the first bullet in hl
    ld hl, wBullets

    jp UpdateBullets_PerBullet
; ANCHOR_END: bullets-update-start

; ANCHOR: bullets-update-loop
UpdateBullets_Loop:

    ; Increase the bullet data our address is pointingtwo
    call MoveToNextObject

    ld a, [hl]
    cp a, 255
    ret z

; ANCHOR_END: bullets-update-loop

; ANCHOR: bullets-update-per
UpdateBullets_PerBullet:

    ; The first byte is if the bullet is active
    ; If it's NOT  zero, it's active, go to the normal update section
    ld a, [hl]
    cp a, 0
    jp nz, UpdateBullets_PerBullet_Normal

    ; Do we need to spawn a bullet?
    ; If we dont, loop to the next enemy
    ld a, [wSpawnBullet]
    cp a, 0
    jp z, UpdateBullets_Loop

    call SpawnDeactivatedBullet

UpdateBullets_PerBullet_Normal:

    call MoveObjectAtHL_Up
    call DrawObjectAtHL

    ; check if it's out of bounds
    call GetObjectAtHLIsOutOfBounds
    call nc, DeactivateBulletAtHL

    jp UpdateBullets_Loop
; ANCHOR_END: deactivate-bullets
    
; ANCHOR: fire-bullets
FireNextBullet::

    ; Make sure we don't have the max amount of enmies
    ld a, [wActiveBulletCounter]
    cp a, MAX_BULLET_COUNT
    ret nc

    ; Set our spawn bullet variable to true
    ld a, 1
    ld [wSpawnBullet], a

    ret
; ANCHOR_END: fire-bullets

    
SpawnDeactivatedBullet:

    ; reset this variable so we don't spawn anymore
    ld a, 0
    ld [wSpawnBullet], a
    
    ; Increase how many bullets are active
    ld a,[wActiveBulletCounter]
    inc a
    ld [wActiveBulletCounter], a

    push hl

    ; Set the current bullet as active
    ld a, 1
    ld [hli], a

    ; Get the unscaled player x & y position of the player
    ld a, [wPlayerObject+1]
    ld [hli], a
    ld a, [wPlayerObject+2]
    ld [hli], a
    ld a, [wPlayerObject+3]
    ld [hli], a
    ld a, [wPlayerObject+4]
    ld [hli], a

    pop hl

    ret

DeactivateBulletAtHL::

    ; if it's y value is grater than 160
    ; Set as inactive
    ld a, 0
    ld [hl], a

    ; Decrease counter
    ld a,[wActiveBulletCounter]
    dec a
    ld [wActiveBulletCounter], a

    ret;

InitializeGlobalBulletVariables:


    ld a, 255
    ld [wBulletsEnd], a

    ld a, 0
    ld [wSpawnBullet], a

    ; Reset how many bullets are active to 0
    ld a,0
    ld [wActiveBulletCounter],a
    ret
; ANCHOR: gameplay-data-variables
INCLUDE "src/main/utils/hardware.inc"
INCLUDE "src/main/utils/macros/text-macros.inc"
INCLUDE "src/main/utils/macros/wave-macros.inc"

SECTION "DefaultGameplayState", ROM0

StartDefaultGameplayLoop::

	ld a, 0
	ld [wEnemiesKilled], a
	
	call WaitForVBlankStart

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	; Call Our function that draws text onto background/window tiles
    ld de, $9C00
    ld hl, wScoreText
    call DrawTextTilesLoop

	; Call Our function that draws text onto background/window tiles
    ld de, $9C0D
    ld hl, wLivesText
    call DrawTextTilesLoop
	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	call DrawScore
	call DrawLives

	ld a, 0
	ld [rWY], a

	ld a, 7
	ld [rWX], a

DefaultGameplayLoop:

	; save the keys last frame
	ld a, [wCurKeys]
	ld [wLastKeys], a

	; This is in input.asm
	; It's straight from: https://gbdev.io/gb-asm-tutorial/part2/input.html
	; In their words (paraphrased): reading player input for gameboy is NOT a trivial task
	; So it's best to use some tested code
    call Input
; ANCHOR_END: update-gameplay-state-start

; ANCHOR: update-gameplay-oam
	; from: https://github.com/eievui5/gb-sprobj-lib
	; hen put a call to ResetShadowOAM at the beginning of your main loop.
	call ResetShadowOAM
	call ResetOAMSpriteAddress
; ANCHOR_END: update-gameplay-oam
	
; ANCHOR: update-gameplay-elements
	call IncreaseFlashing
	call UpdatePlayer
	call UpdateEnemies
	call UpdateBullets
	call UpdateBackground
; ANCHOR_END: update-gameplay-elements
	
; ANCHOR: update-gameplay-clear-sprites
	; Clear remaining sprites to avoid lingering rogue sprites
	call ClearRemainingSprites
; ANCHOR_END: update-gameplay-clear-sprites

; ANCHOR: update-gameplay-end-update
	ld a, [wLives]
	cp a, 250
	jp nc, EndGameplay

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; Call our function that performs the code
    call WaitForVBlankStart
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	; from: https://github.com/eievui5/gb-sprobj-lib
	; Finally, run the following code during VBlank:
	ld a, HIGH(wShadowOAM)
	call hOAMDMA

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; Call our function that performs the code
    ; call WaitForOneVBlank
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	call WaitForVBlankEnd

CheckAllEnemiesKilled:

	
    ; Make sure we don't have any enemies on screen
    ld a, [wActiveEnemyCounter]
    cp a, 0
    jp nz, DefaultGameplayLoop

	; Check if we've killed enough enemies
	ld a, [wCurrentWaveItem]
	ld h, a
	ld a, [wCurrentWaveItem+1]
	ld l, a
	inc hl

	ld a, [wEnemiesKilled]
	ld b, a
	ld a, [hl]

	cp a, b
	jp nc, DefaultGameplayLoop

LevelWaveItemEnded:

	; Increase our wave item by 7
	ld a, [wCurrentWaveItem+1]
	add a, 7
	ld [wCurrentWaveItem+1], a

	jp UpdateGameplayState
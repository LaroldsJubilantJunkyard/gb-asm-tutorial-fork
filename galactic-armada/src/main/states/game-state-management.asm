INCLUDE "src/main/utils/hardware.inc"

; ANCHOR: next-game-state
SECTION "GameStateManagement", ROM0

ClearCurrentGameState::

	; Do not turn the LCD off outside of VBlank
    call WaitForVBlankStart

	call ClearBackground;

	; Turn the LCD off
	ld a, 0
	ld [rLCDC], a

	ld a, 0
	ld [rSCX],a
	ld [rSCY],a
	ld [rWX],a
	ld [rWY],a

	; disable interrupts
	call DisableInterrupts
	
	; Clear all sprites
	call ClearAllSprites

	ret

NextGameState::

	call ClearCurrentGameState

	; Initiate the next state
	ld a, [wGameState]
	cp a, 2 ; 2 = Gameplay
	call z, InitGameplayState
	ld a, [wGameState]
	cp a, 0 ; 0 = Menu
	call z, InitTitleScreenState

	; Update the next state
	ld a, [wGameState]
	cp a, 2 ; 2 = Gameplay
	jp z, UpdateGameplayState
	cp a, 1 ; 1 = Story
	jp z, UpdateStoryState
	jp UpdateTitleScreenState

; ANCHOR_END: next-game-state
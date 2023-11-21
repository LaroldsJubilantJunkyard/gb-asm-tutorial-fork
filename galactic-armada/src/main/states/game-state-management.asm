INCLUDE "src/main/utils/hardware.inc"
INCLUDE "src/main/utils/macros/state-macros.inc"

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

	; Update the next state
	ld a, [wGameState]

	cp a, LEVEL_SELECT 
	jp z, StartLevelSelect

	cp a, GAMEPLAY_RESULTS
	jp z, StartGameplayResults

	cp a, TITLE_SCREEN
	jp z, StartTitleScreenState

	cp a, PRE_GAMEPLAY_BRIDGE
	jp z, StartPreGameplayBridge

	cp a, GAMEPLAY
	jp z, StartGameplayState

	cp a, POST_GAMEPLAY_BRIDGE
	jp z, StartPostGameplayBridge
	
	jp StartTitleScreenState

; ANCHOR_END: next-game-state
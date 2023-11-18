; ANCHOR: entry-point
INCLUDE "src/main/utils/hardware.inc"
INCLUDE "src/main/utils/macros/story-macros.inc"

SECTION "GameVariables", WRAM0

wLastKeys:: db
wCurKeys:: db
wNewKeys:: db
wGameState::db

SECTION "Header", ROM0[$100]

	jp EntryPoint

	ds $150 - @, 0 ; Make room for the header

EntryPoint:

	; Moved point logic into into it's own file so we can focus on building out the full structure of the game
	call SetupGalaticArmada

	; Skip show intro story if we have a save
	call CheckHasSave
	jp z, NextGameState

GameFirstRun:

	;; Initiate our save data
	call InitSaveData

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    ; Set our line counter to the top left tile
    ; Set the story we want to show
    ld hl, Story1
    ld de, HalfTextStart

	call UpdateStoryState
    call HalfClearBackground

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;    

    ; Set our line counter to the top left tile
    ; Set the story we want to show
    ld hl, Story2
    ld de, HalfTextStart

	call UpdateStoryState

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	jp NextGameState;

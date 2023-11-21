; ANCHOR: entry-point
INCLUDE "src/main/utils/hardware.inc"
INCLUDE "src/main/utils/macros/story-macros.inc"
INCLUDE "src/main/utils/macros/state-macros.inc"

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
	jp nz, NotGameFirstRun

IsGameFirstRun:

    call GameFirstRun

    ; Goto the title screen
	ld a, TITLE_SCREEN
	ld [wGameState], a
	jp NextGameState;

NotGameFirstRun:

    call WaitForVBlankStart

    ; Turn the LCD off
    ld a, 0
    ld [rLCDC], a

    ; Load our text font into vram
	call LoadTextFontIntoVRAM
    
	; Turn the LCD on
	ld a, LCDCF_ON  | LCDCF_BGON|LCDCF_OBJON | LCDCF_OBJ16
	ld [rLCDC], a

    call WaitForVBlankEnd

    ; Goto the title screen
	ld a, TITLE_SCREEN
	ld [wGameState], a
	jp NextGameState;

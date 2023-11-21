; ANCHOR: entry-point
INCLUDE "src/main/utils/hardware.inc"
INCLUDE "src/main/utils/macros/story-macros.inc"


SECTION "GameFirstRun", ROM0

GameFirstRun::



    call WaitForVBlankStart

	; Turn the LCD off
	ld a, 0
	ld [rLCDC], a

    ; Show our splash screen
    call DrawLaroldsJubilantJunkyardSplashScreen
	
    ; The splash screen takes up a lot of vram space
    ; Load our text font into vram
	call LoadTextFontIntoVRAM

	; Turn the LCD on
	ld a, LCDCF_ON  | LCDCF_BGON|LCDCF_OBJON | LCDCF_OBJ16
	ld [rLCDC], a

    call WaitForVBlankEnd

    ; Wait a small amount of time
    ; Save our count in this variable
    ld a, 50
    ld [wVBlankCount], a
    call WaitForVBlankFunction

	;; Initiate our save data
	call InitSaveData
    call ClearBackground

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    ; Set our line counter to the top left tile
    ; Set the story we want to show
    ld hl, Story1
    ld de, HalfTextStart
	call UpdateStoryState

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;   
    
    call HalfClearBackground 
    
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;   

    ; Set our line counter to the top left tile
    ; Set the story we want to show
    ld hl, Story2
    ld de, HalfTextStart
	call UpdateStoryState

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    ret
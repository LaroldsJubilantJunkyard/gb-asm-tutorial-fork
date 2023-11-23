; ANCHOR: gameplay-data-variables
INCLUDE "src/main/utils/hardware.inc"
INCLUDE "src/main/utils/macros/text-macros.inc"
INCLUDE "src/main/utils/macros/wave-macros.inc"
INCLUDE "src/main/utils/macros/state-macros.inc"

SECTION "GameplayVariables", WRAM0

wScore:: ds 6
wLives:: db
mGlobalFlashCounter:: db
mGlobalIsVisibleDuringFlashing:: db
wCurrentWaveItem:: ds 2

SECTION "GameplayState", ROM0
; ANCHOR_END: gameplay-data-variables

; ANCHOR: init-gameplay-state
StartGameplayState::

	ld a, 3
	ld [wLives+0], a

    ld a, 0
    ld [mGlobalFlashCounter+0],a

    ld a, 1
    ld [mGlobalIsVisibleDuringFlashing+0],a

	call WaitForVBlankStart

	call LoadScoreFromSave

	call InitializeBackgroundAndProgressCurrentWaveItem

	call InitializePlayer
	call InitializeBullets
	call InitializeEnemies
	

	; Initiate STAT interrupts
	call InitStatInterrupts

	; Turn the LCD on
	ld a, LCDCF_ON  | LCDCF_BGON|LCDCF_OBJON | LCDCF_OBJ16 | LCDCF_WINON | LCDCF_WIN9C00|LCDCF_BG9800
	ld [rLCDC], a
	
; ANCHOR_END: init-gameplay-state
	
; ANCHOR: update-gameplay-state-start
UpdateGameplayState::

	; Get the address of the current wave item type
	ld a, [wCurrentWaveItem]
	ld h, a
	ld a, [wCurrentWaveItem+1]
	ld l, a

	; if it's an level end type
	ld a, [hl]
	cp a, LEVEL_END
	jp z, EndGameplaySuccess

	cp a, WAVE_DEFINITION
	jp z, StartDefaultGameplayLoop

	cp a, DIALOGUE
	jp z, StartDialogueGameLoop

EndGameplaySuccess::

	call UpdateScoreIntoSave
	call IncreaseCurrentLevel

EndGameplay::
	
    ld a, POST_GAMEPLAY_BRIDGE
    ld [wGameState],a
    jp NextGameState
; ANCHOR_END: update-gameplay-end-update




IncreaseFlashing::

    ; increase 
    ld a, [mGlobalFlashCounter+0]
    add a, 1
	ld [mGlobalFlashCounter+0], a

	bit 3, a
	jp nz,IncreaseFlashing_One 


IncreaseFlashing_Zero:
    ld a, 0
    ld [mGlobalIsVisibleDuringFlashing],a
	ret

IncreaseFlashing_One:
    ld a, 1
    ld [mGlobalIsVisibleDuringFlashing],a

	ret
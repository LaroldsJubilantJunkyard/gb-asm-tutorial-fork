INCLUDE "src/main/utils/hardware.inc"
INCLUDE "src/main/utils/macros/state-macros.inc"

; ANCHOR: next-game-state
SECTION "GameplayResults", ROM0

StartGameplayResults::

    call WaitForVBlankStart

    call ClearBackground
    call ClearAllSprites
    
	; Turn the LCD on including the window. But no sprites
	ld a, LCDCF_ON | LCDCF_BGON
	ldh [rLCDC], a

    ; Use the de-scaled low byte as the backgrounds position
    ld a,0
	ld [rSCY], a


LoopGameplayResults:

    call WaitForAButtonFunction

EndGameplayResults::

    ld a, LEVEL_SELECT 
    ld [wGameState],a
    jp NextGameState
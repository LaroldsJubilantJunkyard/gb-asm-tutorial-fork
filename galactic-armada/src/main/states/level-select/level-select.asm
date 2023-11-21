INCLUDE "src/main/utils/hardware.inc"
INCLUDE "src/main/utils/macros/state-macros.inc"

; ANCHOR: next-game-state
SECTION "LevelSelect", ROM0

StartLevelSelect::


LoopLevelSelect:
    
	; This is in input.asm
	; It's straight from: https://gbdev.io/gb-asm-tutorial/part2/input.html
	; In their words (paraphrased): reading player input for gameboy is NOT a trivial task
	; So it's best to use some tested code
    call Input
    
    ; Go to gameplay if a is pressed
	ld a, [wNewKeys]
    and a, PADF_A
    jp nz, EndLevelSelect
    
    ;; Go back if b is pressed
	ld a, [wNewKeys]
    and a, PADF_B
    jp nz, EndLevelSelectBack

    call WaitForOneVBlank

    jp LoopLevelSelect

EndLevelSelectBack::

    ld a, TITLE_SCREEN
    ld [wGameState],a
    jp NextGameState

EndLevelSelect::

    ; Load level 1 into our current wave item
	ld hl, wLevel1
	ld a, h
	ld [wCurrentWaveItem], a
	ld a, l
	ld [wCurrentWaveItem+1], a


    ld a, PRE_GAMEPLAY_BRIDGE
    ld [wGameState],a
    jp NextGameState
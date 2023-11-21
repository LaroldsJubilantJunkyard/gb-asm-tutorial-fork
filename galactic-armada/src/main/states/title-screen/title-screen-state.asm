; ANCHOR: title-screen-start
INCLUDE "src/main/utils/hardware.inc"
INCLUDE "src/main/utils/macros/text-macros.inc"
INCLUDE "src/main/utils/macros/story-macros.inc"
INCLUDE "src/main/utils/macros/state-macros.inc"

SECTION "TitleScreenState", ROM0

; ANCHOR_END: title-screen-start
; ANCHOR: title-screen-init
StartTitleScreenState::

	call DrawTitleScreen
	
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; Draw the press play text
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	; Call Our function that draws text onto background/window tiles
    ld de, $99C3
    ld hl, wPressPlayText
    call DrawTextTilesLoop

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	; Turn the LCD on
	ld a, LCDCF_ON  | LCDCF_BGON|LCDCF_OBJON | LCDCF_OBJ16
	ld [rLCDC], a

; ANCHOR_END: title-screen-init

; ANCHOR: update-title-screen
UpdateTitleScreenState::

    call WaitForAButtonFunction

    ld a, CART_SRAM_ENABLE
    ld [rRAMG], a
    
    ld a, [wCurrentLevel]
    ld b, a

    ld a, CART_SRAM_DISABLE
    ld [rRAMG], a

    ; We'll avoid level select for the first level
    ld a, b
    cp a, 0
    jp GotoGameplayBridge

GotoLevelSelect:

    ld a, LEVEL_SELECT
    ld [wGameState],a
    jp NextGameState

GotoGameplayBridge:

    ; Load level 1 into our current wave item
	ld hl, wLevel1
	ld a, h
	ld [wCurrentWaveItem], a
	ld a, l
	ld [wCurrentWaveItem+1], a

    ld a, PRE_GAMEPLAY_BRIDGE
    ld [wGameState],a
    jp NextGameState
; ANCHOR_END: update-title-screen

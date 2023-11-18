; ANCHOR: title-screen-start
INCLUDE "src/main/utils/hardware.inc"
INCLUDE "src/main/utils/macros/text-macros.inc"
INCLUDE "src/main/utils/macros/text-macros.inc"
INCLUDE "src/main/utils/macros/story-macros.inc"
INCLUDE "src/main/utils/macros/tilemap-macros.inc"

SECTION "TitleScreenState", ROM0

; ANCHOR_END: title-screen-start
; ANCHOR: title-screen-init
InitTitleScreenState::

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

    ret;
; ANCHOR_END: title-screen-init

; ANCHOR: update-title-screen
UpdateTitleScreenState::

    call WaitForAButtonFunction

GotoGameplay:

    ld a, 2
    ld [wGameState],a
    jp NextGameState
; ANCHOR_END: update-title-screen

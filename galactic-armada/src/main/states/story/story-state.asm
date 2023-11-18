; ANCHOR: init-story-state
INCLUDE "src/main/utils/hardware.inc"
INCLUDE "src/main/utils/macros/text-macros.inc"

SECTION "StoryStateASM", ROM0

; ANCHOR_END: init-story-state

; ANCHOR: story-screen-page1
UpdateStoryState::

	; Turn the LCD on
	ld a, LCDCF_ON  | LCDCF_BGON|LCDCF_OBJON | LCDCF_OBJ16
	ld [rLCDC], a

UpdateStoryState_Loop::

    ; Push back onto the stack
    push de

    call DrawText_WithTypewriterEffect

    ; Increase 'de' by 64
    pop de
    ld a, e
    add 64
    ld e, a
    ld a, d
    adc a,0
    ld d, a
    
    ; move to the next character and next background tile
    inc hl

    ; End if we've reached 255
    ld a, [hl]
    cp 255
    jp z, UpdateStoryState_EndLoop

    jp UpdateStoryState_Loop

UpdateStoryState_EndLoop::

    push hl

    call WaitForAButtonFunction

    ; Restore hl from when we ended our loop
    pop hl
    
    ret
    
; ANCHOR_END: story-screen-page2

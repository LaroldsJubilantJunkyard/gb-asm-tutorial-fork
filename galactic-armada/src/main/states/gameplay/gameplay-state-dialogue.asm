; ANCHOR: gameplay-data-variables
INCLUDE "src/main/utils/hardware.inc"
INCLUDE "src/main/utils/macros/text-macros.inc"
INCLUDE "src/main/utils/macros/wave-macros.inc"

SECTION "DialogueGameplayState", ROM0

StartDialogueGameLoop::

	call WaitForVBlankStart
	call DisableInterrupts
	call ClearWindow

	ld a, 144
	ld [rWY], a

	ld a, 7
	ld [rWX], a

    ; Wait a small amount of time
    ; Save our count in this variable
    ld a, 3
    ld [wVBlankCount], a
	call WaitForVBlankFunction

RaiseWindowLoop:

	; Raise the background
	ld a, [rWY]
	dec a
	ld [rWY], a

	call WaitForOneVBlank

	ld a, [rWY]
	cp a, 96
	jp nc, RaiseWindowLoop
	
	; Get the current wave item
	ld a, [wCurrentWaveItem]
	ld h, a
	ld a, [wCurrentWaveItem+1]
	ld l, a

	; move past the type byte to the speaker
	inc hl
	
	; Draw the speaker instantly on the window
    ld de, $9c21
    call DrawTextTilesLoop

	; move past the speaker end byte to the message
	inc hl
	
	; draw the message typewriter style on the window
    ld de, $9c61
	call UpdateStoryStateWindow

	; move pass the message to the next item
	; Then update our current wave item
	inc hl
	ld a, h
	ld [wCurrentWaveItem], a
	ld a, l
	ld [wCurrentWaveItem+1], a

LowerWindowLoop:

	; Raise the background
	ld a, [rWY]
	inc a
	ld [rWY], a

	call WaitForOneVBlank

	ld a, [rWY]
	cp a, 144
	jp c, LowerWindowLoop

	jp UpdateGameplayState
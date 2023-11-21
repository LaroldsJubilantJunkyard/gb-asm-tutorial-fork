INCLUDE "src/main/utils/hardware.inc"

SECTION "SaveVariables", SRAM

wCurrentLevel:: db
wSaveFlag1:: db
wSaveFlag2:: db
wMaxScore:: ds 6

SECTION "SaveFunctions", ROM0

;; Setup our save data
InitSaveData::

    ld a, CART_SRAM_ENABLE
    ld [rRAMG], a

    ld a, 123
    ld [wSaveFlag1], a

    ld a, 123
    ld [wSaveFlag2], a

    ld a, 0
    ld [wCurrentLevel], a 

    ld a, 0
    ld [wMaxScore+0], a 
    ld [wMaxScore+1], a 
    ld [wMaxScore+2], a 
    ld [wMaxScore+3], a 
    ld [wMaxScore+4], a 
    ld [wMaxScore+5], a 
    
    ld a, CART_SRAM_DISABLE
    ld [rRAMG], a

    ret

; check if we have save data
CheckHasSave::

    ld a, CART_SRAM_ENABLE
    ld [rRAMG], a

    ld a, [wSaveFlag1]
    cp a, 123
    jp z, Check2
    
    
    ld a, CART_SRAM_DISABLE
    ld [rRAMG], a

    ld a, 0
    cp a, 0
    ret

Check2:

    ld a, [wSaveFlag2]
    cp a, 123
    jp z, HasSave
    
    
    ld a, CART_SRAM_DISABLE
    ld [rRAMG], a

    ld a, 0
    cp a, 0
    ret
    
HasSave:

    
    ld a, CART_SRAM_DISABLE
    ld [rRAMG], a

    ld a, 1
    cp a, 0
    ret

IncreaseCurrentLevel::

    ld a, CART_SRAM_ENABLE
    ld [rRAMG], a
    
    ld a, [wCurrentLevel]
    inc a
    ld [wCurrentLevel], a 
	
    ld a, CART_SRAM_DISABLE
    ld [rRAMG], a
	ret


UpdateScoreIntoSave::

    ld a, CART_SRAM_ENABLE
    ld [rRAMG], a

    ld a, [wScore+0]
	ld [wMaxScore+0], a
    ld a, [wScore+1]
	ld [wMaxScore+1], a
    ld a, [wScore+2]
	ld [wMaxScore+2], a
    ld a, [wScore+3]
	ld [wMaxScore+3], a
    ld a, [wScore+4]
	ld [wMaxScore+4], a
    ld a, [wScore+5]
	ld [wMaxScore+5], a
	
    ld a, CART_SRAM_DISABLE
    ld [rRAMG], a

	ret

LoadScoreFromSave::

    ld a, CART_SRAM_ENABLE
    ld [rRAMG], a

    ld a, [wMaxScore+0]
	ld [wScore+0], a
    ld a, [wMaxScore+1]
	ld [wScore+1], a
    ld a, [wMaxScore+2]
	ld [wScore+2], a
    ld a, [wMaxScore+3]
	ld [wScore+3], a
    ld a, [wMaxScore+4]
	ld [wScore+4], a
    ld a, [wMaxScore+5]
	ld [wScore+5], a
	
    ld a, CART_SRAM_DISABLE
    ld [rRAMG], a

	ret
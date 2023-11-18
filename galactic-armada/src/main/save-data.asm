INCLUDE "src/main/utils/hardware.inc"

SECTION "SaveVariables", SRAM

wCurrentLevel:: db
wSaveFlag1:: db
wSaveFlag2:: db

SECTION "SaveFunctions", ROM0

;; Setup our save data
InitSaveData::

    ld a, 123
    ld [wSaveFlag1], a

    ld a, 123
    ld [wSaveFlag2], a

    ld a, 0
    ld [wCurrentLevel], a 

    ret

; check if we have save data
CheckHasSave::

    ld a, [wSaveFlag1]
    cp a, 123
    jp z, Check2

    ld a, 0
    cp a, 1
    ret

Check2:

    ld a, [wSaveFlag1]
    cp a, 123
    jp z, NoSave

    ld a, 0
    cp a, 1
    ret
    
NoSave:

    ld a, 1
    cp a, 1
    ret

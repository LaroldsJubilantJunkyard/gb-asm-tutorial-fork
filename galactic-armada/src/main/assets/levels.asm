INCLUDE "src/main/utils/macros/wave-macros.inc"
INCLUDE "src/main/utils/macros/text-macros.inc"

SECTION "Levels", ROM0

wLevel1::  

    ; Wave definitions will always have 7 bytes
    .Wave1:: db WAVE_DEFINITION
    .Wave1_EnemyCount:: db 3
    .Wave1_EnemyTypes:: db 0, 0, 0 ,0 ,0
    ; todo music somehow

    ; Dialogue will always end in 2 consecutive 255's
    .Wave1_EndSpeech:: db DIALOGUE, "lt john:", 255,  "great shootin tex", 255, 255

    ; Wave definitions will always have 7 bytes
    .Wave2:: db WAVE_DEFINITION
    .Wave2_EnemyCount:: db 3
    .Wave2_EnemyTypes:: db 0, 0, 0 ,0 ,0
    ; todo music somehow

    ; Dialogue will always end in 2 consecutive 255's
    .Wave12_EndSpeech:: db DIALOGUE, "lt john:", 255,  "your a natural", 255, 255
    
    ; All levels should end with this
    .LEvel1End:: db LEVEL_END
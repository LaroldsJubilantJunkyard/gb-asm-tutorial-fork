INCLUDE "src/main/utils/hardware.inc"
INCLUDE "src/main/utils/macros/state-macros.inc"

; ANCHOR: next-game-state
SECTION "PostGameplayBridge", ROM0

StartPostGameplayBridge::


EndPostGameplayBridge::

    ld a, GAMEPLAY_RESULTS
    ld [wGameState],a
    jp NextGameState
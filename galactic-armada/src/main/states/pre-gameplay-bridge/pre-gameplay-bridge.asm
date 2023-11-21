INCLUDE "src/main/utils/hardware.inc"
INCLUDE "src/main/utils/macros/state-macros.inc"

; ANCHOR: next-game-state
SECTION "PreGameplayBridge", ROM0

StartPreGameplayBridge::

EndPreGameplayBridge::

    ld a, GAMEPLAY
    ld [wGameState],a
    jp NextGameState
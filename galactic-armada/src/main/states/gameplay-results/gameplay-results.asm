INCLUDE "src/main/utils/hardware.inc"
INCLUDE "src/main/utils/macros/state-macros.inc"

; ANCHOR: next-game-state
SECTION "GameplayResults", ROM0

StartGameplayResults::

LoopGameplayResults:

    call WaitForAButtonFunction

EndGameplayResults::

    ld a, POST_GAMEPLAY_BRIDGE
    ld [wGameState],a
    jp NextGameState
INCLUDE "src/main/utils/macros/text-macros.inc"
SECTION "Stories ASM", ROM0

; ANCHOR: story-screen-data
Story1::
    .Line1     db "the galatic empire", 255
    .Line2      db "rules the galaxy", 255
    .Line3      db "with an iron", 255
    .Line4      db "fist.", 255
    .EndPage1   db 255 ; 255 mean end of story
    
Story2::
    .Line5      db "the rebel force", 255
    .Line6      db "remain hopeful of", 255
    .Line7      db "freedoms light.", 255
    .EndStory   db 255 ; 255 mean end of story

	
; ANCHOR_END: story-screen-data
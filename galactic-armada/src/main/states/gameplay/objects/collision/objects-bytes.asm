
; ANCHOR: bullets-top
include "src/main/utils/hardware.inc"
include "src/main/utils/constants.inc"

SECTION "ObjectsBytes", ROM0

MoveToNextObject::

    ; Increase the address
    ld a, l
    add a, PER_OBJECT_BYTES_COUNT
    ld l, a
    ld a, h
    adc a, 0
    ld h, a
    ret
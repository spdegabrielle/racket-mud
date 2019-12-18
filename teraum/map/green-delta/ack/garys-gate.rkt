#lang racket

(require "../../../recipes/areas/green-delta/ack/gate.rkt")

(provide garys-gate)

(define garys-gate
  (gate
   'teraum/green-delta/ack/garys-gate
   #:brief "Gary's Gate"
   #:description "This is Gary's Gate, which leads from Sugar Heights to the Widdershins Road."
   #:exits '(("northeast" . teraum/green-delta/ack/sugar-heights)
             ("south" . teraum/green-delta/game/widdershins-road))))
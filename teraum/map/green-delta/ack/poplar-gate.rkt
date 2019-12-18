#lang racket

(require "../../../recipes/areas/green-delta/ack/gate.rkt")

(provide poplar-gate)

(define poplar-gate
  (gate
   'teraum/green-delta/ack/poplar-gate
   #:brief "Poplar Gate"
   #:description "This is Poplar Gate, leading from the Carper Falls district of Ack to the Widdershins Road. To the north is Carper Falls. To the south is the Widdershins Road."
   #:exits '(("north" . teraum/green-delta/ack/carper-falls)
             ("south" . teraum/green-delta/game/widdershins-road))))

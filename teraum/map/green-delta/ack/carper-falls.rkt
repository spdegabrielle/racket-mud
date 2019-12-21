#lang racket

(require "../../../recipes/areas/green-delta/ack/district.rkt")

(provide carper-falls)

(define carper-falls
  (district
   'teraum/green-delta/ack/carper-falls
   #:brief "Carper Falls"
   #:description "This is Carper Falls, a district in the city of Ack. To the north is the Copper Ward. To the east is Piketown. To the south is Poplar Gate. To the west is Sugar Heights."
   #:exits '(("east" . teraum/green-delta/ack/piketown)
             ("south" . teraum/green-delta/ack/poplar-gate)
             ("west" . teraum/green-delta/ack/sugar-heights)
             ("northwest" . teraum/green-delta/ack/copper-ward))))

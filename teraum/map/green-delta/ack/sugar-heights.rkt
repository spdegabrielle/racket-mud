#lang racket

(require "../../../recipes/areas/green-delta/ack/district.rkt")

(provide sugar-heights)

(define sugar-heights
  (district
   'teraum/green-delta/ack/sugar-heights
   #:brief "Sugar Heights"
   #:description "This is Sugar Heights, a district in the city of Ack. To the north is the Copper Ward. To the east is Carper Falls. To the southwest is Gary's Gate."
   #:exits '(("northeast" . teraum/green-delta/ack/copper-ward)
             ("east" . teraum/green-delta/ack/carper-falls)
             ("southwest" . teraum/green-delta/ack/garys-gate))))
#lang racket

(require "../../../recipes/areas/green-delta/ack/district.rkt")

(provide piketown)

(define piketown
  (district
   'teraum/green-delta/ack/piketown
   #:brief "Piketown"
   #:description "This is Piketown, a district in the city of Ack. To the north is Anger's Place. To the southeast is the Piketown Gate. To the west is Carper Falls."
   #:exits '(("north" . teraum/green-delta/ack/angers-place)
             ("southeast" . teraum/green-delta/ack/piketown-gate)
             ("west" . teraum/green-delta/ack/carper-falls))))
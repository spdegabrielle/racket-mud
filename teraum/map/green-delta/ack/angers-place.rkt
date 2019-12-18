#lang racket

(require "../../../recipes/areas/green-delta/ack/district.rkt")

(provide angers-place)


(define angers-place
  (district
   'teraum/green-delta/ack/angers-place
   #:brief "Anger's Place"
   #:description "This is Anger's Place, a district in the city of Ack. To the north is the Brass Ward. To the south is Piketown. To the west is the Copper Ward."
   #:exits '(("north" . teraum/green-delta/ack/brass-ward)
             ("south" . teraum/green-delta/ack/piketown)
             ("west" . teraum/green-delta/ack/copper-ward))))
#lang racket

(require "../../../recipes/areas/green-delta/ack/district.rkt")

(provide brass-ward)

(define brass-ward
  (district
   'teraum/green-delta/ack/brass-ward
   #:brief "Brass Ward"
   #:description "This is the Brass Ward, a district in the city of Ack. To the east is Bank Hill. To the west is the Copper Ward. To the south is Anger's Place."
   #:exits '(("east" . teraum/green-delta/ack/bank-hill)
             ("west" . teraum/green-delta/ack/copper-ward)
             ("south" . teraum/green-delta/ack/angers-place))))

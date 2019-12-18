#lang racket

(require "../../../recipes/areas/green-delta/ack/district.rkt")

(provide astar-ward)

(define astar-ward
  (district
   'teraum/green-delta/ack/astar-ward
   #:brief "Astar Ward"
   #:description "This is the Astar Ward, a district in the city of Ack. To the northwest is Reinhold Wood. To the east is Gasper. To the south is the Brass Ward. To the west is the Red Ward. To the northwest is the road to Arathel County."
   #:exits '(("northwest" . teraum/green-delta/ack/reinhold-wood)
             ("east" . teraum/green-delta/ack/gasper)
             ("south" . teraum/green-delta/ack/brass-ward)
             ("west" . teraum/green-delta/ack/red-ward)
             ("northwest" . teraum/green-delta/arathel-county/south-arathel-ack-road))))
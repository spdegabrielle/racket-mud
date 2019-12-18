#lang racket

(require "../../../recipes/areas/green-delta/ack/district.rkt")

(provide red-ward)

(define red-ward
  (district
   'teraum/green-delta/ack/red-ward
   #:brief "Red Ward"
   #:description "This is the Red Ward, one of the districts of the city of Ack. To the east is the Astar Ward. To the west is the North Ward."
   #:exits '(("east" . teraum/green-delta/ack/astar-ward)
             ("west" . teraum/green-delta/ack/north-ward))))
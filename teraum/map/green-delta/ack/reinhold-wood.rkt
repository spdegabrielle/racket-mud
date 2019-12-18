#lang racket

(require "../../../recipes/areas/green-delta/ack/district.rkt")

(provide reinhold-wood)

(define reinhold-wood
  (district
   'teraum/green-delta/ack/reinhold-wood
   #:brief "Reinhold Wood"
   #:description "This is Reinhold Wood, a district in the city of Ack. To the southeast is the Astar Ward."
   #:exits '(("southeast" . teraum/green-delta/ack/astar-ward))))
#lang racket

(require "../../../recipes/areas/green-delta/ack/district.rkt")

(provide gasper)

(define gasper
  (district
   'teraum/green-delta/ack/gasper
   #:brief "Gasper"
   #:description "This is Gasper, a district in the city of Ack. To the southwest is the Astar Ward."
   #:exits '(("southwest" . teraum/green-delta/ack/astar-ward))))
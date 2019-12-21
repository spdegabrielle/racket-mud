#lang racket

(require "../../../recipes/areas/green-delta/ack/district.rkt")

(provide squash-ward)

(define squash-ward
  (district
   'teraum/green-delta/ack/squash-ward
   #:brief "Squash Ward"
   #:description "This is the Squash Ward, a district in the city of Ack. To the east is the Copper Ward."
   #:exits '(("north" . teraum/green-delta/ack/dock-ward))))
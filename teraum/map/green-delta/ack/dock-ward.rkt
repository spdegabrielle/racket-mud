#lang racket

(require "../../../recipes/areas/green-delta/ack/district.rkt")

(provide dock-ward)

(define dock-ward
  (district
   'teraum/green-delta/ack/dock-ward
   #:brief "Dock Ward"
   #:description "This is the Dock Ward, the oldest district in the city of Ack. To the north is the North Ward. To the east is the Copper Ward. To the south is the Squash Ward."
   #:exits '(("north" . teraum/green-delta/ack/north-ward)
             ("east" . teraum/green-delta/ack/copper-ward)
             ("south" . teraum/green-delta/ack/squash-ward))))
#lang racket

(require "../../../recipes/areas/green-delta/ack/district.rkt")

(provide copper-ward)

(define copper-ward
  (district
   'teraum/green-delta/ack/copper-ward
   #:brief "Copper Ward"
   #:description "This is the Copper Ward, a district of the city of Ack. To the east is the Brass Ward. To the southeast is Carper Falls. To the west is the Squash Ward. To the southwest is Sugar Heights. To the northwest is the Dock Ward."
   #:exits '(("east" . teraum/green-delta/ack/brass-ward)
             ("southeast" . teraum/green-delta/ack/carper-falls)
             ("southwest" . teraum/green-delta/ack/sugar-heights)
             ("west" . teraum/green-delta/ack/squash-ward))))

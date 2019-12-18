#lang racket

(require "../../../recipes/areas/green-delta/ack/district.rkt")

(provide wineglass)

(define wineglass
  (district
   'teraum/green-delta/ack/wineglass
   #:brief "Wineglass"
   #:description "This is Wineglass, a district in the city of Ack. To the southeast is the North Ward. To the northwest is the Dog."
   #:exits '(("southeast" . teraum/green-delta/ack/north-ward)
             ("nothwest" . teraum/green-delta/ack/the-dog))))
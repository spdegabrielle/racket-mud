#lang racket

(require "../../../recipes/areas/green-delta/ack/district.rkt")

(provide the-dog)

(define the-dog
  (district
   'teraum/green-delta/ack/the-dog
   #:brief "The Dog"
   #:description "This is the Dog, a district in the city of Ack. To the southeast is Wineglass."
   #:exits '(("southeast" . teraum/green-delta/ack/wineglass))))
#lang racket

(require "../../../recipes/areas/green-delta/ack/district.rkt")

(provide tin-ward)

(define tin-ward
  (district
   'teraum/green-delta/ack/tin-ward
   #:brief "Tin Ward"
   #:description "This is the Tin Ward, a district of the city of Ack. To the east is the Eastgate. To the west is Bank Hill."
   #:exits '(("east" . teraum/green-delta/ack/eastgate)
             ("west" . teraum/green-delta/ack/bank-hill))))
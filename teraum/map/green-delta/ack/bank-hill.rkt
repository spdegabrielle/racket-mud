#lang racket

(require "../../../recipes/areas/green-delta/ack/district.rkt")

(provide bank-hill)

(define bank-hill
  (district
   'teraum/green-delta/ack/bank-hill
   #:brief "Bank Hill"
   #:description "This is Bank Hill, one of the more prosperous districts of the city of Ack. To the east is the Tin Ward. To the west is the Brass Ward."
   #:exits (list (cons "east" 'teraum/green-delta/ack/tin-ward)
                 (cons "west" 'teraum/green-delta/ack/brass-ward))))
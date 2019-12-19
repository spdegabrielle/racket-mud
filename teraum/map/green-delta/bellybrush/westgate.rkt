#lang racket

(require "../../../recipes/areas/green-delta/bellybrush/road.rkt")

(provide westgate)

(define westgate
  (road
   'teraum/green-delta/bellybrush/westgate
   #:brief "Westgate"
   #:description "This is the road by and under Westgate, a limestone folly built in the town of Bellybrush."
   #:exits '(("north" . teraum/green-delta/bellybrush/west-harbrook-street)
             ("south" . teraum/green-delta/bellybrush/west-kingsroad))))
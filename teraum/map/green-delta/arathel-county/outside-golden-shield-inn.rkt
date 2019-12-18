#lang racket

(require "../../../recipes/areas/green-delta/arathel-county/rural-road.rkt")

(provide outside-golden-shield-inn)

(define outside-golden-shield-inn
  (rural-road
   'teraum/green-delta/arathel-county/outside-golden-shield-inn
   #:brief "Outside the Golden Shield Inn"
   #:description "This is the road outside the Golden Shield Inn, in Arathel County. The road continues north into Arathel County and south toward the city of Ack."
   #:exits '(("north" . teraum/green-delta/arathel-county/outside-dull-thorn-inn)
             ("east" . teraum/green-delta/arathel-county/golden-shield-inn)
             ("south" . teraum/green-delta/arathel-county/outside-crossed-candles-inn))))
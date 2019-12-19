#lang racket

(require "../../../recipes/areas/green-delta/bellybrush/road.rkt")

(provide west-harbrook-street)

(define west-harbrook-street
  (road
   'teraum/green-delta/bellybrush/west-harbrook-street
   #:brief "west Harbrook Street"
   #:description "This is west Harbrook Street, in the north part of the town of Bellybrush."
   #:exits '(("east" . teraum/green-delta/bellybrush/arathel-road)
             ("south" . teraum/green-delta/bellybrush/westgate))))
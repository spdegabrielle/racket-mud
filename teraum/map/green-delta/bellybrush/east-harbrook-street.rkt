#lang racket

(require "../../../recipes/areas/green-delta/bellybrush/road.rkt")

(provide east-harbrook-street)

(define east-harbrook-street
  (road
   'teraum/green-delta/bellybrush/east-harbrook-street
   #:brief "east Harbrook Street"
   #:description "This is east Harbrook Street, in the north part of the town of Bellybrush."
   #:exits '(("south" . teraum/green-delta/bellybrush/east-kingsroad)
             ("west" . teraum/green-delta/bellybrush/arathel-road))))
#lang racket

(require "../../../recipes/areas/green-delta/bellybrush/road.rkt")

(provide east-kingsroad)

(define east-kingsroad
  (road
   'teraum/green-delta/bellybrush/east-kingsroad
   #:brief "East Kingswood"
   #:description "This is the Kingsroad at its eastern end, within the town of Bellybrush."
   #:exits '(("north" . teraum/green-delta/bellybrush/east-harbrook-street)
             ("east" . teraum/central-plains/kingsroad)
             ("west" . teraum/green-delta/bellybrush/kingsroad-outside-orphanage))))
#lang racket

(require "../../../recipes/areas/green-delta/bellybrush/road.rkt")

(provide kingsroad-outside-orphanage)

(define kingsroad-outside-orphanage
  (road
   'teraum/green-delta/bellybrush/kingsroad-outside-orphanage
   #:brief "East Kingswood"
   #:description "This is the Kingsroad, in the town of Bellybrush, outside Mother Jaffa's Orphanage, off the north side of the street."
   #:exits '(("east" . teraum/green-delta/bellybrush/east-kingsroad)
             ("west" . teraum/green-delta/bellybrush/west-kingsroad))))
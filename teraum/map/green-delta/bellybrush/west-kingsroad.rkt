#lang racket

(require "../../../recipes/areas/green-delta/bellybrush/road.rkt")

(provide west-kingsroad)

(define west-kingsroad
  (road
   'teraum/green-delta/bellybrush/west-kingsroad
   #:brief "West Kingsroad"
   #:description "This is the Kingsroad at its western end, within the town of Bellybrush."
   #:exits '(("north" . teraum/green-delta/bellybrush/westgate)
             ("east" . teraum/green-delta/bellybrush/kingsroad-outside-orphanage)
             ("west" . teraum/green-delta/game/kingsroad))))
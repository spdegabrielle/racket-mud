#lang racket

(require "../../recipes/areas/central-plains/rural-road.rkt")

(provide kingsroad)

(define kingsroad
  (rural-road
   'teraum/central-plains/kingsroad
   #:brief "road between the Central Plains and the Green Delta"
   #:description "This is the road between the Central Plains and the Green Delta."
   #:exits '(("east" . teraum/central-plains/fort-kelly)
             ("south" . teraum/gloaming/north-longroad)
             ("west" . teraum/game/bellybrush/east-kingsroad))))
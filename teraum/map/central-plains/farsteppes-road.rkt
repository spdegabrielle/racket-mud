#lang racket

(require "../../recipes/areas/central-plains/rural-road.rkt")

(provide farsteppes-road)

(define farsteppes-road
  (rural-road
   'teraum/central-plains/farsteppes-road
   #:brief "road between the Central Plains and Farsteppes"
   #:description "This is the road between the Central Plains and the Farsteppes."
   #:exits '(("east" . teraum/farsteppes/central-plains-road)
             ("west" . teraum/central-plains/fort-kelly))))
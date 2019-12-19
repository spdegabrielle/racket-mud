#lang racket

(require "../../recipes/areas/farsteppes/rural-road.rkt")

(provide central-plains-road)

(define central-plains-road
  (rural-road
   'teraum/farsteppes/central-plains-road
   #:brief "road between the Central Plains and Farsteppes"
   #:description "This is the road between the Central Plains and the Farsteppes."
   #:exits '(("east" . teraum/farsteppes/helmets-dent)
             ("west" . teraum/central-plains/farsteppes-road))))
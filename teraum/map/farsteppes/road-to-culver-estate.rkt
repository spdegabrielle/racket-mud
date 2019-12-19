#lang racket

(require "../../recipes/areas/farsteppes/rural-road.rkt")
(require "../../recipes/creatures/garlic-boar.rkt")

(provide road-to-culver-estate)

(define road-to-culver-estate
  (rural-road
   'teraum/farsteppes/road-to-culver-estate
   #:brief "road to Culver Estate"
   #:description "This is the road between the town of Helmet's Dent and the nearby Culver Estate, in the Farsteppes. The road runs through one of the few groves in the area."
   #:exits '(("east" . teraum/farsteppes/culver-estate)
             ("northwest" . teraum/farsteppes/helmets-dent))))
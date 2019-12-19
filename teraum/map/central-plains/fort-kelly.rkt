#lang racket

(require "../../recipes/areas/central-plains/fort.rkt")

(provide fort-kelly)

(define fort-kelly
  (fort
   'teraum/central-plains/fort-kelly
   #:brief "Fort Kelly"
   #:description "This is Fort Kelly, a human outpost in the Central Plains."
   #:exits '(("east" . teraum/central-plains/farsteppes-road)
             ("west" . teraum/central-plains/kingsroad))))
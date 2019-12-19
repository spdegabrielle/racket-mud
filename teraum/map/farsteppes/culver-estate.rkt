#lang racket

(require "../../recipes/areas/farsteppes/castle.rkt")

(provide culver-estate)

(define culver-estate
  (castle
   'teraum/farsteppes/culver-estate
   #:brief "Culver Estate"
   #:description "This is the Culver Estate, outside the town of Helmet's Dent in the Farsteppes. Halfway between a mansion and a castle, the property was passed down through generations of nobility. However, wars over the past few decades have caused the extinction of many of those families, and currently the Estate is held by those who were formerly the servants and staff of the house."
   #:exits '(("southwest" . teraum/farsteppes/helmets-dent))))
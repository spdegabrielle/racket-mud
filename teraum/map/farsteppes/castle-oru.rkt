#lang racket

(require "../../recipes/areas/farsteppes/castle.rkt")

(provide castle-oru)

(define castle-oru
  (castle
   'teraum/farsteppes/castle-oru
   #:brief "Castle Oru"
   #:description "This is Castle Oru, in the Farsteppes, named for the apocryphal Castle Oru in the Unseen Sea. It is the seat of House Oru, led by Queen Renkah."
   #:exits '(("southwest" . teraum/farsteppes/helmets-dent))))
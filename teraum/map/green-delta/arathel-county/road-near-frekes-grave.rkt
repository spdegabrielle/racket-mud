#lang racket

(require "../../../recipes/areas/green-delta/arathel-county/rural-road.rkt")

(provide road-near-frekes-grave)

(define road-near-frekes-grave
  (rural-road
   'teraum/green-delta/arathel-county/road-near-frekes-grave
   #:brief "a morbid stretch of country road"
   #:description "This is a length of rural road, cutting north to south through the countryside. There is grave marker set a ways back from the road, and closer, a man dressed in black is hanging by his wrists from a tree. There are some cokeberry bushes growing here."
   #:exits '(("south" . teraum/green-delta/arathel-county/fork-toward-honeyfern-labs))))
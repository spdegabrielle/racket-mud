#lang racket

(require "../../../../rpg-basics/recipes/areas/rooms/basic.rkt")

(provide dull-thorn-inn-quarters)

(define dull-thorn-inn-quarters
  (room
   'teraum/arathel-county/dull-thorn-inn-quarters
   #:brief "sleeping quarters of the Dull Thorn Inn"
   #:description "This is the sleeping quarters of the Dull Thorn Inn, a small room off the main inn. There are eight wooden cots scattered around."
   #:exits '(("out" . teraum/arathel-county/dull-thorn-inn))))
#lang racket

(require "../../../../rpg-basics/recipes/areas/rooms/inn.rkt")
(require "../../../../rpg-basics/recipes/people/innkeep.rkt")

(provide dull-thorn-inn)


(define benne
  (innkeep
   #:brief "Benne"
   #:description "This is Benne. She's a tall human woman, more timid than you'd expect, given her size."
   #:actions  '((2 . "Benne looks toward the window as something makes a sound outside.."))))

(define dull-thorn-inn
  (inn
   'teraum/arathel-county/dull-thorn-inn
   #:brief "Dull Thorn Inn"
   #:description "This is the Dull Thorn Inn. The building is a two-storey timber and brick structure, furnished with well-made tables and chairs. A collection of weapons hangs on the wall to the right as one enters. Across from the entry, a door leads to the sleeping quarters. A woman named Benne stands behind the bar."
   #:exits '(("out" . teraum/arathel-county/outside-dull-thorn-inn)
             ("quarters" . teraum/arathel-county/dull-thorn-inn-quarters))))
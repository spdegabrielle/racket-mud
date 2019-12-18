#lang racket

(require "../../../../../rpg-basics/recipes/areas/rooms/basic.rkt")

(provide kitchen)

(define kitchen
  (room
    'teraum/green-delta/arathel-county/honeyfern-labs/kitchen
    #:brief "kitchen of Honeyfern Laboratories"
    #:description "This is the kitchen of Honeyfern Laboratories. A door leads to the pantry, and another to the dining hall. The door to the backyard has been painted shut."
    #:exits '(("pantry" . teraum/green-delta/arathel-county/honeyfern-labs/pantry)
              ("hall" . teraum/green-delta/arathel-county/honeyfern-labs/dining-hall))))

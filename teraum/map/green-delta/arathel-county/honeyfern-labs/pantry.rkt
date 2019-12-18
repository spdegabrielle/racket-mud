#lang racket

(require "../../../../../rpg-basics/recipes/areas/rooms/basic.rkt")

(provide pantry)

(define pantry
  (room
     'teraum/green-delta/arathel-county/honeyfern-labs/pantry
     #:brief "pantry of Honeyfern Laboratories"
     #:description "This is the pantry of Honeyfern Laboratories' kitchen. A door leads back to the kitchen."
     #:exits '(("door" . teraum/green-delta/arathel-county/honeyfern-labs/kitchen))))

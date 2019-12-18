#lang racket

(require "../../../../../rpg-basics/recipes/areas/rooms/basic.rkt")

(provide library)

(define library
  (room
    'teraum/green-delta/arathel-county/honeyfern-labs/library
    #:brief "library of Honeyfern Laboratories"
    #:description "This is the library of Honeyfern Laboratories. A door leads back out to the hallway."
    #:exits '(("hallway" . teraum/green-delta/arathel-county/honeyfern-labs/first-floor-hallway))))
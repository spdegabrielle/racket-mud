#lang racket

(require "../../../../../rpg-basics/recipes/areas/rooms/basic.rkt")

(provide sitting-room)

(define sitting-room
  (room
    'teraum/green-delta/arathel-county/honeyfern-labs/sitting-room
    #:brief "sitting room of Honeyfern Laboratories"
    #:description "This is the sitting room of Honeyfern Laboratories. A door leads to the foyer."
    #:exits '(("foyer" . teraum/green-delta/arathel-county/honeyfern-labs/foyer))))
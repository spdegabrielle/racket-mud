#lang racket

(require "../../../../../rpg-basics/recipes/areas/rooms/basic.rkt")

(provide front-porch)

(define front-porch
  (room
    'teraum/green-delta/arathel-county/honeyfern-labs/front-porch
    #:brief "front porch of Honeyfern Laboratories"
    #:description "This is the front porch of Honeyfern Laboratories. Down the steps is a path to the gate to to leave, and the a door leads inside."
    #:exits '(("path" . teraum/green-delta/arathel-county/honeyfern-labs/front-path)
              ("inside" . teraum/green-delta/arathel-county/honeyfern-labs/foyer))))
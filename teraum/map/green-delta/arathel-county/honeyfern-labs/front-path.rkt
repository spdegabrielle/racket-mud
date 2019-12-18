#lang racket

(require "../../../../../rpg-basics/recipes/areas/rooms/basic.rkt")

(provide front-path)

(define front-path
  (room
    'teraum/green-delta/arathel-county/honeyfern-labs/front-path
    #:brief "front path to Honeyfern Laboratories"
    #:description "This is the path to Honeyfern Laboratories. Grass grows nearly seven feet tall to either side of the narrow gravel path. It leads to an outside gate, and toward the building's porch."
    #:exits '(("gate" . teraum/green-delta/arathel-county/honeyfern-labs/outside-gate)
              ("porch" . teraum/green-delta/arathel-county/honeyfern-labs/front-porch))))
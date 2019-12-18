#lang racket

(require "../../../../../rpg-basics/recipes/areas/rooms/basic.rkt")

(provide dining-hall)

(define dining-hall
  (room
    'teraum/green-delta/arathel-county/honeyfern-labs/dining-hall
    #:brief "dining hall of Honeyfern Laboratories"
    #:description "This is the dining hall of Honeyfern Laboratories. A door leads to a hallway, while another leads to the kitchen."
    #:exits '(("hallway" . teraum/green-delta/arathel-county/honeyfern-labs/first-floor-hallway)
              ("kitchen" . teraum/green-delta/arathel-county/honeyfern-labs/kitchen))))
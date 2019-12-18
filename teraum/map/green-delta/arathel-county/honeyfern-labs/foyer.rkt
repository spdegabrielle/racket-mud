#lang racket

(require "../../../../../rpg-basics/recipes/areas/rooms/basic.rkt")

(provide foyer)

(define foyer
  (room
    'teraum/green-delta/arathel-county/honeyfern-labs/foyer
    #:brief "foyer of Honeyfern Laboratories"
    #:description "This is the foyer of Honeyfern Laboratories.  A door leads outside. Stairs lead upstairs, but they've been blocked. There is a hallway across the room from the door, and across from the stairs, an open door to a sitting room."
    #:exits '(("outside" . teraum/green-delta/arathel-county/honeyfern-labs/front-porch)
              ; ("stairs" . teraum/green-delta/arathel-county/honeyfern-labs/second-floor)
              ("hallway" . teraum/green-delta/arathel-county/honeyfern-labs/first-floor-hallway)
              ("door" . teraum/green-delta/arathel-county/honeyfern-labs/sitting-room))))
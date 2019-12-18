#lang racket

(require "../../../../../rpg-basics/recipes/areas/rooms/basic.rkt")

(provide first-floor-hallway)

(define first-floor-hallway
  (room
    'teraum/green-delta/arathel-county/honeyefern-labs/first-floor-hallway
    #:brief "hallway in Honeyfern Laboratories"
    #:description "This is the first-floor hallway of Honeyfern Laboratories. One end leads to the foyer, while a door on either side leads to the dining hall or library. There are shelves built into both sides of the wall. Most of the shelves contain old books. A few squashboard boxes are on the floor. Some are half-full of books. Others are closed, sealed with tape, and covered in soot."
    #:exits '(("foyer" . teraum/green-delta/arathel-county/honeyfern-labs/foyer)
      ("hall" . teraum/green-delta/arathel-county/honeyfern-labs/dining-hall)
      ("library" . teraum/green-delta/arathel-county/honeyfern-labs/library))))
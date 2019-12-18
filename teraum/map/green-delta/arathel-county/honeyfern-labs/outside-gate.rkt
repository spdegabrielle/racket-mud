#lang racket

(require "../../../../../rpg-basics/recipes/areas/rooms/basic.rkt")

(provide outside-gate)

(define outside-gate
  (room
     'teraum/green-delta/arathel-county/honeyfern-labs/outside-gate
     #:brief "outside the gate to Honeyfern Laboratories"
     #:description "This is immediately outside the gate of Honeyfern Laboratories. The road leads southwest, elsewhere."
     #:exits '(("gate" . teraum/green-delta/arathel-county/honeyfern-labs/front-path)
               ("southwest" . teraum/green-delta/arathel-county/road-to-honeyfern-labs))))
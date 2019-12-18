#lang racket

(require "../../../../rpg-basics/recipes/areas/rooms/store.rkt")

(provide belys-blades)

(define belys-blades
  (store
   'teraum/arathel-county/belys-blades
   #:brief "Bely's Blades"
   #:description "This is Bely's Blades, a two-storey stone tower hewn from an outcrop of granite, with a slate roof. It is dimly lit by paper lanterns, and fairly shabby. Ingag Bely sells weapons she buys from adventurers exploring nearby dungeons. A door leads outside, to the Arathel-Ack road."
   #:exits '(("out" . teraum/arathel-county/south-arathel-ack-road))))
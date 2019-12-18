#lang racket

(require "../../../recipes/areas/green-delta/ack/gate.rkt")

(provide eastgate)

(define eastgate
  (gate
   'teraum/green-delta/ack/eastgate
   #:brief "Eastgate"
   #:description "This is Eastgate, the appropriately-named eastern gate of the city of Ack. The road here leads west into the Tin Ward, and east toward the town of Bellybrush."
   #:exits '(("east" . teraum/green-delta/game/bellybrush-road)
             ("west" . teraum/green-delta/ack/tin-ward))))
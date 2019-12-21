#lang racket

(require "../../../../recipes/areas/green-delta/ack/street.rkt")

(provide harbour)

(define harbour
  (street
   'teraum/green-delta/ack/dock-ward/harbour
   #:brief "harbour, Dock Ward, Ack"
   #:description "This is the harbour of Ack, located at the mouth of the Green Delta where it spills into the Optic Ocean."
   #:exits '(("east" . teraum/green-delta/ack/dock-ward))
   #:actions '((1 . "A young Union clerk monitoring those disembarking from the ships turns to his superior and asks, \"What do we do with a drunken sailor?\""))))

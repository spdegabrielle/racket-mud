#lang racket

(require "../../../recipes/areas/green-delta/ack/gate.rkt")

(provide piketown-gate)

(define piketown-gate
  (gate
   'teraum/green-delta/ack/piketown-gate
   #:brief "Piketown Gate"
   #:description "This is the Piketown Gate, leading from the Piketown district of Ack to the Widdershins Road. To the northwest is Piketown. To the south is Widdershins Road."
   #:exits '(("northwest" . teraum/green-delta/ack/piketown)
             ("southeast" . teraum/green-delta/game/widdershins-road))))
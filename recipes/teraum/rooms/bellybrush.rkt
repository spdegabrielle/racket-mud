#lang racket

(require "../../../qualities/container.rkt")
(require "../../../qualities/room.rkt")
(require "../../../qualities/visual.rkt")

(provide teraum-bellybrush)
(define teraum-bellybrush
  (list (void) (list "bellybrush")
        (list
   (room
    'teraum-bellybrush
    (make-hash
     (list (cons "south" 'teraum-marby-county)
           (cons "east" 'teraum-central-plains)
      )))
   (visual
    "Bellybrush"
    "This is the town of Bellybrush.")
   (container (list)))))

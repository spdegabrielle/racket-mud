#lang racket

(require "../../../qualities/container.rkt")
(require "../../../qualities/room.rkt")
(require "../../../qualities/visual.rkt")

(provide teraum-sherwyn-county)
(define teraum-sherwyn-county
  (list (void) (list "sherwyn county")
        (list
   (room
    'teraum-sherwyn-county
    (make-hash
     (list (cons "west" 'teraum-marby-county)
           (cons "east" 'teraum-central-plains)
      )))
   (visual
    "Sherwyn County"
    "This is Sherwyn County.")
   (container (list)))))

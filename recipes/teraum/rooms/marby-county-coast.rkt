#lang racket

(require "../../../qualities/container.rkt")
(require "../../../qualities/room.rkt")
(require "../../../qualities/visual.rkt")

(provide teraum-marby-county-coast)
(define teraum-marby-county-coast
  (list (list "marby county") (list "coast")
        (list
   (room
    'teraum-marby-county-coast
    (make-hash
     (list (cons "east" 'teraum-marby-county)
      )))
   (visual
    "coast of Marby County"
    "This is coastal part of Marby County. To the west is the Optic Ocean.")
   (container (list)))))

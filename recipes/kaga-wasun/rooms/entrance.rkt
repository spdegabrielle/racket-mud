#lang racket

(require "../../../qualities/container.rkt")
(require "../../../qualities/room.rkt")
(require "../../../qualities/visual.rkt")

(provide kaga-wasun-entrance)
(define kaga-wasun-entrance
  (list (list "kaga-wasun") (list "entrance")
        (list
   (room
    'kaga-wasun-entrance
    (make-hash
     (list (cons "up" 'kaga-wasun-surface)
           (cons "operations" 'kaga-wasun-operations)
           (cons "cabins" 'kaga-wasun-cabins))))
   (visual
    "Entrance to Kaga-Wasun"
    "This is the entrance to Kaga-Wasun. From here, an elevator leads to the surface, while an elevator provides access to individual facilities.")
   (container (list)))))
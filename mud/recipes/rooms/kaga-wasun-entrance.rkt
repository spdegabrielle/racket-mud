#lang racket

(require "../../qualities/room.rkt")
(require "../../qualities/container.rkt")

(provide kaga-wasun-entrance)
(define kaga-wasun-entrance
  (list
   (room
    'kaga-wasun-entrance
    "Entrance to Kaga-Wasun"
    "This is the entrance to Kaga-Wasun. From here, a stairwell leads to the surface, while an elevator provides access to individual facilities."
    (make-hash
     (list (cons "up" 'kaga-wasun-surface)
           (cons "operations" 'kaga-wasun-operations)
           (cons "cabins" 'kaga-wasun-cabins))))
   (container (list))))

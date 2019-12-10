#lang racket

(require "../../../qualities/container.rkt")
(require "../../../qualities/room.rkt")
(require "../../../qualities/visual.rkt")

(provide kaga-wasun-airlock)
(define kaga-wasun-airlock
  (list (list "kaga-wasun") (list "airlock")
        (list
         (room
          'kaga-wasun-airlock
          (make-hash
           (list (cons "inside" 'kaga-wasun-surface)
                 (cons "outside" 'kaga-wasun-outside))))
         (visual
          "Kaga-wasun airlock"
          "This airlock provides access to the surface of the asteroid into which Kaga-wasun is built.")
         (container (list)))))

#lang racket

(require "../../../thing.rkt")
(require "../../../qualities/container.rkt")
(require "../../../qualities/room.rkt")
(require "../../../qualities/visual.rkt")

(provide kaga-wasun-airlock)
(define kaga-wasun-airlock
  (recipe (list "airlock") (list "kaga-wasun")
          (make-hash (list
                      (cons 'visual (visual "Kaga-wasun airlock"
                                            "This airlock provides access to the surface of the asteroid into which Kaga-wasun was built."))
                      (cons 'room (room 'kaga-wasun-airlock
                                        (make-hash
                                         (list (cons "inside" 'kaga-wasun-surface)
                                               (cons "outside" 'kaga-wasun-outside)))))
                      (cons 'container (container (list)))))))
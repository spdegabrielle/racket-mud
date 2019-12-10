#lang racket

(require "../../../../qualities/container.rkt")
(require "../../../../qualities/room.rkt")
(require "../../../../qualities/visual.rkt")

(provide kaga-wasun-cabins)
(define kaga-wasun-cabins
  (list
   (list "kaga-wasun") (list "cabins")
   (list
    (room
     'kaga-wasun-cabins
     (make-hash
      (list (cons "up" 'kaga-wasun-entrance)
            (cons "emsenn" 'kaga-wasun-emsenn-cabin))))
    (visual
     "Kaga-wasun cabins"
     "This is a corridor providing access to the residential cabins of Kaga-wasun. An elevator leads up to the habitat's entrance.")
    (container (list)))))

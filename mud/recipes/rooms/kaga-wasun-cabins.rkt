#lang racket

(require "../../qualities/room.rkt")
(require "../../qualities/container.rkt")

(provide kaga-wasun-cabins)
(define kaga-wasun-cabins
  (list
   (room
    'kaga-wasun-cabins
    "Kaga-Wasun Cabins"
    "This is a corridor providing access to the residential cabins of Kaga-wasun. An elevator leads up to the habitat's entrance."
    (make-hash
     (list (cons "up" 'kaga-wasun-entrance)
           (cons "emsenn" 'kaga-wasun-emsenn-cabin))))
   (container (list))))

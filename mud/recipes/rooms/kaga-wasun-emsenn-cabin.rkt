#lang racket

(require "../../qualities/room.rkt")
(require "../../qualities/container.rkt")

(provide kaga-wasun-emsenn-cabin)
(define kaga-wasun-emsenn-cabin
  (list
   (room
    'kaga-wasun-emsenn-cabin
    "emsenn's cabin"
    "This is a small residential cabin, square and approximately 5 meters across. There is a cot in one corner, and several squashboard boxes stacked in the center of the space. A doorway leads out to a corridor."
    (make-hash
     (list (cons "corridor" 'kaga-wasun-cabins))))
   (container (list))))

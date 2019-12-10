#lang racket

(require "../../../../qualities/container.rkt")
(require "../../../../qualities/room.rkt")
(require "../../../../qualities/visual.rkt")

(provide kaga-wasun-emsenns-cabin)
(define kaga-wasun-emsenns-cabin
  (list (list "emsenn's") (list "cabin")
        (list
         (room
          'kaga-wasun-emsenns-cabin
          (make-hash
     (list (cons "hallway" 'kaga-wasun-cabins))))
         (visual
          "emsenn's cabin"
          "This is emsenn's cabin in Kaga-wasun.")
   (container (list)))))

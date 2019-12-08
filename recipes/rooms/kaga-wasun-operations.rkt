#lang racket

(require "../../qualities/room.rkt")
(require "../../qualities/container.rkt")

(provide kaga-wasun-operations)
(define kaga-wasun-operations
  (list
   (room
    'kaga-wasun-operations
    "Kaga-Wasun Operations Facility"
    "This is the operations facility of Kaga-Wasun habitat. This is where the duties of the habitat's maintenance will be organized. Currently, the room is full of wooden crates and pallets, yet to be unpacked and installed. An elevator leads up to the habitat's entrance."
    (make-hash
     (list (cons "up" 'kaga-wasun-entrance))))
   (container (list))))

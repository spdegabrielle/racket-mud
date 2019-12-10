#lang racket

(require "../../../qualities/container.rkt")
(require "../../../qualities/room.rkt")
(require "../../../qualities/visual.rkt")

(provide kaga-wasun-operations)
(define kaga-wasun-operations
  (list (list "kaga-wasun") (list "operations")
        (list
   (room
    'kaga-wasun-operations
    (make-hash
     (list (cons "up" 'kaga-wasun-entrance))))
   (room
    'kaga-wasun-landing-bay
    (make-hash
     (list (cons "inside" 'kaga-wasun-surface)
           (cons "teraum" 'teraum-marby-county))))
   (visual
    "Kaga-Wasun Operations Facility"
    "This is the operations facility of Kaga-Wasun habitat. This is where the duties of the habitat's maintenance will be organized. Currently, the room is full of wooden crates and pallets, yet to be unpacked and installed. An elevator leads up to the habitat's entrance.")
   (container (list)))))

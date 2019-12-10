#lang racket

(require "../../../qualities/container.rkt")
(require "../../../qualities/room.rkt")
(require "../../../qualities/visual.rkt")

(provide teraum-ack)
(define teraum-ack
  (list (void) (list "Ack")
        (list
   (room
    'teraum-ack
    (make-hash
     (list (cons "east" 'teraum-bellybrush)
      )))
   (visual
    "Ack"
    "This is the city of Ack.")
   (container (list)))))

#lang racket

(require "../../qualities/room.rkt")
(require "../../qualities/container.rkt")
(provide hala-bridge)
(define hala-bridge
  (list
   (room
    'hala-bridge
    "Bridge of the Hala"
    "This is the bridge of the Hala."
    (make-hash
     (list (cons "port" "hala-ready-room"))))
   (container
    (list))))

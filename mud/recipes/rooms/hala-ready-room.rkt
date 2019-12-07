#lang racket


(require "../../qualities/room.rkt")
(provide hala-ready-room)
(define hala-ready-room
   (list
    (room
     'hala-ready-room
     "Ready Room of the Hala"
     "This is the ready room of the Hala."
     (make-hash
      (list (cons "starboard" "hala-bridge"))))))
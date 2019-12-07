#lang racket

(require racket/serialize)

(require "../logger.rkt")
(require "../service.rkt")
(require "../thing.rkt")
(require "../qualities/room.rkt")

(require "../recipes/rooms/hala-bridge.rkt")
(require "../recipes/rooms/hala-ready-room.rkt")

(define required-rooms
  (list hala-bridge
        hala-ready-room))

(provide create-rooms
         get-room
         room-service
         known-rooms)


(define known-rooms (make-hash))


(define (create-rooms)
  (map
   (lambda (this-room)
     (let ([room-thing (create-thing this-room)])
       (hash-set! known-rooms
                  (get-thing-quality room-thing room? room-id)
                  room-thing)))
     required-rooms))

(define (get-room id)
  (hash-ref known-rooms id))

(define room-service (service 'room-service
                              create-rooms #f #f #f))
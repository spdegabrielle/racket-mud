#lang racket

(require racket/serialize)

(require "../logger.rkt")
(require "../service.rkt")
(require "../thing.rkt")
(require "../qualities/room.rkt")

(require "../recipes/rooms/kaga-wasun-cabins.rkt")
(require "../recipes/rooms/kaga-wasun-emsenn-cabin.rkt")
(require "../recipes/rooms/kaga-wasun-entrance.rkt")
(require "../recipes/rooms/kaga-wasun-surface.rkt")
(require "../recipes/rooms/kaga-wasun-operations.rkt")

(define required-rooms
  (list kaga-wasun-cabins
        kaga-wasun-emsenn-cabin
        kaga-wasun-entrance
        kaga-wasun-surface
        kaga-wasun-operations))

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
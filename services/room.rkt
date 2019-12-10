#lang racket

(require racket/serialize)

(require "../logger.rkt")
(require "../service.rkt")
(require "../thing.rkt")
(require "../qualities/container.rkt")
(require "../qualities/room.rkt")

(require "../recipes/kaga-wasun/rooms/airlock.rkt")
(require "../recipes/kaga-wasun/rooms/cabins/hallway.rkt")
(require "../recipes/kaga-wasun/rooms/cabins/emsenn.rkt")
(require "../recipes/kaga-wasun/rooms/entrance.rkt")
(require "../recipes/kaga-wasun/rooms/landing-bay.rkt")
(require "../recipes/kaga-wasun/rooms/surface.rkt")
(require "../recipes/kaga-wasun/rooms/operations.rkt")
(require "../recipes/teraum/rooms/ack.rkt")
(require "../recipes/teraum/rooms/arathel-county.rkt")
(require "../recipes/teraum/rooms/bellybrush.rkt")
(require "../recipes/teraum/rooms/eridrin.rkt")
(require "../recipes/teraum/rooms/honeyfern-laboratories/foyer.rkt")
(require "../recipes/teraum/rooms/marby-county.rkt")
(require "../recipes/teraum/rooms/marby-county-coast.rkt")
(require "../recipes/teraum/rooms/sherwyn-county.rkt")

(define required-rooms
  (list kaga-wasun-airlock
        kaga-wasun-cabins
        kaga-wasun-emsenns-cabin
        kaga-wasun-entrance
        kaga-wasun-landing-bay
        kaga-wasun-surface
        kaga-wasun-operations
        teraum-ack
        teraum-arathel-county
        teraum-bellybrush
        teraum-eridrin
        teraum-honeyfern-laboratories-foyer
        teraum-marby-county
        teraum-marby-county-coast
        teraum-sherwyn-county
        ))

(provide create-rooms
         get-room
         room-service
         known-rooms)


(define known-rooms (make-hash))


(define (create-room recipe)
  (let ([room-thing
         (create-thing (first recipe)
                       (second recipe)
                       (third recipe))])
    room-thing))

(define (create-rooms)
  (map
   (lambda (this-room)
     (let ([room-thing
            (create-thing (first this-room)
                          (second this-room)
                          (third this-room))])
       (let ([real-inventory (list)])
         (map (lambda (item-recipe)
                (set! real-inventory
                      (append real-inventory
                              (list (create-thing item-recipe)))))
              (get-container-inventory room-thing))
         (set-container-inventory room-thing real-inventory))
       (hash-set! known-rooms
                  (get-thing-quality room-thing room? room-id)
                  room-thing)))
     required-rooms))

(define (get-room id)
  (cond [(hash-has-key? known-rooms id) (hash-ref known-rooms id)]
        [else #f]))

(define room-service (service 'room-service
                              create-rooms #f #f #f))
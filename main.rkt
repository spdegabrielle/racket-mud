#lang racket
;; Required services
; (require "./services/mudsocket.rkt") lets get back to that once we
; the kinks of Things worked out.
(require "./services/action.rkt")
(require "./services/mudsocket.rkt")
(require "./services/room.rkt")
(require "./services/user.rkt")
(define required-services
  (list
   action-service
   mudsocket-service
   user-service
   room-service))
;; Required events
; (require "./events/broadcast.rkt")
(require "./events/move.rkt")
(require "./events/parse.rkt")
(require "./events/send.rkt")
(define required-events
  (hash
   ; 'broadcast broadcast-event
   'send send-event
   'parse parse-event
   'move move-event
   ))
;; Required ...modules?
(require "engine.rkt")
(require "logger.rkt")
(require "thing.rkt")

(provide required-services
         required-events)


(void
 (current-logger mudlogger)
 (thread 
  (λ()(let loop ()
        (define v (sync mudlog-receiver))
        (printf "[~a] ~a\n" (vector-ref v 0) (vector-ref v 1)) 
        (loop)))))

(when (load-mud required-events required-services)
  (when (start-mud)
    (printf
     (format "---\n\n\nRoom's inventory is ~a\n\n\n---"
             (get-thing-quality-attribute (get-room 'teraum-eridrin) 'container 'inventory)))
    (run-mud)))
;
;(require "./thing.rkt")
;(require "./qualities/container.rkt")
;(require "./qualities/physical.rkt")
;(require "./qualities/room.rkt")
;(require "./recipes/folk/bob.rkt")
;(require "./recipes/rooms/hala-bridge.rkt")
;(define bob-thing (create-thing bob))
;(define hala-bridge-thing (create-thing hala-bridge))
;(get-physical-proper-name bob-thing) ; "Bob"
;(get-physical-location bob-thing) ; #<void>
;(schedule 'move (hash 'mover bob-thing 'destination hala-bridge-thing))
;(tock)
;(get-physical-location bob-thing) ; #<thing>
;(get-room-name (get-physical-location bob-thing)) ; "Bridge of the Hala"

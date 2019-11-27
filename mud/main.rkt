#lang racket
;; Required services
(require "./services/mudsocket.rkt")
(define required-services
  (list
   mudsocket-service))
;; Required events
(require "./events/broadcast.rkt")
(require "./events/send.rkt")
(require "./events/parse.rkt")
(define required-events
  (hash
   'broadcast broadcast-event
   'send send-event
   'parse parse-event))
;; Required ...modules?
(require "engine.rkt")
(require "logger.rkt")

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
    (run-mud)))
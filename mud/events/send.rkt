#lang racket


(require "../data-structures/event.rkt")
(require "../data-structures/thing.rkt")
(require "../qualities/client.rkt")

(provide send-event)

(define (send-procedure payload)
  (when (hash-has-key? payload 'recipient)
    (let ([recipient (hash-ref payload 'recipient)])
      (when (thing-has-quality? recipient 'client)
        ((client-respond-procedure recipient)
         recipient
         (hash-ref payload 'message))))))

(define send-event (event 'send send-procedure))
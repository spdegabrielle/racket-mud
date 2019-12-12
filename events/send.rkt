#lang racket

(require "../thing.rkt")
(require "../qualities/client.rkt")

(provide send-event)

(define (send-event payload)
  (when (hash-has-key? payload 'recipient)
    (let ([recipient (hash-ref payload 'recipient)])
      (when (thing-has-quality? recipient 'client)
        ((get-client-respond-procedure recipient)
         recipient
         (hash-ref payload 'message))))))
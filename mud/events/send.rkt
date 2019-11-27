#lang racket

(require "../thing.rkt")

(provide send-event)
(define (send-event payload)
  (when (hash-has-key? payload 'recipient)
    (let ([recipient (hash-ref payload 'recipient)])
      (when (hash-has-key? (thing-qualities recipient) 'send-procedure)
        ((hash-ref (thing-qualities recipient) 'send-procedure)
         recipient
         (hash-ref payload 'message))))))
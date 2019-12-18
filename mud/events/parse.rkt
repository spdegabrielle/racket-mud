#lang racket

(require "../data-structures/thing.rkt")
(require "../qualities/client.rkt")

(require "../data-structures/event.rkt")

(provide parse-event)

(define parse-event
  (event 'parse
         (lambda (payload)
           (let ([client #f] [line #f])
             (when (hash-has-key? payload 'client)
               (set! client (hash-ref payload 'client)))
             (when (hash-has-key? payload 'line)
               (set! line (hash-ref payload 'line)))
             (when (and (thing? client) (string? line))
               (when (thing-has-quality? client 'client)
                 ((client-receive-procedure client) client line)))))))
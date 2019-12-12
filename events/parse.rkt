#lang racket

(require "../thing.rkt")
(require "../qualities/client.rkt")

(provide parse-event)
(define (parse-event payload)
  (when (hash-has-key? payload 'client)
    (let ([client (hash-ref payload 'client)])
      (when (hash-has-key? payload 'line)
        (let ([line (hash-ref payload 'line)])
          (when (thing-has-quality? client 'client)
            (let ([parser
                   (get-client-receive-procedure client)])
              (parser client line))))))))
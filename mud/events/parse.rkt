#lang racket

(require "../thing.rkt")

(provide parse-event)
(define (parse-event payload)
  (when (hash-has-key? payload 'client)
    (let ([client (hash-ref payload 'client)])
      (when (hash-has-key? payload 'line)
        (let ([line (hash-ref payload 'line)])
          (when (hash-has-key? (thing-qualities client)
                               'parse-procedure)
            (let ([parser
                   (hash-ref (thing-qualities client)
                             'parse-procedure)])
              (parser client line))))))))
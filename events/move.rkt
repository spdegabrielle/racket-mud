#lang racket

(require "../thing.rkt")
(require "../qualities/container.rkt")
(require "../qualities/physical.rkt")

(provide move-event)

(define (move-event payload)
  (when (and
         (hash-has-key? payload 'mover)
         (hash-has-key? payload 'destination))
    (let* ([mover (hash-ref payload 'mover)]
           [destination (hash-ref payload 'destination)])
      (move-thing-into-container-inventory mover destination))))
    
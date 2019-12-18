#lang racket

(require "../../mud/data-structures/event.rkt")
(require "../../mud/data-structures/thing.rkt")


(require "../qualities/container.rkt")
(require "../qualities/physical.rkt")

(provide move-event)


(define (move-procedure payload)
  (when (and
         (hash-has-key? payload 'mover)
         (hash-has-key? payload 'destination))
    (let* ([mover (hash-ref payload 'mover)]
           [destination (hash-ref payload 'destination)])
      (move-thing-into-container-inventory mover destination))))
    
(define move-event (event 'move move-procedure))
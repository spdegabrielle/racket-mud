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
           [current-location (get-physical-location mover)]
           [destination (hash-ref payload 'destination)])
      (when (thing? current-location)
        (remove-thing-from-container-inventory mover current-location))
      (add-thing-to-container-inventory mover destination)
      (set-physical-location mover destination))))
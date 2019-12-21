#lang racket

(require "../../mud/engine.rkt")
(require "../../mud/data-structures/event.rkt")
(require "../../mud/utilities/thing.rkt")


(require "../qualities/container.rkt")
(require "../qualities/physical.rkt")
(require "../qualities/visual.rkt")

(provide move-event)


(define (move-procedure payload)
  (when (and
         (hash-has-key? payload 'mover)
         (hash-has-key? payload 'destination))
    (let* ([mover (hash-ref payload 'mover)]
           [destination (hash-ref payload 'destination)])
      (when (thing-has-quality? mover 'client)
        (schedule 'send (hash 'recipient mover 'message (format "You move into ~a" (cond [(thing-has-quality? destination 'visual) (visual-brief destination)] [else (first-noun destination)])))))
      (when (thing-has-quality? destination 'client)
        (schedule 'send (hash 'recipient destination 'message (format "~a moves into your inventory." (cond [(thing-has-quality? mover 'visual) (visual-brief mover)] [else (first-noun mover)])))))
      (move-thing-into-container-inventory mover destination))))
    
(define move-event (event 'move move-procedure))
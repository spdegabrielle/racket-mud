#lang racket

(require "../../mud/engine.rkt")
(require "../../mud/data-structures/event.rkt")
(require "../../mud/data-structures/thing.rkt")
(require "../../mud/utilities/recipe.rkt")


(require "../qualities/collectible.rkt")
(require "../qualities/physical.rkt")

(provide collect-event)


(define (collect-procedure payload)
  (log-debug "collection procedure triggered: ~a" payload)
  (when (and
         (hash-has-key? payload 'collector)
         (hash-has-key? payload 'target))
    (let* ([collector (hash-ref payload 'collector)]
           [target (hash-ref payload 'target)])
      (log-debug "target is ~a" (first-noun target))
      (schedule 'send (hash 'recipient collector 'message (format "You collect ~a" (first-noun target))))
      (schedule 'move
                (hash 'mover (make-recipe (collectible-result target))
                      'destination collector)))))

(define collect-event (event 'collect collect-procedure))
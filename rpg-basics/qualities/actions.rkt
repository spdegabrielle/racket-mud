#lang racket

(require "../data-structures/action-record.rkt")
(require "../../mud/data-structures/thing.rkt")
(require "../../mud/data-structures/quality.rkt")
(require "../../mud/utilities/thing.rkt")
(require "../services/action.rkt")

(provide actions
         action)

(struct actions-struct (listing) #:mutable)

(struct action-recipe (chance task))

(define (get-actions-struct thing)
  (thing-quality-structure thing 'actions))

(define (actions-listing thing)
  (actions-struct-listing (thing-quality-structure thing 'actions)))
(define (set-actions-listing! thing value)
  (set-actions-struct-listing! (thing-quality-structure thing 'actions) value))

(define (apply-actions-quality thing)
  (let ([created-actions (list)])
    (log-debug "applying actions quality to ~a" (first-noun thing))
    (for-each (lambda (action-recipe)
                (when (action-recipe? action-recipe)
                  (let ([action-record (action-record thing
                                             (action-recipe-chance action-recipe)
                                             (action-recipe-task action-recipe))])
                    (set! created-actions (append (list action-record) created-actions))
                    (let ([action-chance
                           (action-record-chance action-record)])
                      (hash-set!
                       known-actions
                       action-chance
                       (cond
                         [(hash-has-key? known-actions action-chance)
                          (append (list action-record)
                                  (hash-ref known-actions
                                            action-chance))]
                         [else (list action-record)]))))))
              (actions-listing thing))
    (set-actions-listing! thing created-actions)))

(define (actions listing)
  (quality apply-actions-quality
           (actions-struct listing)))

(define (action chance task)
  (action-recipe chance task))

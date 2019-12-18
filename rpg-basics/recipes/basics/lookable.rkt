#lang racket

(require "../../../mud/data-structures/recipe.rkt")
(require "../../qualities/actions.rkt")
(require "../../qualities/physical.rkt")
(require "../../qualities/visual.rkt")

(provide lookable)

(define (lookable nouns adjectives brief description
                  [action-list #f])
  (recipe (cond [(list? nouns) nouns] [(string? nouns) (list nouns)])
          (cond [(list? adjectives) adjectives] [(string? adjectives) (list adjectives)])
          (make-hash
           (filter
            values
            (list
             (cons 'physical (physical (void) 0))
             (cons 'visual (visual brief description))
             (cond [action-list
                    (cons 'actions (actions action-list))]
                   [else #f]))))))

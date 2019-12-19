#lang racket

(require "../../../mud/data-structures/recipe.rkt")
(require "../../qualities/actions.rkt")
(require "../../qualities/physical.rkt")
(require "../../qualities/visual.rkt")

(provide lookable)

(define (lookable
         #:nouns nouns #:adjectives [adjectives #f]
         #:brief brief #:description [description #f]
         #:location [location #f] #:actions [action-listing #f])
  (when nouns
    (set! nouns (cond [(list? nouns) nouns] [(string? nouns) (list)])))
  (when adjectives
    (set! adjectives (cond [(list? adjectives) adjectives] [(string? adjectives) (list adjectives)])))
  (recipe
   nouns
   (filter values (cond [adjectives adjectives]
                        [else (list)]))
     (make-hash
      (filter
       values
       (list
        (cond [action-listing
               (cons 'actions (actions action-listing))]
              [else #f])
        (cons 'physical (physical (cond
                                    ; if location: find room matching location, which should be a key
                                    [location location] [else (void)]) 0))
        (cons 'visual (visual brief
                              (cond [description description] [else #f]))))))))
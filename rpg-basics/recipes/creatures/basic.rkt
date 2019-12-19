#lang racket

(require "../../../mud/data-structures/recipe.rkt")
(require "../../qualities/actions.rkt")
(require "../../qualities/container.rkt")
(require "../../qualities/physical.rkt")
(require "../../qualities/visual.rkt")

(provide creature)

(define (creature
         #:nouns [nouns #f] #:adjectives [adjectives #f]
         #:brief [brief #f] #:description [description #f]
         #:location [location #f] #:mass [mass #f]
         #:contents [contents #f] #:actions [action-listing #f])
  (let ([standard-nouns (list "creature")] [standard-adjectives (list)]
        [standard-brief "creature"] [standard-description "This is a creature."]
        [standard-contents (list)]
        [standard-location (void)] [standard-mass 1])
    (when nouns
      (set! nouns (cond [(list? nouns) nouns] [(string? nouns) (list)])))
    (when adjectives
      (set! adjectives (cond [(list? adjectives) adjectives] [(string? adjectives) (list adjectives)])))
    (recipe
     (filter values (cond [nouns (append standard-nouns nouns)]
                          [else standard-nouns]))
     (filter values (cond [adjectives (append standard-adjectives adjectives)]
                          [else standard-adjectives]))
     (make-hash
      (filter
       values
       (list
        (cond [action-listing
               (cons 'actions (actions action-listing))]
              [else #f])
        (cons 'container (container (filter values (append standard-contents contents))))
        (cons 'physical (physical (cond
                                    ; if location: find room matching location, which should be a key
                                    [location location] [else standard-location])
                              (cond [mass mass] [else standard-mass])))
        (cons 'visual (visual (cond [brief brief] [else standard-brief])
                              (cond [description description] [else standard-description])))))))))
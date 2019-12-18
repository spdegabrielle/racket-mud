#lang racket

(require "../../../../mud/data-structures/recipe.rkt")
(require "../../../qualities/actions.rkt")
(require "../../../qualities/area.rkt")
(require "../../../qualities/container.rkt")
(require "../../../qualities/visual.rkt")

(provide outdoors)

(define (outdoors id
         #:nouns [nouns #f] #:adjectives [adjectives #f]
         #:brief [brief #f] #:description [description #f]
         #:exits [exits #f]
         #:contents [contents #f] #:actions [action-listing #f])
  (let ([standard-nouns (list "outdoors")] [standard-adjectives (list)]
        [standard-brief "outdoors"] [standard-description "This is an outside area."]
        [standard-contents (list)])
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
        (cons 'area (area id (cond [exits
                                    (make-hash exits)]
                                   [else (make-hash)])))
        (cons 'container (container (filter values (append standard-contents contents))))
        (cons 'visual (visual (cond [brief brief] [else standard-brief])
                              (cond [description description] [else standard-description])))))))))
#lang racket

(require (prefix-in basics/ "../../../../rpg-basics/recipes/areas/outdoors/field.rkt"))
(require "../../../../rpg-basics/recipes/basics/lookable.rkt")

(provide field)

(define (field id
         #:nouns [nouns #f] #:adjectives [adjectives #f]
         #:brief [brief #f] #:description [description #f]
         #:contents [contents #f] #:actions [action-listing #f]
         #:exits [exits #f])
  (let ([standard-nouns (list "field")]
        [standard-brief "field in the Gloaming"] [standard-description "This is a field in the Gloaming."]
        [standard-contents (list)]
        [standard-actions '((1 . "The ground slowly and softly vibrates for a moment."))])
    (when nouns
      (set! nouns (cond [(list? nouns) nouns] [(string? nouns) (list)])))
    (when adjectives
      (set! adjectives (cond [(list? adjectives) adjectives] [(string? adjectives) (list adjectives)])))
    (basics/field
     id
     #:nouns (filter values (cond
                              [nouns (append standard-nouns nouns)]
                              [else standard-nouns]))
     #:brief (cond [brief brief] [else standard-brief])
     #:description (cond [description description] [else standard-description])
     #:contents (cond [contents (append contents standard-contents)] [else standard-contents])
     #:actions (cond [action-listing (append action-listing standard-actions)]
                     [else standard-actions])
     #:exits exits)))
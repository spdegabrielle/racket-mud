#lang racket

(require "../../../rpg-basics/recipes/creatures/basic.rkt")

(provide garlic-boar)

(define (garlic-boar
         #:nouns [nouns #f] #:adjectives [adjectives #f]
         #:brief [brief #f] #:description [description #f]
         #:contents [contents #f] #:actions [action-listing #f]
         #:location [location #f] #:mass [mass #f])
  (let ([standard-nouns (list "boar")] [standard-adjectives (list "garlic")]
        [standard-brief "garlic boar"] [standard-description "This is a garlic boar, named because its snout resembles a bulb of garlic."])
    (when nouns
      (set! nouns (cond [(list? nouns) nouns] [(string? nouns) (list)])))
    (when adjectives
      (set! adjectives (cond [(list? adjectives) adjectives] [(string? adjectives) (list adjectives)])))
    (creature
     #:nouns (filter values (cond
                              [nouns (append standard-nouns nouns)]
                              [else standard-nouns]))
     #:adjectives (filter values (cond
                              [adjectives (append standard-adjectives adjectives)]
                              [else standard-adjectives]))
     #:brief (cond [brief brief] [else standard-brief])
     #:description (cond [description description] [else standard-description])
     #:contents (cond [contents contents] [else (list)])
     #:location (cond [location location] [else #f])
     #:mass (cond [mass mass] [else #f])
     #:actions (cond [action-listing action-listing] [else #f]))))
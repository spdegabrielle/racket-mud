#lang racket

(require (prefix-in basics/ "../../../../../rpg-basics/recipes/areas/outdoors/urban-district.rkt"))

(provide district)

(define (district id
         #:nouns [nouns #f] #:adjectives [adjectives #f]
         #:brief [brief #f] #:description [description #f]
         #:contents [contents #f] #:actions [action-listing #f]
         #:exits [exits #f])
  (let ([standard-nouns (list "district")]
        [standard-brief "district of Ack"] [standard-description "This is one of the districts of Ack."])
    (when nouns
      (set! nouns (cond [(list? nouns) nouns] [(string? nouns) (list)])))
    (when adjectives
      (set! adjectives (cond [(list? adjectives) adjectives] [(string? adjectives) (list adjectives)])))
    (basics/urban-district
     id
     #:nouns (filter values (cond
                              [nouns (append standard-nouns nouns)]
                              [else standard-nouns]))
     #:brief (cond [brief brief] [else standard-brief])
     #:description (cond [description description] [else standard-description])
     #:contents (cond [contents contents] [else (list)])
     #:actions action-listing
     #:exits exits)))
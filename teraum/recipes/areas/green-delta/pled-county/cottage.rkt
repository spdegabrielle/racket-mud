#lang racket

(require (prefix-in basics/ "../../../../../rpg-basics/recipes/areas/rooms/cottage.rkt"))

(provide cottage)

(define (cottage id
         #:nouns [nouns #f] #:adjectives [adjectives #f]
         #:brief [brief #f] #:description [description #f]
         #:contents [contents #f] #:actions [action-listing #f]
         #:exits [exits #f])
  (let ([standard-nouns (list "road")]
        [standard-brief "cottage in Pled County"] [standard-description "This is a cottage in Pled County."]
        [standard-contents (list)])
    (when nouns
      (set! nouns (cond [(list? nouns) nouns] [(string? nouns) (list)])))
    (when adjectives
      (set! adjectives (cond [(list? adjectives) adjectives] [(string? adjectives) (list adjectives)])))
    (basics/cottage
     id
     #:nouns (filter values (cond
                              [nouns (append standard-nouns nouns)]
                              [else standard-nouns]))
     #:brief (cond [brief brief] [else standard-brief])
     #:description (cond [description description] [else standard-description])
     #:contents (cond [contents (append contents standard-contents)] [else standard-contents])
     #:actions action-listing
     #:exits exits)))
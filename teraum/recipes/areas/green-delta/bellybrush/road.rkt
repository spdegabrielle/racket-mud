#lang racket

(require (prefix-in basics/ "../../../../../rpg-basics/recipes/areas/outdoors/town-road.rkt"))
(require "../../../../../rpg-basics/recipes/basics/lookable.rkt")

(provide road)
(define (road id
         #:nouns [nouns #f] #:adjectives [adjectives #f]
         #:brief [brief #f] #:description [description #f]
         #:contents [contents #f] #:actions [action-listing #f]
         #:exits [exits #f])
  (let ([standard-nouns (list "road")]
        [standard-brief "road in Bellybrush"] [standard-description "This is a road in the town of Bellybrush."]
        [standard-contents (list)])
    (when nouns
      (set! nouns (cond [(list? nouns) nouns] [(string? nouns) (list)])))
    (when adjectives
      (set! adjectives (cond [(list? adjectives) adjectives] [(string? adjectives) (list adjectives)])))
    (basics/town-road
     id
     #:nouns (filter values (cond
                              [nouns (append standard-nouns nouns)]
                              [else standard-nouns]))
     #:brief (cond [brief brief] [else standard-brief])
     #:description (cond [description description] [else standard-description])
     #:contents (cond [contents (append contents standard-contents)] [else standard-contents])
     #:actions action-listing
     #:exits exits)))
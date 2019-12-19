#lang racket

(require (prefix-in basics/ "../../../../rpg-basics/recipes/areas/outdoors/rural-road.rkt"))
(require "../../../../rpg-basics/recipes/basics/lookable.rkt")

(provide rural-road)

(define road-lookable
  (lookable
   #:nouns "road"
   #:adjectives "dirt"
   #:brief "dirt road"
   #:description "The road here is packed dirt."))
(define dirt-lookable
  (lookable
   #:nouns '("dirt" "silt" "loam")
   #:adjectives '("brown" "rich")
   #:brief "dirt"
   #:description "The dirt here is a rich brown: silt, clay, and humus."))

(define (rural-road id
         #:nouns [nouns #f] #:adjectives [adjectives #f]
         #:brief [brief #f] #:description [description #f]
         #:contents [contents #f] #:actions [action-listing #f]
         #:exits [exits #f])
  (let ([standard-nouns (list "road")]
        [standard-brief "road in the Central Plains"] [standard-description "This is a road in the Central Plains."]
        [standard-contents (list road-lookable dirt-lookable)])
    (when nouns
      (set! nouns (cond [(list? nouns) nouns] [(string? nouns) (list)])))
    (when adjectives
      (set! adjectives (cond [(list? adjectives) adjectives] [(string? adjectives) (list adjectives)])))
    (basics/rural-road
     id
     #:nouns (filter values (cond
                              [nouns (append standard-nouns nouns)]
                              [else standard-nouns]))
     #:brief (cond [brief brief] [else standard-brief])
     #:description (cond [description description] [else standard-description])
     #:contents (cond [contents (append contents standard-contents)] [else standard-contents])
     #:actions action-listing
     #:exits exits)))
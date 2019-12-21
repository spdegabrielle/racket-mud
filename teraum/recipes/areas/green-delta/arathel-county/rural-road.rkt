#lang racket

(require "../../../../../mud/utilities/list.rkt")
(require (prefix-in basics/ "../../../../../rpg-basics/recipes/areas/outdoors/rural-road.rkt"))
(require "../../../../../rpg-basics/recipes/basics/lookable.rkt")

(provide rural-road)

(define road-lookable
  (lookable
   #:nouns "road"
   #:adjectives "dirt"
   #:brief "dirt road"
   #:description "The road here is packed dirt; its hue a grey sort of brown."))
(define dirt-lookable
  (lookable
   #:nouns '("dirt" "silt" "loam")
   #:adjectives '("ash" "brown" "grey" "grey-brown")
   #:brief "dirt"
   #:description "The dirt here is an ash, grey-brown color: silt and loam."))

(define (rural-road id
         #:nouns [nouns #f] #:adjectives [adjectives #f]
         #:brief [brief #f] #:description [description #f]
         #:contents [contents #f] #:actions [action-listing #f]
         #:exits [exits #f])
  (let ([standard-nouns (list "road")]
        [standard-brief "road in Arathel County"] [standard-description "This is a road in Arathel County."]
        [standard-contents (list road-lookable dirt-lookable)])
    (basics/rural-road
     id
     #:nouns (merge-stringy-lists nouns standard-nouns)
     #:brief (cond [brief brief] [else standard-brief])
     #:description (cond [description description] [else standard-description])
     #:contents (merge-stringy-lists contents standard-contents)
     #:actions action-listing
     #:exits exits)))
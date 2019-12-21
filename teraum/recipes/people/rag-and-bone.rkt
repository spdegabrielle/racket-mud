#lang racket

(require "../../../mud/utilities/list.rkt")
(require "../../../rpg-basics/recipes/people/vendor.rkt")

(provide rag-and-bone)

(define (rag-and-bone
         #:nouns [nouns #f] #:adjectives [adjectives #f]
         #:brief [brief #f] #:description [description #f]
         #:actions [action-listing #f] #:mass [mass #f]
         #:location [location #f] #:trades [trade-list #f])
  (vendor
   #:nouns (merge-stringy-lists nouns)
   #:adjectives (merge-stringy-lists adjectives)
   #:brief brief #:description description
   #:actions actions #:mass mass
   #:location location #:trades trade-list))
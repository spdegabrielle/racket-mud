#lang racket

(require "../../../mud/utilities/list.rkt")
(require "../../../mud/utilities/recipe.rkt")
(require (prefix-in quality/ "../../qualities/collectible.rkt"))
(require "./lookable.rkt")

(provide collectible)

(define (collectible
         #:nouns [nouns #f] #:adjectives [adjectives #f]
         #:brief [brief #f] #:description [description #f]
         #:actions [action-listing #f]
         #:location [location #f]
         #:collectible collectible-record)
    (recipe-with-added-quality
     (lookable
      #:nouns (merge-stringy-lists nouns)
      #:adjectives (merge-stringy-lists adjectives)
      #:brief brief
      #:description description
      #:location location
      #:actions action-listing)
     (cons 'collectible (quality/collectible (first collectible-record)
                                             (second collectible-record)
                                             (third collectible-record)))))
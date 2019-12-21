#lang racket
(require "../../../../mud/utilities/list.rkt")
(require "./basic.rkt")
(require "../../basics/collectible.rkt")
(require "../../basics/item.rkt")
(provide urban-district)

(define trash
  (collectible
   #:nouns "trash"
   #:brief "trash"
   #:description "This is some trash, a mix of paper and other detritus created by urban living."
   #:collectible (list 0 (void)
                       (item #:nouns "trash"
                             #:brief "trash"
                             #:description "This is a crumbled up piece of paper."))))

(define (urban-district id
         #:nouns [nouns #f] #:adjectives [adjectives #f]
         #:brief [brief #f] #:description [description #f]
         #:contents [contents #f] #:actions [action-listing #f]
         #:exits [exits #f])
  (let ([standard-nouns "district"] [standard-adjectives "urban"]
        [standard-brief "district"] [standard-description "This is a district in a city."]
        [standard-contents (list trash)])
    (outdoors
     id
     #:nouns (merge-stringy-lists nouns standard-nouns)
     #:adjectives (merge-stringy-lists adjectives standard-adjectives)
     #:brief (cond [brief brief] [else standard-brief])
     #:description (cond [description description] [else standard-description])
     #:contents (merge-stringy-lists contents standard-contents)
     #:actions action-listing
     #:exits exits)))
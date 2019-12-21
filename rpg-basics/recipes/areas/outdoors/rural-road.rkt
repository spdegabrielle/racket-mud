#lang racket


(require "../../../../mud/utilities/list.rkt")

(require "./basic.rkt")

(provide rural-road)

(define (rural-road id
         #:nouns [nouns #f] #:adjectives [adjectives #f]
         #:brief [brief #f] #:description [description #f]
         #:contents [contents #f] #:actions [action-listing #f]
         #:exits [exits #f])
  (let ([standard-nouns (list "road")]
        [standard-brief "road"] [standard-description "This is a dirt road in a rural area."])
    (outdoors
     id
     #:nouns (merge-stringy-lists nouns standard-nouns)
     #:adjectives adjectives
     #:brief (cond [brief brief] [else standard-brief])
     #:description (cond [description description] [else standard-description])
     #:contents contents
     #:actions action-listing
     #:exits exits)))
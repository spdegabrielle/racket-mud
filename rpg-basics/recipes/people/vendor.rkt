#lang racket

(require "./basic.rkt")

(provide vendor)

(define (vendor
         #:nouns [nouns #f] #:adjectives [adjectives #f]
         #:brief [brief #f] #:description [description #f]
         #:contents [contents #f] #:actions [action-listing #f]
         #:location [location #f] #:mass [mass #f])
  (let ([standard-nouns (list "vendor")]
        [standard-brief "vendor"] [standard-description "This is a vendor."])
    (person
     #:nouns (filter values (cond
                              [nouns (append standard-nouns nouns)]
                              [else standard-nouns]))
     #:brief (cond [brief brief] [else standard-brief])
     #:description (cond [description description] [else standard-description])
     #:contents (cond [contents contents] [else (list)])
     #:location (cond [location location] [else #f])
     #:mass (cond [mass mass] [else #f])
     #:actions (cond [action-listing action-listing] [else #f]))))
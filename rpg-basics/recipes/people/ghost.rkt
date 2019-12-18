#lang racket

(require "./basic.rkt")

(provide ghost)

(define (ghost
         #:nouns [nouns #f] #:adjectives [adjectives #f]
         #:brief [brief #f] #:description [description #f]
         #:contents [contents #f] #:actions [action-listing #f]
         #:location [location #f] #:mass [mass #f])
  (let ([standard-nouns (list "ghost")]
        [standard-brief "ghost"] [standard-description "This is a ghost."])
    (when nouns
      (set! nouns (cond [(list? nouns) nouns] [(string? nouns) (list)])))
    (when adjectives
      (set! adjectives (cond [(list? adjectives) adjectives] [(string? adjectives) (list adjectives)])))
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
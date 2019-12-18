#lang racket

(require "../../../../mud/data-structures/recipe.rkt")
(require "../../../qualities/actions.rkt")
(require "../../../qualities/container.rkt")
(require "../../../qualities/physical.rkt")
(require "../../../qualities/area.rkt")
(require "../../../qualities/visual.rkt")

(require "./basic.rkt")
(provide inn)

(define (inn id
         #:nouns [nouns #f] #:adjectives [adjectives #f]
         #:brief [brief #f] #:description [description #f]
         #:contents [contents #f] #:actions [action-listing #f]
         #:exits [exits #f])
  (let ([standard-nouns (list "inn")]
        [standard-brief "inn"] [standard-description "This is inside an inn."])
    (when nouns
      (set! nouns (cond [(list? nouns) nouns] [(string? nouns) (list)])))
    (when adjectives
      (set! adjectives (cond [(list? adjectives) adjectives] [(string? adjectives) (list adjectives)])))
    (room id
     #:nouns (filter values (cond
                              [nouns (append standard-nouns nouns)]
                              [else standard-nouns]))
     #:brief (cond [brief brief] [else standard-brief])
     #:description (cond [description description] [else standard-description])
     #:contents contents
     #:actions action-listing
     #:exits exits)))
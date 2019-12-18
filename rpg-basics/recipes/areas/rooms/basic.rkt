#lang racket

(require "../../../../mud/data-structures/recipe.rkt")
(require "../../basics/lookable.rkt")
(require "../../../qualities/actions.rkt")
(require "../../../qualities/area.rkt")
(require "../../../qualities/container.rkt")
(require "../../../qualities/visual.rkt")

(provide room)

(define (room id
         #:nouns [nouns #f] #:adjectives [adjectives #f]
         #:brief [brief #f] #:description [description #f]
         #:exits [exits #f]
         #:contents [contents #f] #:actions [action-listing #f])
  (let ([standard-nouns (list "room")] [standard-adjectives (list)]
        [standard-brief "room"] [standard-description "This is a room."]
        [standard-contents (list)])
    (printf (format "defining recipe for ~a" id))
    (when nouns
      (set! nouns (cond [(list? nouns) nouns] [(string? nouns) (list)])))
    (when adjectives
      (set! adjectives (cond [(list? adjectives) adjectives] [(string? adjectives) (list adjectives)])))
    (recipe
     (filter values (cond [nouns (append standard-nouns nouns)]
                          [else standard-nouns]))
     (filter values (cond [adjectives (append standard-adjectives adjectives)]
                          [else standard-adjectives]))
     (make-hash
      (filter
       values
       (list
        (cond [action-listing
               (cons 'actions (actions action-listing))]
              [else #f])
        (cond [exits
               (cons 'area (area id (make-hash exits)))]
              [else #f])
        (cons 'container (container (cond [contents contents] [else standard-contents])))
        (cons 'visual (visual (cond [brief brief] [else standard-brief])
                              (cond [description description] [else standard-description])))))))))
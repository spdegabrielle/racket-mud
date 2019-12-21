#lang racket

(require "../../../../mud/utilities/list.rkt")
(require "../../../../mud/utilities/recipe.rkt")
(require "../../../qualities/actions.rkt")
(require "../../../qualities/area.rkt")
(require "../../../qualities/container.rkt")
(require "../../../qualities/visual.rkt")

(provide outdoors)

(define (outdoors id
         #:nouns [nouns #f] #:adjectives [adjectives #f]
         #:brief [brief #f] #:description [description #f]
         #:exits [exits #f]
         #:contents [contents #f] #:actions [action-listing #f])
  (let ([standard-nouns (list "outdoors")]
        [standard-brief "outdoors"] [standard-description "This is an outside area."])
    (recipe
     (merge-stringy-lists nouns standard-nouns)
     (merge-stringy-lists adjectives)
     (make-hash
      (filter
       values
       (list
        (cond [action-listing
               (cons 'actions (actions action-listing))]
              [else #f])
        (cons 'area (area id (cond [exits
                                    (make-hash exits)]
                                   [else (make-hash)])))
        (cons 'container (container (merge-stringy-lists contents)))
        (cons 'visual (visual (cond [brief brief] [else standard-brief])
                              (cond [description description] [else standard-description])))))))))
#lang racket

(require "../../../mud/utilities/list.rkt")
(require "../../../mud/utilities/recipe.rkt")
(require "../../qualities/actions.rkt")
(require "../../qualities/physical.rkt")
(require "../../qualities/visual.rkt")

(provide item)

(define (item
         #:nouns [nouns #f] #:adjectives [adjectives #f]
         #:brief [brief #f] #:description [description #f]
         #:actions [action-listing #f] #:mass [mass #f]
         #:location [location #f])
  (recipe
   (merge-stringy-lists nouns)
   (merge-stringy-lists adjectives)
     (make-hash
      (filter
       values
       (list
        (cond [action-listing
               (cons 'actions (actions action-listing))]
              [else #f])
        (cons 'physical (physical (cond
                                    ; if location: find room matching location, which should be a key
                                    [location location] [else (void)])
                                  (cond [mass mass] [else 1])))
        (cons 'visual (visual brief
                              (cond [description description] [else #f]))))))))
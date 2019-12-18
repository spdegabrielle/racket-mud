#lang racket

(require "../../../mud/data-structures/recipe.rkt")
(require "../../../rpg-basics/qualities/actions.rkt")
(require "../../../rpg-basics/qualities/physical.rkt")
(require "../../../rpg-basics/qualities/visual.rkt")

(provide stray-dog)

(define stray-dog
  (recipe (list "dog" "canine")
          (list "stray")
          (make-hash
           (list
            (cons 'physical (physical (void) 1))
            (cons 'visual (visual
                           "stray dog"
                           "This is a healthy-looking stray dog."))
            (cons 'actions (actions
                            (list
                             (action 2 "The stray dog holds its snout up, catching a scent."))))))))

#lang racket
(require "../data-structures/recipe.rkt")
(require "../data-structures/thing.rkt")
(require "../data-structures/quality.rkt")

(provide make-recipe
         recipe-with-added-quality
         (all-from-out "../data-structures/recipe.rkt"))

(define (recipe-with-added-quality recipe quality)
  (let ([new-recipe recipe])
    (hash-set! (recipe-qualities new-recipe) (car quality) (cdr quality))
    new-recipe))

(define (make-recipe recipe)
  (let ([new-thing 
         (thing (generate-thing-id) (recipe-nouns recipe)
                (recipe-adjectives recipe)
                (recipe-qualities recipe))])
    (hash-map (thing-qualities new-thing)
             (lambda (quality-key quality-value)
               ((quality-procedure quality-value) new-thing)))
    new-thing))

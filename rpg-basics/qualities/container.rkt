#lang racket

(require "../../mud/data-structures/thing.rkt")
(require "../../mud/data-structures/quality.rkt")
(require "../../mud/utilities/thing.rkt")
(require "../../mud/utilities/recipe.rkt")


(require "./physical.rkt")

(provide container
         container-inventory
         set-container-inventory!
         add-thing-to-container-inventory!
         remove-thing-from-container-inventory!
         move-thing-into-container-inventory)

(struct container-struct (inventory) #:mutable)


(define (apply-container-quality thing)
  (let ([created-things (list)])
    (for-each (lambda (recipe) (set! created-things (append (list (make-recipe recipe)) created-things))) (container-inventory thing))
    (set-container-inventory! thing created-things)
    (for-each (lambda (item) (set-physical-location! item thing)) (filter-things-with-quality created-things 'physical))))

(define (container inventory)
  (quality apply-container-quality
           (container-struct inventory)))
(define (get-container-structure thing)
  (thing-quality-structure thing 'container))

(define (container-inventory thing)
  (container-struct-inventory (get-container-structure thing)))

(define (set-container-inventory! thing inventory)
  (set-container-struct-inventory! (get-container-structure thing) inventory))

(define (add-thing-to-container-inventory! thing container)
  (set-container-inventory!
   container
   (append (container-inventory container) (list thing))))
   
 ; (let ([inventory (get-container-inventory container)])
  ;   (let ([new-inventory (append inventory (list thing))])
   ;    (set-container-inventory container new-inventory))))


(define (remove-thing-from-container-inventory! thing container)
  (set-container-inventory!
   container
   (remove thing (container-inventory container))))


(define (move-thing-into-container-inventory thing container)
  (let ([current-location (physical-location thing)])
    (when (thing? current-location)
      (remove-thing-from-container-inventory! thing current-location))
    (add-thing-to-container-inventory! thing container)
    (set-physical-location! thing container)))

(define (get-container-inventory-with-quality container quality)
  (let ([matches (list)])
    (map
     (lambda (item)
       (when (thing-has-quality? item quality)
         (set! matches (append matches (list item)))))
     (container-inventory container))
    matches))
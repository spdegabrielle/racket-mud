#lang racket

(require racket/serialize)

(require "../../mud/data-structures/recipe.rkt")
(require "../../mud/data-structures/service.rkt")
(require "../../mud/data-structures/thing.rkt")
(require "../../mud/data-structures/quality.rkt")
(require "../../mud/utilities/recipe.rkt")

(require "../qualities/container.rkt")
(require "../qualities/area.rkt")

(define required-areas (list))




(provide create-map
         get-area
         map-service
         known-areas
         ;get-random-area-from-area-exits
         add-area-recipes-to-known-areas
         )


(define known-areas (make-hash))

(define (create-map)
  (hash-map known-areas
   (lambda (area-recipe-id area-recipe)
     (let ([area-thing
            (make-recipe area-recipe)])
       (hash-set! known-areas (area-id area-thing) area-thing))))
  (hash-map known-areas
   (lambda (area-id area-thing)
     (hash-map (area-exits area-thing)
               (lambda (id exit)
                 (hash-set! (area-exits area-thing) id (get-area exit)))))))

(define (get-area id)
  (cond [(hash-has-key? known-areas id) (hash-ref known-areas id)]
        [else #f]))

(define (add-area-recipes-to-known-areas recipes)
  (for-each (lambda (recipe)
              (hash-set! known-areas (area-id-from-recipe recipe) recipe))
            recipes))

(define (area-id-from-recipe recipe)
  (area-struct-id (quality-structure (hash-ref (recipe-qualities recipe) 'area))))

;(define (get-random-area-from-area-exits thing)
;  (let ([list-of-exits (hash-map (get-area-exits thing) (lambda (direction destination) (cons direction destination)))])
;    (cdr (list-ref list-of-exits (random (length list-of-exits))))))

(define map-service (service 'map-service
                              #f create-map #f #f))

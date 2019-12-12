#lang racket

(require "../thing.rkt")

(provide container
         get-container-inventory
         set-container-inventory!
         add-thing-to-container-inventory
         move-thing-into-container-inventory
         remove-thing-from-container-inventory!
         get-container-inventory-with-quality)

(define (apply-container-quality thing)
  (log-debug "applying the container quality to thing #~a (~a)" (thing-id thing) (first-noun thing))
  (log-debug "its inventory is currently ~a" (get-container-inventory thing))
  (let ([created-things (list)])
    (for-each (lambda (recipe) (set! created-things (append (list (make-recipe recipe)) created-things))) (get-container-inventory thing))
    (set-container-inventory! thing created-things)
    (for-each (lambda (item) (set-thing-quality-attribute! item 'physical 'location thing)) (things-with-quality created-things 'physical)))
  (log-debug "its inventory is now ~a" (map (lambda (item) (first-noun item)) (get-container-inventory thing))))

(define (container inventory)
  (quality apply-container-quality
           (make-hash
            (list
             (cons 'inventory inventory)))))

(define (get-container-inventory thing)
  (get-thing-quality-attribute thing 'container 'inventory))

(define (set-container-inventory! thing things)
  (set-quality-attribute! (get-thing-quality thing 'container) 'inventory things))

(define (add-thing-to-container-inventory thing container)
  (log-debug "adding ~a to the inventory of ~a" (first-noun thing) (first-noun container))
  (set-container-inventory!
   container
   (append (get-thing-quality-attribute container 'container 'inventory) (list thing))))
   
 ; (let ([inventory (get-container-inventory container)])
  ;   (let ([new-inventory (append inventory (list thing))])
   ;    (set-container-inventory container new-inventory))))

(define (remove-thing-from-container-inventory! thing container)
  (set-container-inventory!
   container
   (remove thing (get-container-inventory container))))


(define (move-thing-into-container-inventory thing container)
  (log-debug "moving ~a into ~a" (first-noun thing) (first-noun container))
  (let ([current-location (get-thing-quality-attribute thing 'physical 'location)])
    (when (thing? current-location)
      (log-debug "~a is already in a container, ~a" (first-noun thing) (first-noun current-location))
      (remove-thing-from-container-inventory! thing current-location))
    (add-thing-to-container-inventory thing container)
    (set-thing-quality-attribute! thing 'physical 'location container)))

(define (get-container-inventory-with-quality container quality)
  (let ([matches (list)])
    (map
     (lambda (item)
       (when (thing-has-quality? item quality)
         (set! matches (append matches (list item)))))
     (get-container-inventory container))
    matches))
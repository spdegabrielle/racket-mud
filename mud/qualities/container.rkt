#lang racket

(require "../thing.rkt")

(provide (struct-out container)
         get-container-inventory
         add-thing-to-container-inventory
         remove-thing-from-container-inventory)

(struct container (inventory) #:mutable)

(define (get-container-inventory thing)
  (get-thing-quality thing container? container-inventory))

(define (set-container-inventory thing things)
  (set-thing-quality thing container? set-container-inventory! things))

(define (add-thing-to-container-inventory thing container)
  (let ([inventory (get-container-inventory container)])
     (let ([new-inventory (append inventory (list thing))])
       (set-container-inventory container new-inventory))))

(define (remove-thing-from-container-inventory thing container)
  (let ([inventory (get-container-inventory container)])
     (set-container-inventory container (remove inventory thing))))
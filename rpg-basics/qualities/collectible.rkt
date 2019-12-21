#lang racket

(require "../../mud/utilities/thing.rkt")

(provide collectible
         collectible-skillcheck
         set-collectible-skillcheck!
         collectible-result
         set-collectible-result!)

(struct collectible-struct (recharge skillcheck result) #:mutable)

(define (apply-collectible-quality thing)
  thing)

(define (collectible recharge skillcheck result)
  (quality apply-collectible-quality
           (collectible-struct recharge skillcheck result)))

(define (get-collectible-struct thing)
  (thing-quality-structure thing 'collectible))

(define (collectible-recharge thing)
  (collectible-struct-recharge (get-collectible-struct thing)))
(define (set-collectible-recharge! thing value)
  (set-collectible-struct-recharge! (get-collectible-struct thing) value))

(define (collectible-skillcheck thing)
  (collectible-struct-skillcheck (get-collectible-struct thing)))
(define (set-collectible-skillcheck! thing value)
  (set-collectible-struct-skillcheck! (get-collectible-struct thing) value))

(define (collectible-result thing)
  (collectible-struct-result (get-collectible-struct thing)))
(define (set-collectible-result! thing value)
  (set-collectible-struct-result! (get-collectible-struct thing) value))

#lang racket

(require "../../mud/data-structures/thing.rkt")
(require "../../mud/data-structures/quality.rkt")
(require "../../mud/utilities/thing.rkt")

(provide physical
         physical-location
         set-physical-location!
         physical-mass
         set-physical-mass!)

(struct physical-struct (location mass) #:mutable)

(define (apply-physical-quality thing) (void))

(define (physical location mass)
  (quality apply-physical-quality
           (physical-struct location mass)))

(define (get-physical-struct thing)
  (thing-quality-structure thing 'physical))

(define (physical-location thing)
  (physical-struct-location (get-physical-struct thing)))
(define (set-physical-location! thing value)
  (set-physical-struct-location! (get-physical-struct thing) value))

(define (physical-mass thing)
  (physical-struct-mass (get-physical-struct thing)))
(define (set-physical-mass! thing value)
  (set-physical-struct-mass! (get-physical-struct thing) value))


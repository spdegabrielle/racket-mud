#lang racket

(require "../../mud/data-structures/thing.rkt")
(require "../../mud/data-structures/quality.rkt")
(require "../../mud/utilities/thing.rkt")

(provide visual
         visual-brief
         set-visual-brief!
         visual-description
         set-visual-description!)

(struct visual-struct (brief description) #:mutable)

(define (apply-visual-quality thing)
  thing)

(define (visual brief description)
  (quality apply-visual-quality
           (visual-struct brief description)))

(define (get-visual-struct thing)
  (thing-quality-structure thing 'visual))

(define (visual-brief thing)
  (visual-struct-brief (get-visual-struct thing)))
(define (set-visual-brief! thing value)
  (set-visual-struct-brief! (get-visual-struct thing) value))

(define (visual-description thing)
  (visual-struct-description (get-visual-struct thing)))
(define (set-visual-description! thing value)
  (set-visual-struct-description! (get-visual-struct thing) value))

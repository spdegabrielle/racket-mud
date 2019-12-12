#lang racket

(require "../thing.rkt")

(provide visual
         get-visual-brief
         get-visual-description)


(define (visual brief description)
  (quality apply-visual-quality
  (make-hash
   (list (cons 'brief brief)
         (cons 'description description)))))

(define (apply-visual-quality thing)
  thing)

(define (get-visual-brief thing)
  (get-quality-attribute (get-thing-quality thing 'visual) 'brief))

(define (get-visual-description thing)
  (get-quality-attribute (get-thing-quality thing 'visual) 'description))

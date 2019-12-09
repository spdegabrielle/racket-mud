#lang racket

(require "../thing.rkt")

(provide (struct-out visual)
         get-visual-brief
         get-visual-description)

(struct visual (brief description) #:mutable)

(define (get-visual-brief thing)
  (get-thing-quality thing visual? visual-brief))

(define (get-visual-description thing)
  (get-thing-quality thing visual? visual-description))
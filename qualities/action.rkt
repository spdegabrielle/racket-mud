#lang racket

(require "../thing.rkt")

(provide (struct-out actions)
         get-action-items
         get-visual-description)

(struct actions (items) #:mutable)

(define (get-visual-brief thing)
  (get-thing-quality thing visual? visual-brief))

(define (get-visual-description thing)
  (get-thing-quality thing visual? visual-description))
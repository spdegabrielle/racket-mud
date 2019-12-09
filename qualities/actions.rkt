#lang racket

(require "../thing.rkt")

(provide (struct-out actions)
         get-action-items)

(struct actions (items) #:mutable)

(define (get-action-items thing)
  (get-thing-quality thing actions actions-items))
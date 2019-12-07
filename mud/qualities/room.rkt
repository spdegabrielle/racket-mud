#lang racket

(require "../thing.rkt")

(provide (struct-out room)
         get-room-name
         get-room-description
         get-room-exits
         get-room-exit)

(struct room (id name description exits) #:mutable)


(define (get-room-name thing)
  (get-thing-quality thing room? room-name))
(define (get-room-description thing)
  (get-thing-quality thing room? room-description))
(define (get-room-exits thing)
  (get-thing-quality thing room? room-exits))
(define (get-room-exit thing exit)
  (let ([exits (get-room-exits thing)])
    (when (hash-has-key? exits exit)
      (hash-ref exits exit))))
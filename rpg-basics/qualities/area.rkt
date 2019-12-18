#lang racket

(require "../../mud/data-structures/thing.rkt")
(require "../../mud/data-structures/quality.rkt")
(require "../../mud/utilities/thing.rkt")

(provide area
         (struct-out area-struct)
         area-id
         set-area-id!
         area-exits
         set-area-exits!
         area-exit
         set-area-exit!
         area-has-exits?)

(struct area-struct (id exits) #:mutable)

(define (apply-area-quality thing) (void))

(define (area id exits)
  (quality apply-area-quality
           (area-struct id exits)))

(define (get-area-struct thing)
  (thing-quality-structure thing 'area))

(define (area-id thing)
  (area-struct-id (get-area-struct thing)))
(define (set-area-id! thing value)
  (set-area-struct-id! (get-area-struct thing) value))

(define (area-exits thing)
  (area-struct-exits (get-area-struct thing)))
(define (set-area-exits! thing value)
  (set-area-struct-exits! (get-area-struct thing) value))

(define (area-exit thing exit)
  (hash-ref (area-exits thing) exit))
(define (set-area-exit! thing exit destination)
  (hash-set (area-exits thing) exit destination))

(define (area-has-exits? thing)
  (cond
    [(null? (hash-keys (area-exits thing))) #f]
    [else #t]))
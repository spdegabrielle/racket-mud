#lang racket

(require "../thing.rkt")

(provide room
         get-room-exits
         get-room-exit
         room-has-exits?)

(define (apply-room-quality thing) thing)
(define (room id exits)
  (quality apply-room-quality
           (make-hash
            (list (cons 'id id) (cons 'exits exits)))))

(define (room-has-exits? thing)
  (cond
    [(eq? (get-room-exits thing) (make-hash))
     #f]
    [else #t]))
(define (get-room-exits thing)
  (get-quality-attribute (get-thing-quality thing 'room) 'exits))

(define (get-room-exit thing exit)
  (let ([exits (get-room-exits thing)])
    (when (hash-has-key? exits exit)
      (hash-ref exits exit))))
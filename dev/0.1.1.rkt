#lang racket

(require "0.1.0.rkt")
(require libuuid)

(struct thing/0.1.0 (id names))

(define extant-things/0.1.0 (make-hash))

(define (generate-thing-id/0.1.0)
  (let ([potential-id (substring (uuid-generate/random) 0 35)])
    ; if the ID is already an extant Thing's ID, try again.
    (cond
     [(hash-ref extant-things/0.1.0 potential-id #f)
      (generate-thing-id/0.1.0)]
     [else
      potential-id])))

(define (create-thing/0.1.0)
  (let ([new-thing (thing/0.1.0 (generate-thing-id/0.1.0) (list "thing"))])
    (hash-set! extant-things/0.1.0 (thing/0.1.0-id new-thing) new-thing)))

(define (destroy-thing/0.1.0 id)
  (hash-remove! extant-things/0.1.0 id))

(define (generate-thing-id/0.1.1)
  (let ([potential-id (substring (uuid-generate/random) 0 35)])
    ; if the ID is in the Table of Extant Things, try again.
    (cond
     [(hash-has-key? extant-things/0.1.0 potential-id)
      potential-id]
     [else
      (generate-thing-id/0.1.1)])))

(provide
 thing/0.1.0
 extant-things/0.1.0
 create-thing/0.1.0
 destroy-thing/0.1.0
 generate-thing-id/0.1.1)

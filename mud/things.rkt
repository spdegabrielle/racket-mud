#lang racket

(require libuuid)


(provide
 thing
 extant-things
 create-thing
 destroy-thing
 generate-thing-id)

(struct thing (id names))

(define extant-things (make-hash))


(define (create-thing)
  (let ([new-thing (thing (generate-thing-id) (list "thing"))])
    (hash-set! extant-things (thing-id new-thing) new-thing)))

(define (destroy-thing id)
  (hash-remove! extant-things id))

(define (generate-thing-id)
  (let ([potential-id (substring (uuid-generate/random) 0 35)])
    ; if the ID is in the Table of Extant Things, try again.
    (cond
     [(hash-has-key? extant-things potential-id)
      potential-id]
     [else
      (generate-thing-id)])))

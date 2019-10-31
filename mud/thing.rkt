#lang racket

(require libuuid)


(provide
 (struct-out thing)
 extant-things
 create-thing
 destroy-thing
 set-thing-quality
 set-thing-qualities
 get-thing-quality
 generate-thing-id)

(struct thing (id names qualities))

(define extant-things (make-hash))


(define (create-thing)
  (let ([new-thing (thing (generate-thing-id) (list "thing") (make-hash))])
    (hash-set! extant-things (thing-id new-thing) new-thing)
  new-thing))

(define (destroy-thing id)
  (hash-remove! extant-things id))

(define (set-thing-quality thing quality value)
  (hash-set! (thing-qualities thing) quality value))

(define (set-thing-qualities thing qualities)
  (map (lambda (quality)
         (set-thing-quality thing (car quality) (car (cdr quality))))
       qualities))

(define (get-thing-quality thing quality)
  (hash-ref (thing-qualities thing) quality))

(define (generate-thing-id)
  (let ([potential-id (substring (uuid-generate/random) 0 35)])
    ; if the ID is in the Table of Extant Things, try again.
    (cond
     [(hash-has-key? extant-things potential-id)
      (generate-thing-id)]
     [else
      potential-id])))

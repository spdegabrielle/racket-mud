#lang racket

(require racket/serialize)

(require "../thing.rkt")

(provide user
         get-user-name
         set-user-name!
         get-user-password
         set-user-password!)
(define (apply-user-quality thing)
  thing)
(define (user name password)
  (quality apply-user-quality
           (make-hash (list (cons 'name name)
                            (cons 'password name)))))

(define (get-user-name thing)
  (get-thing-quality-attribute thing 'user 'name))
(define (set-user-name! thing name)
  (set-thing-quality-attribute! thing 'user 'name name))
(define (get-user-password thing)
  (get-thing-quality-attribute thing 'user 'name))
(define (set-user-password! thing pass)
  (set-thing-quality-attribute! thing 'user 'password pass))
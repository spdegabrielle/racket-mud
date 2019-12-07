#lang racket

(require racket/serialize)

(require "../thing.rkt")

(provide (struct-out user)
         get-user-name
         set-user-name
         get-user-password
         set-user-password)

(serializable-struct user (name password birth-datetime) #:mutable)

(define (get-user-name thing)
  (get-thing-quality thing user? user-name))
(define (set-user-name thing name)
  (set-thing-quality thing user? set-user-name! name))
(define (get-user-password thing)
  (get-thing-quality thing user? user-password))
(define (set-user-password thing pass)
  (set-thing-quality thing user? set-user-password! pass))
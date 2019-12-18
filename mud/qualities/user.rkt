#lang racket

(require racket/serialize)

(require "../data-structures/thing.rkt")
(require "../data-structures/quality.rkt")
(require "../utilities/thing.rkt")

(provide user-quality
         user-name
         set-user-name!
         user-pass
         set-user-pass!
         user-birth-datetime
         set-user-birth-datetime!)
(struct user-struct (name pass birth-datetime) #:mutable)

(define (apply-user-quality thing) (void))

(define (user-quality name pass birth-datetime)
  (quality apply-user-quality
           (user-struct
            name pass birth-datetime)))

(define (get-user-structure thing)
  (thing-quality-structure thing 'user))

(define (user-name thing)
  (user-struct-name (get-user-structure thing)))

(define (set-user-name! thing name)
  (set-user-struct-name! (get-user-structure thing) name))

(define (user-pass thing)
  (user-struct-pass (get-user-structure thing)))

(define (set-user-pass! thing pass)
  (set-user-struct-pass! (get-user-structure thing) pass))

(define (user-birth-datetime thing)
  (user-struct-birth-datetime (get-user-structure thing)))

(define (set-user-birth-datetime! thing datetime)
  (set-user-struct-birth-datetime! (get-user-structure thing) datetime))
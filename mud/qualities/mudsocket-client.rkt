#lang racket

(require racket/date)

(require "../engine.rkt")
(require "../logger.rkt")
(require "../data-structures/command.rkt")
(require "../data-structures/thing.rkt")
(require "../data-structures/quality.rkt")
(require "../services/user.rkt")
(require "../qualities/client.rkt")
(require "../qualities/user.rkt")
(require "../utilities/thing.rkt")

(provide mudsocket-client
         mudsocket-client-in-buffer
         set-mudsocket-client-in-buffer!
         mudsocket-client-out-buffer
         set-mudsocket-client-out-buffer!
         mudsocket-client-send-procedure
         set-mudsocket-client-send-procedure!
         mudsocket-client-parse-procedure
         set-mudsocket-client-parse-procedure!
         mudsocket-client-login-stage
         set-mudsocket-client-login-stage!)

(struct mudsocket-client-struct (in-buffer out-buffer send-procedure parse-procedure login-stage) #:mutable)

(define (apply-mudsocket-client-quality thing) (void))

(define (mudsocket-client in-buffer out-buffer send-procedure parse-procedure login-stage)
  (quality apply-mudsocket-client-quality 
           (mudsocket-client-struct in-buffer out-buffer send-procedure parse-procedure login-stage)))

(define (get-mudsocket-client-struct thing)
  (thing-quality-structure thing 'mudsocket-client))

(define (mudsocket-client-out-buffer thing)
  (mudsocket-client-struct-out-buffer (get-mudsocket-client-struct thing)))

(define (set-mudsocket-client-out-buffer! thing value)
  (set-mudsocket-client-struct-out-buffer! (get-mudsocket-client-struct thing) value))

(define (mudsocket-client-in-buffer thing)
  (mudsocket-client-struct-in-buffer (get-mudsocket-client-struct thing)))
(define (set-mudsocket-client-in-buffer! thing value)
  (set-mudsocket-client-struct-in-buffer! (get-mudsocket-client-struct thing) value))

(define (mudsocket-client-send-procedure thing)
  (mudsocket-client-struct-send-procedure (get-mudsocket-client-struct thing)))
(define (set-mudsocket-client-send-procedure! thing value)
  (set-mudsocket-client-struct-send-procedure! (get-mudsocket-client-struct thing) value))

(define (mudsocket-client-parse-procedure thing)
  (mudsocket-client-struct-parse-procedure (get-mudsocket-client-struct thing)))
(define (set-mudsocket-client-parse-procedure! thing value)
  (set-mudsocket-client-struct-parse-procedure! (get-mudsocket-client-struct thing) value))

(define (mudsocket-client-login-stage thing)
  (mudsocket-client-struct-login-stage (get-mudsocket-client-struct thing)))
(define (set-mudsocket-client-login-stage! thing value)
  (set-mudsocket-client-struct-login-stage! (get-mudsocket-client-struct thing) value))



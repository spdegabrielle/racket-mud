#lang racket

(require "../logger.rkt")
(require "../thing.rkt")

(provide (struct-out client)
         get-client-commands
         get-client-command
         client-has-command?
         get-client-out-buffer
         set-client-out-buffer
         get-client-respond-procedure
         get-client-receive-procedure
         set-client-receive-procedure)

(struct client
  (out-buffer commands respond-procedure receive-procedure)
  #:mutable)
(define (get-client-out-buffer thing)
  (get-thing-quality thing client?
                     client-out-buffer))
(define (get-client-commands thing)
  (get-thing-quality thing client?
                     client-commands))
(define (get-client-command thing queried-command)
  (let ([client-commands (get-client-commands thing)])
    (car (remq* (list (void))
    (hash-map client-commands
              (lambda (cid cstruct)
                (when (string=? queried-command cid)
                  cstruct)))))))
;    (car
;     (remq (void)
;           (hash-map client-commands
;            (lambda (cid cstruct)
;              (when (eq? cid queried-command)
;                cstruct)))))))
(define (client-has-command? thing command)
  (hash-has-key? (get-client-commands thing) command))

(define (set-client-out-buffer thing buffer)
  (set-thing-quality thing client? client-out-buffer buffer))
(define (get-client-respond-procedure thing)
  (get-thing-quality thing client?
                     client-respond-procedure))
(define (get-client-receive-procedure thing)
  (get-thing-quality thing client?
                     client-receive-procedure))
(define (set-client-receive-procedure thing proc)
  (set-thing-quality thing client?
                     set-client-receive-procedure!
                     proc))
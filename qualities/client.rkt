#lang racket

(require "../thing.rkt")

(provide client
         get-client-commands
         get-client-command
         client-has-command?
         get-client-out-buffer
         set-client-out-buffer!
         get-client-respond-procedure
         get-client-receive-procedure
         set-client-receive-procedure!)

(define (apply-client-quality thing)
  thing)
(define (client out-buffer commands respond-procedure receive-procedure)
  (quality apply-client-quality
           (make-hash (list (cons 'out-buffer out-buffer)
                            (cons 'commands commands)
                            (cons 'respond-procedure respond-procedure)
                            (cons 'receive-procedure receive-procedure)))))
(define (get-client-out-buffer thing)
  (get-thing-quality-attribute thing 'client 'out-buffer))
(define (get-client-commands thing)
  (get-thing-quality-attribute thing 'client 'commands))
(define (get-client-command thing queried-command)
  (car (filter values
          (hash-map (get-client-commands thing)
                    (lambda (cid cstruct)
                      (cond
                        [(string=? queried-command cid)
                         cstruct]
                        [else #f]))))))
(define (set-client-out-buffer! thing buffer)
  (set-thing-quality-attribute! thing 'client 'out-buffer buffer))
(define (get-client-respond-procedure thing)
  (get-thing-quality-attribute thing 'client 'respond-procedure))
(define (get-client-receive-procedure thing)
  (get-thing-quality-attribute thing 'client 'receive-procedure))
(define (set-client-receive-procedure! thing proc)
  (set-thing-quality-attribute! thing 'client 'receive-procedure proc))

(define (client-has-command? client command)
  (hash-has-key? (get-client-commands client) command))
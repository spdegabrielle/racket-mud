#lang racket

(require "../data-structures/quality.rkt")
(require "../data-structures/thing.rkt")
(require "../utilities/thing.rkt")

(provide client
         client-out-buffer
         set-client-out-buffer!
         client-commands
         set-client-commands!
         add-client-commands!
         client-command
         set-client-command!
         client-respond-procedure
         set-client-respond-procedure!
         client-receive-procedure
         set-client-receive-procedure!
         client-has-command?)
(struct client-structure (out-buffer commands respond-procedure receive-procedure) #:mutable)

(define (apply-client-quality thing) (void))

(define (client out-buffer commands respond-procedure receive-procedure)
  (quality apply-client-quality
           (client-structure
            out-buffer commands respond-procedure receive-procedure)))

(define (get-client-structure thing)
  (thing-quality-structure thing 'client))

(define (client-out-buffer thing)
  (client-structure-out-buffer (get-client-structure thing)))

(define (set-client-out-buffer! thing buffer)
  (set-client-structure-out-buffer! (get-client-structure thing) buffer))
(define (client-commands thing)
  (client-structure-commands (get-client-structure thing)))
(define (set-client-commands! thing commands)
  (set-client-structure-commands! (get-client-structure thing) commands))
(define (add-client-commands! thing commands)
  (hash-map commands
            (lambda (cmd struct) (hash-set! (client-commands thing) cmd struct))))
(define (client-command thing command)
  (hash-ref (client-commands thing) command))
(define (set-client-command! thing command procedure)
  (hash-set! (client-commands thing) command procedure))
(define (client-respond-procedure thing)
  (client-structure-respond-procedure (get-client-structure thing)))
(define (set-client-respond-procedure! thing procedure)
  (set-client-structure-respond-procedure! (get-client-structure thing) procedure))
(define (client-receive-procedure thing)
  (client-structure-receive-procedure (get-client-structure thing)))
(define (set-client-receive-procedure! thing procedure)
  (set-client-structure-receive-procedure! (get-client-structure thing) procedure))


(define (get-client-command thing queried-command)
  (car (filter values
          (hash-map (client-commands thing)
                    (lambda (cid cstruct)
                      (cond
                        [(string=? queried-command cid)
                         cstruct]
                        [else #f]))))))

(define (client-has-command? client command)
  (hash-has-key? (client-commands client) command))
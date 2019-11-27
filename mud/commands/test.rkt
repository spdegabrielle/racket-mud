#lang racket
(require "../engine.rkt")
(provide test-command)
(define (test-command client [kwargs #f] [args #f])
  (let* ([brief
          "syntax: test -h\n\n\
The dedicated testing command. Its behavior is unreliable."]
         [output
          (format "Test command called with keyword arguments \
~a and arguments ~a" kwargs args)])
    (when (hash? kwargs)
      (when (hash-has-key? kwargs #\h)
        (set! output brief)))
    (schedule "send"
              (hash
               'recipient client
               'message output))))
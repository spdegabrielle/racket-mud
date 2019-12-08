#lang racket

(require "../engine.rkt")
(provide finger-command)
(define (finger-command client [kwargs #f] [args #f])
  (let* ([brief
          "syntax: finger [-h]\n\n\
A brief explanation of the command's purpose."]
         [output brief])
    (when (hash? kwargs)
      (when (hash-has-key? kwargs #\h)
        (set! output brief)))
    (schedule "send"
              (hash 'recipient client
                    'message output))))
#lang racket
(require "../engine.rkt")
(provide tell-command)
(define (tell-command client [kwargs #f] [args #f])
  (let* ([brief
          "syntax: tell [-h]\n\n\
A brief explanation of the command's purpose."]
         [output brief])
    (when (hash? kwargs)
      (when (hash-has-key? kwargs #\h)
        (set! output brief)))
    (schedule "send"
              (hash 'recipient client
                    'message output))))
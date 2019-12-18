#lang racket

(require "../../mud/engine.rkt")
(require "../../mud/data-structures/command.rkt")
(require "../../mud/data-structures/thing.rkt")

(require "../qualities/physical.rkt")
(require "../qualities/visual.rkt")

(provide whereami-command)
                  

(define help-brief
   "Request information on your current location.")

(define help-syntax
  (list
   "whereami"
   help-brief))

(define help-long
  "Mostly a diagnostic and testing tool, this command requests information on your current location.")

(define (whereami-procedure client [kwargs #f] [args #f])
  (let ([where (physical-location client)])
  (schedule 'send
            (hash 'recipient client
                  'message
                  (format "You are ~a."
                          (cond
                            [(thing-has-quality? where 'visual)
                             (visual-brief where)]
                            [else (format "in a \"~a\""
                                          (first-noun where))]))))))

(define whereami-command
  (command
   whereami-procedure
   (hash 'brief help-brief
         'syntax help-syntax
         'long help-long)))     
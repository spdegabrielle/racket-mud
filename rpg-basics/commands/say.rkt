#lang racket

(require "../../mud/data-structures/command.rkt")
(require "../../mud/engine.rkt")
(require "../../mud/data-structures/thing.rkt")
(require "../../mud/utilities/thing.rkt")

(require "../qualities/container.rkt")
(require "../qualities/physical.rkt")
(require "../qualities/visual.rkt")
(provide say-command)
                  

(define help-brief
   "The command for saying something.")

(define help-syntax
  (list
   "say <message>"))

(define help-long "Blah blah blah")

(define (say-procedure client [kwargs #f] [args #f])
  (when (and (string? args)
             (thing-has-quality? client 'physical))
    (for-each (lambda (other-clients) (schedule 'send (hash 'recipient other-clients
                                                            'message
                                                            (format "~a says: \"~a\""
                                                                    (visual-brief client)
                                                                    args))))
              (filter-things-with-quality (container-inventory (physical-location client)) 'client))))

(define say-command
  (command
   say-procedure
   (hash 'brief help-brief
         'syntax help-syntax
         'long help-long)))
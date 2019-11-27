#lang racket

(require "../command.rkt")
(require "../thing.rkt")
(require "../engine.rkt")

(provide commands-command)

(define help-brief
   "Requests a list of commands available to the requester.")

(define help-syntax
  (list
   "commands"
   "Request a list of available commands"))

(define help-long
  "This command is used to see what commands are available to the \
requester. There's really not more to say about it.")

(define (commands-procedure client [kwargs #f] [args #f])
  (schedule
   'send
   (hash 'recipient client
         'message (format "You have the following commands: ~a"
                          (string-join (hash-keys
                                        (hash-ref
                                         (thing-qualities client)
                                         'commands))
                                       ", "
                                       #:before-first ""
                                       #:before-last ", and "
                                       #:after-last ".")))))

(define commands-command
  (command
   commands-procedure
   (hash 'brief help-brief
         'syntax help-syntax
         'long help-long)))     
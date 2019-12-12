#lang racket

(require "../command.rkt")
(require "../logger.rkt")
(require "../engine.rkt")
(require "../thing.rkt")

(require "../qualities/client.rkt")
(require "../qualities/physical.rkt")
(require "../qualities/container.rkt")

(provide whereami-command)
                  

(define help-brief
   "Says the first noun for where you are.")

(define help-syntax
  (list
   "help [-Hh] [--domain=$domain] [topic]"
   "Request information on 'topic'. Use '--domain' to limit your \
request to a single domain, one of commands, events, or services."))

(define help-long
  "For example, you might enter 'help talker' to learn more about \
Racket-MUD's talker system. you would be prompted to enter either
'help --domain=cmds talker' to learn about the talker command or \
'help --domain=services talker' to learn about the Talker service.")

(define (whereami-procedure client [kwargs #f] [args #f])
  (current-logger (make-logger 'Whereami-command mudlogger))
  (schedule 'send
            (hash 'recipient client 'message
                  (format "~a\nall contents: ~a"
                          (first-noun (get-physical-location client))
                          (map (lambda (item) (first-noun item)) (get-container-inventory (get-physical-location client)))))))

(define whereami-command
  (command
   whereami-procedure
   (hash 'brief help-brief
         'syntax help-syntax
         'long help-long)))     
#lang racket

(require "../qualities/client.rkt")
(require "../command.rkt")
(require "../thing.rkt")
(require "../engine.rkt")

(require "../services/user.rkt")

(require "../utilities/string.rkt")

(provide who-command)

(define help-brief
   "Requests a list of currently connected users.")

(define help-syntax
  (list
   "who"
   "Request a list of currently connected users."))

(define help-long
  "This command is used to see which user accounts are currently \
connected, as reported by the user service.")

(define (who-procedure client [kwargs #f] [args #f])
  (let ([connected-users connected-user-accounts])
  (schedule
   'send
   (hash 'recipient client
         'message
         (cond
           [(> (length connected-users) 0)
           (format "Connected users: ~a"
                   (oxfordize-list connected-users))]
           [else "No connected users."])))))

(define who-command
  (command
   who-procedure
   (hash 'brief help-brief
         'syntax help-syntax
         'long help-long)))     
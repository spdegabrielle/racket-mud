#lang racket

(require racket/date)

(require "../qualities/client.rkt")
(require "../data-structures/command.rkt")
(require "../data-structures/thing.rkt")
(require "../engine.rkt")

(require "../services/user.rkt")

(require "../utilities/string.rkt")

(provide finger-command)

(define help-brief
   "Requests information about the specified user-account.")

(define help-syntax
  (list
   "finger <user-name>"
   "Request information about the specified user-name."))

(define help-long
  "This command is used to look up information about a user.")

(define (finger-procedure client [kwargs #f] [args #f])
  (schedule
   'send
   (hash 'recipient client
         'message
         (cond
           [(string? args)
            (cond
              [(user-account-name? args)
               (render-finger-profile (get-user-account args))]
              [else "Not a valid user-name."])]
           [else "No user-name provided."]))))

(define (render-finger-profile user)
  (format "user-name: ~a\ncreated on: ~a"
          (user-account-name user)
          (date->string (user-account-birth-datetime user))))

(define finger-command
  (command
   finger-procedure
   (hash 'brief help-brief
         'syntax help-syntax
         'long help-long)))     
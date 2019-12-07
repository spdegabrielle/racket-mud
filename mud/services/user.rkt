#lang racket

(require racket/serialize)

(require "../logger.rkt")
(require "../service.rkt")
(require "../thing.rkt")

(require "serialization.rkt")

(require "../qualities/user.rkt")


(provide user-service
         user-accounts
         user-account-name?
         create-user-account
         get-user-account)

(define user-accounts (make-hash))
(define account-file "./user-accounts.rktd")



(define (get-user-account name)
    (hash-ref user-accounts name))

(define (create-user-account
         name password
         birth-datetime)
  (current-logger (make-logger 'User-create-user-account
                               mudlogger))
  (log-debug "Creating account ~a" name)
  (hash-set! user-accounts name
             (user name password birth-datetime))
  (save-user-accounts)
  (log-debug "User accounts now ~a" user-accounts))

(define (load-user-accounts)
  (current-logger (make-logger 'User-service-load-account
                               mudlogger))
  (set! user-accounts
        (cond [(file-exists? account-file)
               (read-data-from-file account-file)]
              [else (make-hash)]))
  (log-debug "Loaded user accounts, now ~a" user-accounts))

(define (save-user-accounts)
  (current-logger (make-logger 'User-service-save-accounts
                               mudlogger))
  (save-data-to-file user-accounts account-file)
  (load-user-accounts))

(define (delete-user-account name)
  (hash-remove! user-accounts name)
  (save-user-accounts))

(define (user-account-name? name)
  (hash-has-key? user-accounts name))


(define user-service (service 'user-service
                              load-user-accounts #f #f #f))
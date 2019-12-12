#lang racket

(require racket/serialize)

(require "../logger.rkt")
(require "../service.rkt")
(require "../thing.rkt")

(require "serialization.rkt")

(require "../qualities/user.rkt")



(provide user-service
         known-user-accounts
         user-account-name?
         create-user-account
         connected-user-accounts
         connect-user-account
         disconnect-user-account
         get-user-account
         get-user-account-password)


(serializable-struct user-account (name password birth-datetime) #:mutable)

(define known-user-accounts (make-hash))
(define connected-user-accounts (list))
(define account-file "user-accounts.rktd")

(define (get-user-account queried-name)
  (when (hash-has-key? known-user-accounts queried-name)
    (hash-ref known-user-accounts queried-name)))


(define (get-user-account-password name)
  (user-account-password (get-user-account name)))


(define (connect-user-account name)
  (set! connected-user-accounts
        (append connected-user-accounts (list name))))

(define (disconnect-user-account name)
  (set! connected-user-accounts
        (remove name connected-user-accounts)))

(define (create-user-account
         name password
         birth-datetime)
  (current-logger (make-logger 'User-create-user-account
                               mudlogger))
  (log-debug "Creating account ~a" name)
  (hash-set! known-user-accounts name (user-account name password birth-datetime))
  (save-user-accounts)
  (log-debug "User accounts now ~a" known-user-accounts))

(define (load-user-accounts)
  (current-logger (make-logger 'User-service-load-account
                               mudlogger))
  (set! known-user-accounts (read-data-from-file account-file))
  (when (void? known-user-accounts)
    (set! known-user-accounts (make-hash)))
  (log-debug "Loaded user accounts, now ~a" known-user-accounts))

(define (save-user-accounts)
  (current-logger (make-logger 'User-service-save-accounts
                               mudlogger))
  (save-data-to-file known-user-accounts account-file)
  (load-user-accounts))

(define (delete-user-account name)
  (hash-remove! known-user-accounts name)
  (save-user-accounts))

(define (user-account-name? name)
  (hash-has-key? known-user-accounts name))


(define user-service (service 'user-service
                              load-user-accounts #f #f #f))
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
         connected-user-accounts
         connect-user-account
         disconnect-user-account
         get-user-account
         get-user-account-qualities)

(define user-accounts (make-hash))
(define connected-user-accounts (list))
(define account-file "user-accounts.rktd")
(define (get-user-account-qualities name)
  (cdr (hash-ref user-accounts name)))

(define (connect-user-account name)
  (set! connected-user-accounts
        (append connected-user-accounts (list name))))

(define (disconnect-user-account name)
  (set! connected-user-accounts
        (remove name connected-user-accounts)))

(define (get-user-account name)
    (car (hash-ref user-accounts name)))

(define (create-user-account
         name password
         birth-datetime)
  (current-logger (make-logger 'User-create-user-account
                               mudlogger))
  (log-debug "Creating account ~a" name)
  (hash-set! user-accounts name
             (cons (user name password birth-datetime)
                   (list)))
  (save-user-accounts)
  (log-debug "User accounts now ~a" user-accounts))

(define (load-user-accounts)
  (current-logger (make-logger 'User-service-load-account
                               mudlogger))
  (set! user-accounts (read-data-from-file account-file))
  (when (void? user-accounts)
    (set! user-accounts (make-hash)))
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
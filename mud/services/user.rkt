#lang racket

(require racket/serialize)

(require "../logger.rkt")
(require "../data-structures/service.rkt")
(require "../data-structures/thing.rkt")

(require "../utilities/serialization.rkt")

(require "../qualities/user.rkt")

(provide (struct-out user-account)
         user-service
         known-user-accounts
         user-account-name?
         create-user-account
         connected-user-accounts
         connect-user-account
         disconnect-user-account
         get-user-account
         get-user-account-pass)


(serializable-struct user-account (name pass birth-datetime) #:mutable)

(define known-user-accounts (make-hash))
(define connected-user-accounts (list))
(define account-file "user-accounts.rktd")

(define (get-user-account queried-name)
  (when (hash-has-key? known-user-accounts queried-name)
    (hash-ref known-user-accounts queried-name)))


(define (get-user-account-pass name)
  (user-account-pass (get-user-account name)))


(define (connect-user-account name)
  (set! connected-user-accounts
        (append connected-user-accounts (list name))))

(define (disconnect-user-account name)
  (set! connected-user-accounts
        (remove name connected-user-accounts)))

(define (create-user-account
         name pass
         birth-datetime)
  (log-debug "Creating new user-account ~a" name)
  (hash-set! known-user-accounts name (user-account name pass birth-datetime))
  (save-user-accounts))

(define (load-user-accounts)
  (set! known-user-accounts (read-data-from-file account-file))
  (when (void? known-user-accounts)
    (set! known-user-accounts (make-hash)))
  (log-info "Loaded ~a user accounts." (length (hash-keys known-user-accounts))))

(define (save-user-accounts)
  (save-data-to-file known-user-accounts account-file)
  (load-user-accounts))

(define (delete-user-account name)
  (hash-remove! known-user-accounts name)
  (save-user-accounts))

(define (user-account-name? name)
  (hash-has-key? known-user-accounts name))


(define user-service (service 'user-service
                              load-user-accounts #f #f #f))
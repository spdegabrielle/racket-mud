#lang racket

(require racket/serialize)
(require racket/date)

(require "engine.rkt")

(provide accounts)

(define (accounts [account-file "user-accounts.rktd"])
  (define known-accounts (make-hash))
  (define (load-accounts)
    (when (file-exists? account-file)
      (log-debug "Loading accounts from ~a" account-file)
      (with-handlers
          ([exn:fail:filesystem:errno?
            (λ (E) (log-warning "Failed to load accounts: ~a" E))])
        (with-input-from-file account-file
          (λ () (set! known-accounts (deserialize (read))))))))
  (define (save-accounts)
    (cond [(serializable? known-accounts)
           (with-output-to-file account-file
             (λ () (write (serialize known-accounts)))
             #:exists 'replace)
           (load-accounts)]
          [else (log-warning "Account data not serializable.")]))
  (define (create-account name pass)
    (log-info "Creating new user account named ~a" name)
    (hash-set! known-accounts name
               (make-hash
                (list
                 (cons 'name name)
                 (cons 'pass pass)
                 (cons 'birth-time (current-date)))))
    (save-accounts))
  (define (account? name) (hash-has-key? known-accounts name))
  (define (account name) (hash-ref known-accounts name))
  (λ (state)
    (let ([set-hook!
           (λ (hook value)
             (hash-set!
              (mud-hooks (cdr state))
              hook value))])
      (set-hook! 'account account)
      (set-hook! 'account? account?)
      (set-hook! 'create-account create-account)
      (set-hook! 'save-accounts save-accounts))
    (load-accounts)
    state))
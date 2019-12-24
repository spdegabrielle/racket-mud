#lang racket

(require racket/serialize)
(require racket/date)
(require "../engine.rkt")
(provide accounts)
(define accounts
  (lambda ([account-file "user-accounts.rktd"])
    (define accounts (make-hash))
    (lambda (mud sch make)
      (define load-accounts
        (lambda ()
          (when (file-exists? account-file)
            (log-debug "Loading accounts from ~a" account-file)
            (with-handlers ([exn:fail:filesystem:errno?
                             (lambda (exn) (log-warning "~a" exn))])
              (with-input-from-file account-file
                (lambda () (set! accounts (deserialize (read)))))))))
      (define save-accounts
        (lambda () ; save accounts
          (cond
            [(serializable? accounts)
             (with-output-to-file account-file
               (lambda () (write (serialize accounts)))
               #:exists 'replace)
             (load-accounts)]
            [else (log-warning "Account data not serializable.")])))
      (define create-account
        (lambda (name pass)
          (log-info "Creating new user account ~a" name)
          (hash-set! accounts name (make-hash
                                    (list
                                     (cons 'name name)
                                     (cons 'pass pass)
                                     (cons 'birth-time (current-date)))))
          (save-accounts)))
      (define account? (lambda (name) (hash-has-key? accounts name)))
      (define account (lambda (name) (hash-ref accounts name)))
      (let ([set-hook! (lambda (hook value) (hash-set! (mud-hooks mud) hook value))])
        (set-hook! 'save-accounts save-accounts)
        (set-hook! 'create-account create-account)
        (set-hook! 'account? account?)
        (set-hook! 'account account))
      (load-accounts)
      #f)))
#lang racket

(require "engine.rkt"
         "parser.rkt"
         "./commands/commands.rkt"
         "./commands/look.rkt"
         "./commands/move.rkt"
         "./commands/trivia.rkt")

(provide mudsocket)

(define mudsocket
  (lambda (#:port [port 4242])
    (define listener (tcp-listen port 5 #t))
    (define connections '())
    (define (accept-connection state)
      (log-debug "STATE IS AAAAAAAAAAAAAAAA ~a" state)
      (define-values (in out) (tcp-accept listener))
      (define-values (lip lport rip rport) (tcp-addresses in #t))
      (let* ([thing
              ((mud-maker (cdr state))
               "MUDSocket Client"
               #:qualities
               (list
                (cons 'channels (list))
                (cons 'commands (make-hash))
                (cons 'contents (list))
                (cons 'client-in "")
                (cons 'client-out "")
                (cons 'mass 1)
                (cons 'mudsocket-in in)
                (cons 'mudsocket-out out)
                (cons 'mudsocket-ip rip)
                (cons 'mudsocket-port rport)))]
             [quality (quality-getter thing)]
             [set-quality! (quality-setter thing)])
        (set-quality! 'client-parser (client-login-parser thing))
        (set-quality! 'client-sender (client-sender thing))
        (set-quality! 'commands
                      (make-hash
                       (list
                        (cons "commands" (commands thing))
                        (cons "look" (look thing))
                        (cons "move" (move thing))
                        (cons "trivia" (trivia thing)))))
        (set! connections (append (list thing) connections))
        (set-quality! 'client-out "Connected to Racket-MUD.")
        (log-debug "Accepted connection from ~a:~a"
                   rip rport)))
    (define (tick state)
      (let ([schedule (car state)]
            [mud (cdr state)])
        (map
         (λ (client)
           (let* ([quality (quality-getter client)]
                  [set-quality! (quality-setter client)]
                  [out-buffer (quality 'client-out)]
                  [out (quality 'mudsocket-out)]
                  [in (quality 'mudsocket-in)]
                  [parser (quality 'client-parser)]
                  [sender (quality 'client-sender)])
             (cond
               [(port-closed? in)
                (set! connections (remove thing connections))]
               [(byte-ready? in)
                (with-handlers
                    ([exn:fail:read?
                      (λ (exn)
                        (log-warning "Connection issue: ~a" exn)
                        (close-input-port in)
                        (close-output-port out)
                        (set! connections
                              (remove thing connections)))])
                  (let ([line-in (read-line in)])
                    (cond [(string? line-in)
                           (parser (string-trim line-in))]
                          [(eof-object? line-in)
                           (close-input-port in)
                           (close-output-port out)
                           (set! connections
                                 (remove thing connections))])))])
             (when (> (string-length out-buffer) 0) (schedule sender))))
         connections)
        (when (tcp-accept-ready? listener) (accept-connection state))
        (schedule tick)
        state))
    tick))
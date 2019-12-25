#lang racket
(require "../engine.rkt")
(require "../parser.rkt")
(require "../commands/commands.rkt")
(require "../commands/look.rkt")
(require "../commands/move.rkt")
(require "../commands/trivia.rkt")
(provide mudsocket)
(define mudsocket
  (lambda (#:port [port 4242])
    (define listener (tcp-listen port 5 #t))
    (define connections (list))
    (lambda (mud sch make)
      (define accept-connection
        (thunk (define-values (in out) (tcp-accept listener))
               (define-values (lip lport rip rport) (tcp-addresses in #t))
               (let* ([thing
                      (make "MUDSocket Client"
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
                      [set-quality! (quality-setter thing)]
                      [quality (quality-getter thing)])
                 (set-quality! 'client-parser (client-login-parser mud sch thing))
                 (set-quality! 'client-sender (client-sender thing))
                 (set-quality! 'commands
                              (make-hash
                               (list
                                (cons "commands" (commands sch thing))
                                (cons "look" (look sch thing))
                                (cons "move" (move sch thing))
                                (cons "trivia" (trivia sch thing)))))
                 (set! connections (append (list thing) connections))
                 (log-debug "Accepted connection from ~a:~a"
                            rip rport)
                 (set-quality! 'client-out "Connected to Racket-MUD. Type your [desired] user-name and press ENTER.\n"))))
      (thunk
       (when (tcp-accept-ready? listener) (accept-connection))
       (map
        (lambda (client)
          (let* ([quality (quality-getter client)]
                 [set-quality! (quality-setter client)]
                 [out-buffer (quality 'client-out)]
                 [out (quality 'mudsocket-out)]
                 [in (quality 'mudsocket-in)]
                 [parser (quality 'client-parser)]
                 [sender (quality 'client-sender)])
            (cond
              [(port-closed? in) (set! connections (remove thing connections))]
              [(byte-ready? in)
               (let ([line-in (read-line in)])
                 (cond [(string? line-in) (parser (string-trim line-in))]
                       [(eof-object? line-in) (close-input-port in) (close-output-port out)]))])
            (when (> (string-length out-buffer) 0) (sch sender))))
        connections)))))
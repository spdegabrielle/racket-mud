#lang racket

(require racket/date)

(require "../engine.rkt")
(require "../data-structures/command.rkt")
(require "../data-structures/thing.rkt")
(require "../services/user.rkt")
(require "../qualities/client.rkt")
(require "../qualities/mudsocket-client.rkt")
(require "../qualities/user.rkt")
(require "../utilities/parsing.rkt")
(require "../utilities/thing.rkt")

(provide mudsocket-send
         mudsocket-login-parser
         mudsocket-parser)

(define (mudsocket-send client message)
  (when (thing-has-quality? client 'mudsocket-client)
    (let ([out (mudsocket-client-out-buffer client)])
      (with-handlers ([exn? (lambda (exc) 
                       (log-warning "Tried to send message to client but ~a" exc))])
        ((lambda () (display (format "~a~n" message) out)
        (flush-output out)))))))

(define (mudsocket-login-parser client line)
  (let ([output ""]
        [login-stage
         (mudsocket-client-login-stage client)])
    (cond
      [(= login-stage 0)
       (give-thing-new-qualities client (hash 'user (user-quality line #f #f)))
       (cond
         [(user-account-name? line)
          (set! output
                (format "There's a client named ~a. If you're \
them, type your password and press enter." line))
          (set-mudsocket-client-login-stage! client 2)]
         [else
          (set! output
                (format "There's no client named ~a. What's your \
desired password?" line))
          (set-mudsocket-client-login-stage! client 1)])]
      [(= login-stage 1)
       (set-user-pass! client line)
       (set-mudsocket-client-login-stage! client 8)
       (create-user-account
        (user-name client)
         line
         (current-date))
       (set! output (format "User account registered with name \
~a\nPress <ENTER> to complete login." (user-name client)))]
      [(= login-stage 2)
       (cond
         [(string=?
           (user-account-pass
            (get-user-account (user-name client)))
           line)
          (set! output "Password correct. Press <ENTER> to \
complete login.")
          (set-mudsocket-client-login-stage! client 8)]
         [else
          (set! output "Password incorrect. \
Type your [desired] user-name and press <ENTER>.")
          (set-mudsocket-client-login-stage! client 0)])]
      [(= login-stage 8)
       (connect-user-account (user-name client))
       ;(give-thing-new-qualities client (hash 'talker (talker-listener-quality (list "cq"))))
       (add-noun-to-thing (user-name client) client)
       (set-client-receive-procedure!
        client mudsocket-parser)
       ; (schedule 'move (hash 'mover client 'destination (get-room 'teraum/arathel-county/outside-crossed-candles-inn)))
       (set! output "Login complete.")
       (set-mudsocket-client-login-stage! client 9)])
    (schedule
     'send
     (hash 'recipient client
           'message output))))
;;;;;;; Parse MUDSocket client
; (can you believe this works?)
(define (mudsocket-parser client line)
  (when (> (string-length line) 0)
    (let ([spline (string-split line)]
           [keyword-arguments #f]
           [arguments #f])
      (cond
        [(> (length spline) 0)
         (let ([input-command (car spline)])
           (cond
             [(client-has-command? client input-command)
             (let ([client-command
                    (client-command client input-command)])
               (when (> (length spline) 1)
                 (let ([parsed-arguments
                        (parse-arguments (cdr spline))])
                   (set! arguments (string-join (cdr parsed-arguments)))
                   (set! keyword-arguments (car parsed-arguments))))
               ((command-procedure client-command)
                client keyword-arguments arguments))]
;             [(thing-listens-to-channel? client input-command)
;              (unless (null? (cdr spline))
;                (schedule 'broadcast (hash 'channel input-command
;                                           'speaker client
;                                           'message (string-join (cdr spline)))))]
             [else
              (schedule
               'send
               (hash 'recipient client
                     'message "Invalid command."))]))]))))
;  ;; break up the line by whitespaces
;  (when (> (string-length line) 0)
;    (let ([spline (string-split line)]
;          [client-commands (get-client-commands client)])
;      ;; command = first word
;      (when (> (length spline) 0)
;        (let ([command (car spline)])
;          (log-debug "command is ~a" command)
;          (cond
;            ;; when command in client's commands
;            [(hash-has-key? client-commands command)
;             (log-debug "command is a client command")
;             (let ([client-command
;                    (get-client-command client command)])
;               (log-debug "client-command is ~a" client-command)
;             (cond
;               ;; with arguments
;               [(> (length spline) 1)
;                (let* ([parsed-arguments
;                       (parse-arguments (cdr spline))]
;                       [arguments (car parsed-arguments)]
;                       [keyword-arguments (cdr parsed-arguments)])
;                ((command-procedure client-command)
;                                   client
;                                   keyword-arguments arguments))]
;               [else
;                ((command-procedure client-command)
;                                   client)]))]
;            ;[(member command
;             ;        (get-thing-quality client 'talker-channels))
;             ;(log-debug "command is talker channel")
;             ;(schedule
;             ; 'broadcast
;             ; (hash 'channel command
;             ;       'speaker client
;             ;       'message (string-join (cdr spline))))]
;            ))))))
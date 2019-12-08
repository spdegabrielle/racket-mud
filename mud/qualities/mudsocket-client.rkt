#lang racket

(require racket/date)

(require "../command.rkt")
(require "../engine.rkt")
(require "../logger.rkt")
(require "../thing.rkt")
(require "./client.rkt")
(require "./user.rkt")
(require "../services/user.rkt")
(require "../services/room.rkt")

(require "../qualities/physical.rkt")

(provide (struct-out mudsocket-client)
         get-mudsocket-client-in
         get-mudsocket-client-out
         mudsocket-client-send-procedure
         mudsocket-client-parse-login-procedure)

; sin = socket in
; sout = socket out
; rip = remote ip
; rport = remote port
(struct mudsocket-client (in out ip port login-stage) #:mutable)

(define (get-mudsocket-client-in thing)
  (get-thing-quality thing mudsocket-client?
                     mudsocket-client-in))
(define (get-mudsocket-client-out thing)
  (get-thing-quality thing mudsocket-client?
                     mudsocket-client-out))
(define (get-mudsocket-client-ip thing)
  (get-thing-quality thing mudsocket-client?
                     mudsocket-client-ip))
(define (get-mudsocket-client-port thing)
  (get-thing-quality thing mudsocket-client?
                     mudsocket-client-port))
(define (get-mudsocket-client-login-stage thing)
  (get-thing-quality thing mudsocket-client?
                     mudsocket-client-login-stage))
(define (set-mudsocket-client-login-stage thing value)
  (set-thing-quality thing mudsocket-client?
                     set-mudsocket-client-login-stage!
                     value))

(define (mudsocket-client-send-procedure client message)
  (when (thing-has-qualities? client mudsocket-client?)
    (let ([out (get-mudsocket-client-out client)])
      (display (format "~a~n" message) out)
      (flush-output out))))

(define (mudsocket-client-parse-login-procedure client line)
  (current-logger (make-logger 'MUDSocket-client-parse-login-procedure
                               mudlogger))
  (let ([output ""]
        [login-stage
         (get-mudsocket-client-login-stage client)])
    (cond
      [(= login-stage 0)
       (give-thing-new-qualities client (list (user line #f #f)))
       (cond
         [(user-account-name? line)
          (set! output
                (format "There's a client named ~a. If you're \
them, type your password and press enter." line))
          (set-mudsocket-client-login-stage client 2)]
         [else
          (set! output
                (format "There's no client named ~a. What's your \
desired password?" line))
          (set-mudsocket-client-login-stage client 1)])]
      [(= login-stage 1)
       (set-user-password client line)
       (set-mudsocket-client-login-stage client 9)
       (create-user-account
        (get-user-name client)
         line
         (current-date))
       (set! output (format "User account registered with name \
~a\nPress <ENTER> to complete login." (get-user-name client)))]
      [(= login-stage 2)
       (cond
         [(string=?
           (user-password (get-user-account (get-user-name client)))
           line)
          (set! output "Password correct. Press <ENTER> to \
complete login.")
          (set-mudsocket-client-login-stage client 9)]
         [else
          (set! output "Password incorrect. \
Type your [desired] user-name and press <ENTER>.")
          (set-mudsocket-client-login-stage client 0)])]
      [(= login-stage 9)
       (connect-user-account (get-user-name client))
       (give-thing-new-qualities client (get-user-account-qualities
                                         (get-user-name client)))
       (set-physical-proper-name client (get-user-name client))
       (set-client-receive-procedure
        client mudsocket-client-parse-procedure)
       (schedule 'move (hash 'mover client 'destination (get-room 'kaga-wasun-surface)))
       (set! output "Login complete.")])
    (schedule
     'send
     (hash 'recipient client
           'message output))))
;;;;;;; Parse MUDSocket client
; (can you believe this works?)
(define (mudsocket-client-parse-procedure client line)
  (current-logger (make-logger 'MUDSocket-parse-mudsocket-client
                               mudlogger))
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
                    (get-client-command client input-command)])
               (when (> (length spline) 1)
                 (let ([parsed-arguments
                        (parse-arguments (cdr spline))])
                   (set! arguments (cdr parsed-arguments))
                   (set! keyword-arguments (car parsed-arguments)))
                 (log-debug "kwargs are ~a and args are ~a"
                            keyword-arguments
                            arguments))
               (log-debug
                "Input-command is ~a, kwargs are ~a, and args are ~a"
                input-command
                keyword-arguments
                arguments)
               (log-debug
                "Client-command is ~a"
                client-command)
               ((command-procedure client-command)
                client keyword-arguments arguments))]
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

(define (parse-arguments spline)
  (let ([kwargs (make-hash)]
        [args (list)])
    ;; begin parsing of arguments
    ;; for every arg in targs
    (map (lambda (arg)
           (cond
             ;; if arg starts with --
             [(string=? (substring arg 0 2) "--")
              ;; split along it
              ;; if arg contains =
              (when (string-contains? arg "=")
                (let ([sparg (string-split arg "=")])
                  ;; and add it to kwargs hash,
                  ;; first part as key, second as value
                  (hash-set! kwargs
                             (substring (car sparg) 2)
                             (cdr sparg))))]
             ;; if arg starts with -
             [(string=? (substring arg 0 1) "-")
              (map (lambda (char)
                     (hash-set! kwargs char #t))
                   (string->list (substring arg 1)))]
             ;; otherwise, add to args
             [else
              (set! args (append args (list arg)))]))
         spline)
    (cons kwargs args)))
#lang racket

(require racket/date)

(require "../command.rkt")
(require "../engine.rkt")
(require "../logger.rkt")
(require "../thing.rkt")

(require "../services/talker.rkt")
(require "../services/user.rkt")


(require "../commands/commands.rkt")
(require "../commands/help.rkt")

(provide create-mudsocket-client)

(define (create-mudsocket-client in out ip port)
  (current-logger (make-logger 'MUDSocket-create-mudsocket-client
                               mudlogger))
  (let ([new-thing (create-thing)])
    (set-thing-qualities
     new-thing
     (list
      (list 'socket-in in)
      (list 'socket-out out)
      (list 'remote-ip ip)
      (list 'remote-port port)
      (list 'messages-buffer "")
      (list 'send-procedure send-to-mudsocket-client)
      (list 'parse-procedure parse-mudsocket-client-login)
      (list 'commands
            (make-hash
             (list
              (cons "commands" commands-command)
              (cons "help" help-command))))
      (list 'talker-channels (list))))
    ; (tune-channel "wanji" new-thing)
    ; (tune-channel "nunpa" new-thing)
    (log-debug "created new thing ~a" (thing-qualities new-thing))
    new-thing))

(define (send-to-mudsocket-client client message)
  (when (hash-has-key? (thing-qualities client) 'socket-out)
    (let ([out (hash-ref (thing-qualities client) 'socket-out)])
      (display (format "~a~n" message) out)
      (flush-output out))))

(define (parse-mudsocket-client-login client line)
  (let ([output ""]
        [login-stage
         (get-thing-quality client 'login-stage)])
         (cond
           [(= login-stage 0)
            (set-thing-quality client 'user-name line)
            (cond
              [(user-name? line)
               (set! output
                     (format "There's a client named ~a. If you're \
them, type your password and press enter." line))
               (set-thing-quality client 'login-stage 2)]
              [else
               (set! output
                     (format "There's no client named ~a. What's your \
desired password?" line))
               (set-thing-quality client 'login-stage 1)])]
           [(= login-stage 1)
            (set-thing-quality client 'password line)
            (set-thing-quality client 'login-stage 9)
            (create-user-account
             (get-thing-quality client 'user-name)
             line
             (current-date))
            (set! output (format "User account registered with name \
~a\nPress <ENTER> to complete login." (get-thing-quality client 'user-name)))]
           [(= login-stage 2)
            (cond
              [(string=?
                (user-password
                 (hash-ref user-accounts (get-thing-quality client 'user-name)))
                line)
               (set! output "Password correct. Press <ENTER> to \
complete login.")
            (set-thing-quality client 'login-stage 9)]
              [else
               (set! output "Password incorrect. \
Type your [desired] user-name and press <ENTER>.")
               (set-thing-quality client 'login-stage 0)])]
           [(= login-stage 9)
            (set-thing-quality client
             'parse-procedure parse-mudsocket-client)
            (set! output "Login complete.")])
    (schedule
     'send
     (hash 'recipient client
           'message output))))
;;;;;;; Parse MUDSocket client
; (can you believe this works?)
(define (parse-mudsocket-client client line)
  (current-logger (make-logger 'MUDSocket-parse-mudsocket-client
                               mudlogger))
  (log-debug "called by ~a with line ~a" client line)
  ;; break up the line by whitespaces
  (when (> (string-length line) 0)
    (let ([spline (string-split line)]
          [ccmds (hash-ref (thing-qualities client) 'commands)])
      ;; command = first word
      (when (> (length spline) 0)
      (let ([command (car spline)])
        (log-debug "command is ~a" command)
        (log-debug "TEMP: client talker channels are ~a"
                   (get-thing-quality client 'talker-channels))
        (cond
          ;; when command in client's commands
          [(hash-has-key? ccmds command)
           (log-debug "command is a client command")
           (cond
             ;; with arguments
             [(> (length spline) 1)
              (let ([targs (cdr spline)]
                    [kwargs (make-hash)]
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
                     targs)
                ;; end parsing of arguments
                ((command-procedure (hash-ref ccmds command))
                 client kwargs args))]
             ;; without arguments
             [else
              ((command-procedure (hash-ref ccmds command)) client)])]
          [(member command
                   (get-thing-quality client 'talker-channels))
           (log-debug "command is talker channel")
           (schedule
            'broadcast
            (hash 'channel command
                  'speaker client
                  'message (string-join (cdr spline))))]))))))
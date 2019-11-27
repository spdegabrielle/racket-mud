#lang racket

(require "../command.rkt")
(require "../logger.rkt")
(require "../service.rkt")
(require "../thing.rkt")
(require "../engine.rkt")
(require "./talker.rkt")
(require "../commands/commands.rkt")
(require "../commands/help.rkt")
(require "../commands/finger.rkt")
(require "../commands/quit.rkt")
(require "../commands/tell.rkt")
(require "../commands/talker.rkt")
(require "../commands/test.rkt")
(require "../commands/who.rkt")
(require "../commands/whoami.rkt")

(provide mudsocket-service
         create-mudsocket-client)

(define socket-listener (void))
(define socket-connections (make-hash))

(define (start-mudsocket)
  (current-logger (make-logger 'MUDSocket-start mudlogger))
  (log-debug "called")
  (set! socket-listener (tcp-listen 4242 5 #t))
  
  (log-debug "complete"))

(define (tick-mudsocket)
  (current-logger (make-logger 'MUDSocket-tick mudlogger))
  ; when there's a new connection:
  (when (tcp-accept-ready? socket-listener)
    (define-values (in out) (tcp-accept socket-listener))
    (define-values (lip lport rip rport) (tcp-addresses in #t))
    (let ([new-thing (create-mudsocket-client in out rip rport)])
      (hash-set! socket-connections (thing-id new-thing) new-thing)
      (schedule 'send
                (hash 'recipient new-thing
                      'message (format
                                "You've connected to Racket-MUD and \
been associated with thing ~a.\n
Press enter to continue." (thing-id new-thing))))))
  ; for existing connections:
  (hash-map socket-connections
            (lambda (id thing)
              (let ([thing-in (get-thing-quality thing 'socket-in)]
                    [thing-out (get-thing-quality thing 'socket-out)])
                (cond
                  ; If the client disconnected
                  [(port-closed? thing-in)
                   ; TODO: remove thing from extant-things
                   (hash-remove! socket-connections id)]
                  ; If the client submitted a line
                  [(byte-ready? thing-in)
                   (let ([line-in (read-line thing-in)])
                     (schedule 'parse
                               (hash 'client thing
                                     'line line-in)))])
                (let ([messages-buffer
                       (get-thing-quality thing 'messages-buffer)])
                  (when (> (string-length messages-buffer) 0)
                    (send-to-client-through-mudsocket
                     thing messages-buffer)
                    (set-thing-quality thing 'messages-buffer "")))))))

(define (stop-mudsocket)
  ;; This doesn't seem to actually disconnect clients. Ahh well.
  ;; They'll figure it out eventually.
  ;; TODO: Add check for if socket is already closed.
  (current-logger (make-logger 'MUDSocket-stop mudlogger))
  (log-debug "called")
  (tcp-close socket-listener)
  (log-debug "complete"))
(define (send-to-client-through-mudsocket client message)
  (when (hash-has-key? (thing-qualities client) 'socket-out)
    (let ([out (hash-ref (thing-qualities client) 'socket-out)])
      (display (format "~a~n" message) out)
      (flush-output out))))
;;;;;;; Parse MUDSocket client Login
(define (parse-mudsocket-client-login client line)
  (schedule 'send (hash
                    'recipient client
                    'message "No login parser rn, tossing you to \
the real parser."))
  (set-thing-quality client 'parse-procedure parse-mudsocket-client))
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
;;;;;;; Create client Thing
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
      (list 'send-procedure send-to-client-through-mudsocket)
      (list 'parse-procedure parse-mudsocket-client-login)
      (list 'commands
            (hash "commands" commands-command
                  "help" help-command))
      (list 'talker-channels (list))))
    (tune-channel "wanji" new-thing)
    (tune-channel "nunpa" new-thing)
    (log-debug "created new thing ~a" (thing-qualities new-thing))
    new-thing))

(define mudsocket-service
  (service
   'mudsocket-service
   #f
   start-mudsocket
   tick-mudsocket
   stop-mudsocket))
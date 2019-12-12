#lang racket

(require "../engine.rkt")
(require "../logger.rkt")
(require "../service.rkt")
(require "../thing.rkt")

(require "../commands/commands.rkt")
(require "../commands/help.rkt")
(require "../commands/look.rkt")
(require "../commands/move.rkt")
(require "../commands/whereami.rkt")
(require "../commands/who.rkt")

(require "../qualities/client.rkt")
(require "../qualities/mudsocket-client.rkt")
(require "../qualities/physical.rkt")

(provide mudsocket-service)

(define socket-listener (void))
(define socket-connections (make-hash))

(define (start-mudsocket)
  (current-logger (make-logger 'MUDSocket-start mudlogger))
  (log-debug "called")
  (set! socket-listener (tcp-listen 4242 5 #t))
  (log-debug "complete"))

(define (accept-mudsocket-connection)
  (define-values (in out)
    (tcp-accept socket-listener))
  (define-values (lip lport rip rport)
    (tcp-addresses in #t))
  (let
      ([connection-thing
        (make-recipe
         (recipe
          (list "client")
          (list)
          (make-hash
           (list (cons 'mudsocket-client (mudsocket-client in out rip rport 0))
                 (cons 'client (client "" (make-hash (list (cons "commands" commands-command)
                                                        (cons "help" help-command)
                                                        (cons "look" look-command)
                                                        (cons "move" move-command)
                                                        (cons "whereami" whereami-command)
                                                        (cons "who" who-command)))
                                       mudsocket-client-send-procedure
                                       mudsocket-client-parse-login-procedure))
                 (cons 'physical (physical (void)))))))])
    (hash-set! socket-connections
               (thing-id connection-thing) connection-thing)
    (log-debug "Accepted connection from ~a:~a and associated it with \
thing #~a" rip rport (thing-id connection-thing))
    (schedule 'send
              (hash
               'recipient connection-thing
               'message
               (format
                "Connected to Racket-MUD and associated \
with thing #~a\n\
Input your [desired] user-name and press <ENTER>."
                (thing-id connection-thing))))))

(define (tick-mudsocket)
  (current-logger (make-logger 'MUDSocket-tick mudlogger))
  ; when there's a new connection:
  (when (tcp-accept-ready? socket-listener)
    (accept-mudsocket-connection))
  ; for existing connections:
  (hash-map socket-connections
            (lambda (id thing)
              (let ([in
                     (get-mudsocket-client-in thing)]
                    [out
                     (get-mudsocket-client-out thing)])
                (cond
                  ; If the client disconnected
                  [(port-closed? in)
                   ; TODO: remove thing from extant-things
                   (hash-remove! socket-connections id)]
                  ; If the client submitted a line
                  [(byte-ready? in)
                   (let ([line-in (read-line in)])
                     (cond
                       [(string? line-in)
                        (schedule 'parse
                                  (hash 'client thing
                                        'line (string-trim line-in)))]
                       [(eof-object? line-in)
                        (close-input-port in)
                        (close-output-port out)]))])
                (let ([messages-buffer
                       (get-client-out-buffer thing)])
                  (when (> (string-length messages-buffer) 0)
                    (schedule
                     'send
                     (hash 'recipient thing
                           'message messages-buffer))
                    (set-client-out-buffer! thing "")))))))

(define (stop-mudsocket)
  ;; This doesn't seem to actually disconnect clients. Ahh well.
  ;; They'll figure it out eventually.
  ;; TODO: Add check for if socket is already closed.
  (current-logger (make-logger 'MUDSocket-stop mudlogger))
  (log-debug "called")
  (tcp-close socket-listener)
  (log-debug "complete"))

(define mudsocket-service
  (service
   'mudsocket-service
   #f
   start-mudsocket
   tick-mudsocket
   stop-mudsocket))
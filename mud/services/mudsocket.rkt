#lang racket

(require "../engine.rkt")
(require "../logger.rkt")
(require "../commands/commands.rkt")
(require "../commands/finger.rkt")
(require "../commands/help.rkt")
(require "../commands/who.rkt")
(require "../data-structures/mud-library.rkt")
(require "../data-structures/mud-server.rkt")
(require "../data-structures/recipe.rkt")
(require "../data-structures/service.rkt")
(require "../data-structures/thing.rkt")
(require "../qualities/client.rkt")
(require "../qualities/mudsocket-client.rkt")
(require "../utilities/mudsocket.rkt")
(require "../utilities/recipe.rkt")
(require "../utilities/string.rkt")

(provide mudsocket-service
         socket-connections)

(define socket-listener (void))
(define socket-connections (make-hash))

(define MUDSOCKET-PORT 4242)


(define (start-mudsocket)
  (log-debug "Starting the MUDSocket service on port ~a." MUDSOCKET-PORT)
  (set! socket-listener (tcp-listen MUDSOCKET-PORT 5 #t)))

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
                 (cons 'client (client "" (make-hash
                                           (list (cons "commands" commands-command)
                                                 (cons "finger" finger-command)
                                                 (cons "help" help-command)
                                                 (cons "who" who-command)))
                                       mudsocket-send
                                       mudsocket-login-parser))))))])
    (hash-set! socket-connections
               (thing-id connection-thing) connection-thing)
    (log-debug "Accepted connection from ~a:~a and associated it with \
thing #~a" rip rport (thing-id connection-thing))
    (schedule 'send
              (hash
               'recipient connection-thing
               'message
               (format
                "Connected to ~a version ~a\n\
It's running with the following libraries: ~a\n\n\
Input your [desired] user-name and press <ENTER>."
                (mud-server-id loaded-server)
                (mud-server-version loaded-server)
                (oxfordize-list (map (lambda (library) (mud-library-id library)) (mud-server-libraries loaded-server))))))))

(define (tick-mudsocket)
  ; when there's a new connection:
  (when (tcp-accept-ready? socket-listener)
    (accept-mudsocket-connection))
  ; for existing connections:
  (hash-map socket-connections
            (lambda (id thing)
              (let ([in
                     (mudsocket-client-in-buffer thing)]
                    [out
                     (mudsocket-client-out-buffer thing)])
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
                       (client-out-buffer thing)])
                  (when (> (string-length messages-buffer) 0)
                    (schedule
                     'send
                     (hash 'recipient thing
                           'message (format "~a\n> " messages-buffer)))
                    (set-client-out-buffer! thing "")))))))

(define (stop-mudsocket)
  ;; This doesn't seem to actually disconnect clients. Ahh well.
  ;; They'll figure it out eventually.
  ;; TODO: Add check for if socket is already closed.
  (tcp-close socket-listener))

(define mudsocket-service
  (service
   'mudsocket-service
   #f
   start-mudsocket
   tick-mudsocket
   stop-mudsocket))
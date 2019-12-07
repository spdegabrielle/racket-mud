#lang racket

(require "../command.rkt")
(require "../logger.rkt")
(require "../engine.rkt")
(require "../thing.rkt")

(require "../qualities/client.rkt")

(provide help-command)
                  

(define help-brief
   "The command for requesting helpful information. Searches through \
commands, events, and services and returns either a list of matching \
information or the single matching documentation.")

(define help-syntax
  (list
   "help [-Hh] [--domain=$domain] [topic]"
   "Request information on 'topic'. Use '--domain' to limit your \
request to a single domain, one of commands, events, or services."))

(define help-long
  "For example, you might enter 'help talker' to learn more about \
Racket-MUD's talker system. you would be prompted to enter either
'help --domain=cmds talker' to learn about the talker command or \
'help --domain=services talker' to learn about the Talker service.")

(define (help-procedure client [kwargs #f] [args #f])
  (current-logger (make-logger 'Help-command mudlogger))
  (log-debug "kwargs are ~a and args are ~a" kwargs args)
  (let ([topic #f] [domain #f] [response #f]
        [queried-domain #f] [queried-topic #f])
    (when (hash? kwargs)
      (when (hash-has-key? kwargs "domain")
        (set! queried-domain (car (hash-ref kwargs "domain"))))
      (when (> (length args) 0)
        (set! queried-topic (car args))))
    ;; parse domain & topic from kwargs, args
    ;; if domain commands, look in client's commands
    (cond
      [(string? queried-domain)
       (cond
         [(string=? queried-domain "commands")
          (let ([client-commands (get-client-commands client)])
            (cond
              [(> (length args) 0)
               (when (hash-has-key? client-commands queried-topic)
                 (let ([client-command
                        (hash-ref client-commands queried-topic)]
                       [long
                        (cond [(hash-has-key? kwargs #\H) #t]
                              [else #f])]
                       [syntax
                        (cond [(hash-has-key? kwargs #\s) #t]
                              [else #f])])
                   (set!
                    response
                    (format
                     "~a~a~a"
                     (cond [syntax
                            ""]
                           [else
                            (hash-ref (command-help-strings
                                       client-command)
                                      'brief)])
                     (cond
                       [(or long syntax)
                        (format
                         "\n\n~a"
                         (let ([syntax
                                (hash-ref (command-help-strings
                                           client-command)
                               'syntax)])
                           (format "~a\n~a"
                                   (car syntax)
                                   (cdr syntax))))]
                       [else ""])
                     (cond
                       [long
                        (format
                         "\n\n~a"
                         (hash-ref (command-help-strings client-command)
                                   'long))]
                       [else ""])))))]
              [else
               (set! response
                     "Commands are the way clients make requests of \
the engine.")]))]
         [(string=? queried-domain "events")
          #t]
         [(string=? queried-domain "services")
          #t])])
    (unless (string? response)
      (set! response "No help found."))
    (schedule 'send
              (hash 'recipient client
                    'message response))))

(define help-command
  (command
   help-procedure
   (hash 'brief help-brief
         'syntax help-syntax
         'long help-long)))     
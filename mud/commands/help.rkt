#lang racket

(require "../command.rkt")
(require "../logger.rkt")
(require "../engine.rkt")
(require "../thing.rkt")


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
  (log-debug "called with kwargs ~a and args ~a" kwargs args)
  (let ([topic #f]
        [domain #f]
        [response #f]
        [queried-domain #f]
        [queried-topic #f])
    (when (hash? kwargs)
      (log-debug "has kwargs")
      (when (hash-has-key? kwargs "domain")
        (set! queried-domain (car (hash-ref kwargs "domain")))
        (log-debug "queried-domain now ~a" queried-domain))
      (when (> (length args) 0)
        (set! queried-topic (car args)))
        (log-debug "queried-topic now ~a" queried-topic))
    ;; parse domain & topic from kwargs, args
    ;; if domain commands, look in client's commands
    (log-debug "queried-domain is NOW ~a" queried-domain)
    (cond
      [(string? queried-domain)
       (log-debug "queried-domain is a string ~a" queried-domain)
       (cond
         [(string=? queried-domain "commands")
          (log-debug "looking in commands domain")
          (let ([ccmds
                 (hash-ref (thing-qualities client) 'commands)])
            (log-debug "client commands are ~a" ccmds)
            (cond
              [(> (length args) 0)
               (when (hash-has-key? ccmds queried-topic)
                 (log-debug
                  "client has queried command ~a" queried-topic)
                 (let ([ccmd (hash-ref ccmds queried-topic)]
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
                            (hash-ref (command-help-strings ccmd)
                                      'brief)])
                     (cond
                       [(or long syntax)
                        (format
                         "\n\n~a"
                         (let ([syntax
                                (hash-ref (command-help-strings ccmd)
                               'syntax)])
                           (format "~a\n~a"
                                   (car syntax)
                                   (cdr syntax))))]
                       [else ""])
                     (cond
                       [long
                        (format
                         "\n\n~a"
                         (hash-ref (command-help-strings ccmd)
                                   'long))]
                       [else ""])))))]
              [else
               (set! response
                     "Commands are the way clients make requests of \
the engine.")]))]
         [(string=? queried-domain "events")
          (log-debug "looking in events domain")
          #t]
         [(string=? queried-domain "services")
          (log-debug "looking in services domain")
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
#lang racket

(struct mud (name services hooks things events) #:mutable)
(struct thing (name nouns adjectives qualities) #:mutable)

(struct client-attributes (commands in out) #:mutable)
(struct mudsocket-client (in out ip port) #:mutable)

(struct exn:mud exn:fail ())
(struct exn:mud:thing exn:mud ())
(struct exn:mud:thing:creation exn:mud:thing ())

(define user-accounts (make-hash))

(define (oxfordize-list strings)
  (cond
    [(null? (cdr strings))
     (car strings)]
    [(null? (cddr strings))
     (string-join strings " and ")]
    [else
     (string-join strings ", "
                  #:before-first ""
                  #:before-last ", and ")]))

(define (force-stringy-list strings)
    (cond [(list? strings) strings] [(pair? strings) (list (car strings) (cdr strings))]
          [(string? strings) (list strings)] [else (list)]))

(define (merge-stringy-lists list1 [list2 #f])
  (filter values
          (force-stringy-list
           (append
            (force-stringy-list list1)
            (cond [list2 (force-stringy-list list2)] [else (list)])))))

(define make-thing
  (lambda (mud sch)
    (lambda (name #:nouns [nouns #f]
                  #:adjectives [adjectives #f]
                  #:qualities [qualities #f])
      (let* ([thing (thing name (merge-stringy-lists nouns) (merge-stringy-lists adjectives) (cond [qualities (make-hash (filter values qualities))] [else (make-hash)]))])
        (define handler (lambda (event) (event thing)))
        (when qualities
          (hash-map (thing-qualities thing)
                    (lambda (id quality)
                      (log-debug "Looking at ~a quality of ~a" id (thing-name thing))
                      (let ([apply-proc-key 
                             (string->symbol (string-join (list "apply-" (symbol->string id) "-quality") ""))]
                            [hooks (mud-hooks mud)])
                        (log-debug "Hooks are ~a, apply-proc-key is ~a" (hash-keys hooks) apply-proc-key)
                        (when (hash-has-key? hooks apply-proc-key)
                          ((hash-ref hooks apply-proc-key) thing))))))
        (sch (lambda (mud) (set-mud-things! mud (append (list handler) (mud-things mud)))))
        handler))))
    
; (define make-thing (lambda (mud) (lambda (name) (mud (thunk (set-mud-things! mud (append (list (thing name (list) (list) (list))) (mud-things mud))))))))
; ((make-thing tmud) "Bill")

(define name
  (lambda (thing)
    (thing (lambda (thing) (thing-name thing)))))

(define quality-getter
  (lambda (thing)
    (lambda (quality) (thing (lambda (thing)
                               (with-handlers
                                   ([exn:fail:contract?
                                     (lambda (exn)
                                       (log-warning "Tried to get non-existent ~a quality from ~a."
                                                    quality (thing-name thing))
                                       #f)])
                                 (hash-ref (thing-qualities thing) quality)))))))

(define quality-setter
  (lambda (thing)
    (lambda (quality value)
      (log-debug "Setting the ~a quality of ~a to ~a" quality (name thing) value)
      (thing (lambda (thing) (hash-set! (thing-qualities thing) quality value))))))

(define string-quality-appender
  (lambda (thing)
    (lambda (quality)
      (lambda (value [newline #t])
        (let* ([get-quality (quality-getter thing)]
               [set-quality! (quality-setter thing)]
               [current-string (get-quality quality)])
          (cond
            [(> (string-length current-string) 0)
             (set-quality! quality (string-join (list current-string value)
                                                (cond [newline "\n"] [else ""])))]
            [else (set-quality! quality (format "~a" value))]))))))

(define client-sender
  (lambda (thing)
    (log-debug "Preparing the sender procedure for thing ~a" (name thing))
    (lambda (mud)
      (let* ([name (name thing)]
            [quality (quality-getter thing)]
            [set-quality! (quality-setter thing)]
            [message (quality 'client-out)]
            [out (quality 'mudsocket-out)])
        (log-debug "Sending ~a a message:\n   ~a" name message)
        (display (format (cond
                           [(eq? #\newline (last (string->list message))) "~a"]
                           [else "~a\n"]) message) out)
        (flush-output out)
        (set-quality! 'client-out "")))))

(define account-name?
  (lambda (name)
    (hash-has-key? user-accounts name)))

(define client-login-parser
  (lambda (mud sch thing)
    (define quality (quality-getter thing)) (define set-quality! (quality-setter thing))
    (define add-to-out ((string-quality-appender thing) 'client-out))
    (define login-stage 0)
    (lambda (line)
      (let ([reply ""])
        (cond
          [(= login-stage 0)
           (set-quality! 'user-name line)
           ; account services
           (cond [(account-name? line)
                  (set! reply (format "There's a extant account for ~a. If it's yours, enter the password and press ENTER. Otherwise, disconnect [and reconnect]."))
                  (set! login-stage 1)]
                 [else
                  (set! reply "There's no account with that name. Your new password is\n\n~a\n\nPress when you're ready to log in.")
                  (set! login-stage 9)])]
          [(= login-stage 9)
           (set-quality! 'client-parser (client-parser mud sch thing))
           ((hash-ref (mud-hooks mud) 'move) thing ((hash-ref (mud-hooks mud) 'room) 'crossed-candles-inn))])
        (when reply (add-to-out reply))))))

(define client-parser
  (lambda (mud sch thing)
    (define quality (quality-getter thing)) (define set-quality! (quality-setter thing))
    (define add-to-out ((string-quality-appender thing) 'client-out))
    (lambda (line)
      ; (lambda (mud) ;; if this ends up an event?
      (let ([reply ""]
            [commands (quality 'commands)]
            [location (quality 'location)])
        (log-debug "Preparing to parse the line ~a from ~a. Its commands are ~a" line (name thing) commands)
        (log-debug "TMP and it's location is ~a" ((quality-getter location) 'exits))
        (when (> (string-length line) 0)
          (let* ([spline (string-split line)]
                 [input-command (car spline)] [args (string-join (cdr spline))])
            (cond [(hash-has-key? commands input-command)
                   ((hash-ref commands input-command) args)]
                  [(and location (hash-has-key? ((quality-getter location) 'exits) (string->symbol input-command)))
                   ((move sch thing) input-command)]
                  [else (set! reply "Invalid command.")])))
        (when reply (add-to-out reply))))))

(define mudmap
  (lambda ([areas (make-hash)])
    (lambda (mud sch make)
      (hash-set! (mud-hooks mud) 'rooms areas)
      (hash-set! (mud-hooks mud) 'room (lambda (id) (hash-ref areas id)))
      (hash-set! (mud-hooks mud) 'move (lambda (mover destination)
                                         (let* ([mover-quality (quality-getter mover)]
                                               [set-mover-quality! (quality-setter mover)]
                                               [destination-quality (quality-getter destination)]
                                               [set-destination-quality! (quality-setter destination)]
                                               [location (mover-quality 'location)])
                                           (when location
                                             (let ([location-quality
                                                    (quality-getter location)]
                                                   [set-location-quality!
                                                    (quality-setter (mover-quality 'location))])
                                               (when (location-quality 'contents)
                                                 (set-location-quality! 'contents
                                                                        (remove mover
                                                                                (location-quality 'contents))))))
                                           (set-mover-quality! 'location destination)
                                           (set-destination-quality! 'contents
                                                                     (append (list mover)
                                                                             (destination-quality 'contents))))))
      (hash-map
       areas
       (lambda (id area)
         (let ([area (area make)])
           (hash-set! areas id area))))
      (hash-map areas
                (lambda (id area)
                  (let ([contents ((quality-getter area) 'contents)]
                        [created-contents (list)])
                    (map (lambda (item)
                         (set! created-contents (append (list (item make)) created-contents)))
                         contents)
                    ((quality-setter area) 'contents created-contents))
                  (hash-map ((quality-getter area) 'exits)
                            (lambda (id exit)
                              (hash-set! ((quality-getter area) 'exits)
                                         id
                                         (hash-ref areas exit))))))
      #f)))



(define actions
  (lambda ()
    (define actions (make-hash))
    (lambda (mud sch make)
      (hash-set! (mud-hooks mud)
                'apply-actions-quality
                (lambda (thing)
                  (log-debug "Adding action quality to ~a" (thing-name thing))
                  (let ([created-actions (list)])
                    (for-each
                     (lambda (action)
                       (let ([record (list thing (car action) (cdr action))])
                         (set! created-actions (append (list record) created-actions))
                         (let ([chance (car action)])
                           (hash-set! actions chance (cond [(hash-has-key? actions chance)
                                                            (append (list record) (hash-ref actions chance))]
                                                           [else (list record)])))))
                     (hash-ref (thing-qualities thing) 'actions))
                    (hash-set! (thing-qualities thing) 'actions created-actions))))
      (lambda () (void)
        ; action service tick
        ))))


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
                                  (list (cons 'commands (make-hash))
                                        (cons 'client-in "")
                                        (cons 'client-out "")
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
                                (cons "look" (look sch thing))
                                (cons "move" (move sch thing)))))
                 (set! connections (append (list thing) connections))
                 (log-debug "Accepted connection from ~a:~a and associated it with thing ~a."
                            rip rport (name thing))
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

(define look
  (lambda (sch thing)
    (define quality (quality-getter thing)) (define set-quality! (quality-setter thing))
    (define add-to-out ((string-quality-appender thing) 'client-out))
    (lambda (args)
      (let* ([location (quality 'location)]
             [location-quality (quality-getter location)]
             [location-desc (location-quality 'description)]
             [location-exits (location-quality 'exits)]
             [location-contents (location-quality 'contents)])
        (add-to-out (format "[~a]" (location (lambda (l) (thing-name l)))))
        (when location-desc (add-to-out (format "~a" location-desc)))
        (when location-contents
          (unless (null? location-contents)
            (add-to-out
             (format "Contents: ~a"
                     (oxfordize-list
                      (map (lambda (thing) (thing (lambda (thing) (thing-name thing)))) location-contents))))))
        (when location-exits (add-to-out (format "Exits: ~a" (oxfordize-list (map symbol->string (hash-keys location-exits))))))))))

(define move
  (lambda (sch thing)
    (define quality (quality-getter thing)) (define set-quality! (quality-setter thing))
    (define add-to-out ((string-quality-appender thing) 'client-out))
    (lambda (args)
      (let* ([location (quality 'location)]
             [location-quality (quality-getter location)]
             [location-exits (location-quality 'exits)]
             [desired-exit (string->symbol args)])
        (log-debug "ARGS ARE ~a" args)
        (cond
          [(hash-has-key? location-exits desired-exit)
           (add-to-out (format "You attempt to move ~a" args))
           (sch (lambda (mud)
                  ((hash-ref (mud-hooks mud) 'move) thing (hash-ref location-exits desired-exit))
                  ((look sch thing) "")))]
          [else (add-to-out "Invalid exit.")])))))
           
    

(define make-mud
  (λ ([name "Racket-MUD"] [services (list)])
    (define cim (λ () (current-inexact-milliseconds)))
    (define this-mud (mud name services (make-hash) (list) (list)))
    (define sevts (list)) (define things (list))
    (define sch (λ (evt) (set! sevts (append (list evt) sevts))))
    (define logs (make-logger 'MUD)) (define logr (make-log-receiver logs 'debug))
    (define tc 0) (define time (cim))
    (define tick (λ (mud)
                   (λ ()
                     (when (> (- (cim) time) 333) (set! tc (+ tc 1))
                       (for-each
                        (λ (evt)
                          (cond [(procedure? evt)
                                 (log-debug "Calling scheduled event ~a" evt)
                                 (evt this-mud)]
                                [else (log-warning "Non-procedure event scheduled: ~a" evt)]))
                        sevts)
                       (set! sevts '())
                       (for-each (lambda (srv) (srv)) (mud-services this-mud))
                       (set! time (cim))))))
    (define clock (λ (mud)
                    (log-debug "Starting MUD tick.")
                    (set! tick (tick mud))
                    (λ () (let tock () (tick) (tock)))))
    (λ (mud)
      (current-logger logs)
      (log-info "Loading MUD ~a" (mud-name this-mud))
      (define make (make-thing this-mud sch))
      (set-mud-services! this-mud (filter values (map (lambda (srv) (srv this-mud sch make)) (mud-services this-mud))))
      (thread (clock mud))
      (thread (λ () (let loop () (define l (sync logr))
                      (printf "~a, tick #~a: ~a\n"
                              (vector-ref l 0) tc (vector-ref l 1))
                      (loop))))
      sch)))

(define area
  (lambda (#:name name #:description [description #f] #:exits [exits #f]
           #:contents [contents #f])
    (lambda (make)
      (make name
            #:qualities
            (list (cons 'exits
                        (cond [exits (make-hash exits)] [else (make-hash)]))
                  (cond [description (cons 'description description)]
                        [else #f])
                  (cons 'contents
                        (cond [contents contents] [else (list)])))))))

(define outdoors
  (lambda (#:name name #:description [description #f] #:exits [exits #f]
           #:contents [contents #f])
    (area #:name name
          #:description description
          #:exits exits
          #:contents contents)))

(define room
  (lambda (#:name name #:description [description #f] #:exits [exits #f]
           #:contents [contents #f])
    (area #:name name
          #:description description
          #:exits exits
          #:contents contents)))

(define inn
  (lambda (#:name name #:description [description #f] #:exits [exits #f]
           #:contents [contents #f])
    (room #:name name
           #:description description
           #:exits exits
           #:contents contents)))

(define road
  (lambda (#:name name #:description [description #f] #:exits [exits #f]
           #:contents [contents #f])
    (outdoors #:name name
              #:description description
              #:exits exits
              #:contents contents)))

(define person
  (lambda (#:name name #:description [description #f]
           #:contents [contents #f] #:actions [actions #f])
    (lambda (make)
      (make name
            #:qualities
            (list
             (cond [description (cons 'description description)]
                   [else #f])
             (cons 'contents
                   (cond [contents contents] [else (cons 'contents (list))]))
             (cond [actions (cons 'actions actions)]
                   [else #f]))))))

(define ghost
  (lambda (#:name name #:description [description #f]
           #:contents [contents #f] #:actions [actions #f])
    (person #:name name
            #:description description
            #:contents contents
            #:actions actions)))

(define alfric
  (ghost
   #:name "Alfric"
   #:description "This is Alfric, a ghost that haunts Crossed Candles Inn."
   #:actions '((10000 . "Alfric floats around a bit."))))
  
(define crossed-candles-inn
  (inn
   #:name "Crossed Candles Inn"
   #:description "This is the Crossed Candles Inn: a simple wooden shack with several shuttered windows. Accomodations consist of a single large room with wooden cots. The Inn is said to be haunted by the ghost of a human man named Alfric. The innkeeper is a short human woman named Lexandra Terr. She is a retired thief, and maintains a collection of various maps. A door leads out to Arathel County."
   #:exits '((out . outside-crossed-candles-inn))
  
   #:contents (list alfric)))

(define outside-crossed-candles-inn
  (road #:name "outside Crossed Candles Inn"
        #:exits '((west . crossed-candles-inn))))

(define teraum-map
  (make-hash
   (list
    (cons 'crossed-candles-inn crossed-candles-inn)
    (cons 'outside-crossed-candles-inn outside-crossed-candles-inn))))

(define start-mud
  (lambda (name services)
    (let ([m (make-mud name services)]) (m m))))

(define test-mud (start-mud "TestMUD"
                            (list (mudsocket)
                                  (actions)
                                  (mudmap teraum-map))))
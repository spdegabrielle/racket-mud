#lang racket

(require racket/date)
(require racket/serialize)
(require uuid)

(struct mud (name services hooks things events) #:mutable)
(struct thing (name nouns adjectives qualities handler) #:mutable)

(struct client-attributes (commands in out) #:mutable)
(struct mudsocket-client (in out ip port) #:mutable)

(struct exn:mud exn:fail ())
(struct exn:mud:thing exn:mud ())
(struct exn:mud:thing:creation exn:mud:thing ())

(define user-accounts (make-hash))

(define bugger
  (lambda ()
    (define bugs (list))
    (lambda ([bug #f])
      (cond [bug (set! bugs (append (list bug) bugs))]
            [else bugs]))))
(define bug (bugger))

(define (oxfordize-list strings)
  (cond
    [(null? strings)
     (log-warning "Tried to oxfordize an empty list.")]
    [(null? (cdr strings))
     (car strings)]
    [(null? (cddr strings))
     (string-join strings " and ")]
    [else
     (string-join strings ", "
                  #:before-first ""
                  #:before-last ", and ")]))

(define str-and-sym-list-joiner
    (lambda (strings [sep ""])
      (string->symbol
       (string-join
        (map
         (lambda (string)
           (cond
             [(string? string)
              string]
             [(symbol? string)
              (symbol->string
               string)]))
         strings)
        sep))))

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
      (let* ([thing (thing name (merge-stringy-lists nouns) (merge-stringy-lists adjectives) (cond [qualities (make-hash (filter values qualities))] [else (make-hash)]) (void))])
        (define handler (lambda (event) (event thing)))
        (set-thing-handler! thing handler)
        (when qualities
          (hash-map (thing-qualities thing)
                    (lambda (id quality)
                      (let ([apply-proc-key 
                             (str-and-sym-list-joiner '("apply" id "quality") "-")]
                            [hooks (mud-hooks mud)])
                        (when (hash-has-key? hooks apply-proc-key)
                          ((hash-ref hooks apply-proc-key) handler))))))
        (sch (lambda (mud) (set-mud-things! mud (append (list handler) (mud-things mud)))))
        handler))))
    
(define things-with-quality
  (lambda (things quality)
    (filter values (map (lambda (thing) (thing (lambda (thing) (cond [(hash-has-key? (thing-qualities thing) quality) (thing-handler thing)][else #f])))) things))))

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
        (with-handlers ([exn? (lambda (exn) (log-warning "~a" exn))])
           (display (format (cond
                              [(eq? #\newline (last (string->list message))) "~a"]
                              [else "~a\n"]) message) out)
           (flush-output out))
        (set-quality! 'client-out "")))))


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
           (cond [((hash-ref (mud-hooks mud) 'account?) line)
                  (set! reply (format "There's a extant account for ~a. If it's yours, enter the password and press ENTER. Otherwise, disconnect [and reconnect]." line))
                  (set! login-stage 1)]
                 [else
                  (let ([pass (substring (uuid-string) 0 8)])
                    (set-quality! 'pass pass)
                    ((hash-ref (mud-hooks mud) 'create-account) line pass)
                    (set! reply (format "There's no account named ~a. Your new password is\n\n~a\n\nPress ENTER when you're ready to log in." line pass)))
                  (set! login-stage 9)])]
          [(= login-stage 1)
           (log-debug "CHECKING THE PASSWORD of ~a" (quality 'user-name))
           (log-debug "account is ~a" ((hash-ref (mud-hooks mud) 'account)
                                       (quality 'user-name)))
           (cond
             [(string=? (hash-ref ((hash-ref (mud-hooks mud) 'account)
                                   (quality 'user-name)) 'pass)
                        line)
              (set! reply "Correct. Press ENTER to complete login.")
              (set! login-stage 9)]
             [else (set! reply "Incorrect. Type your [desired] user-name and press ENTER.") (set! login-stage 0)])]
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
        (when (> (string-length line) 0)
          (let* ([spline (string-split line)]
                 [input-command (car spline)] [args (string-join (cdr spline))])
            (cond [(hash-has-key? commands input-command)
                   ((hash-ref commands input-command) args)]
                  [(and location (hash-has-key? ((quality-getter location) 'exits) (string->symbol input-command)))
                   ((move sch thing) input-command)]
                  [else (set! reply "Invalid command.")])))
        (when reply (add-to-out reply))))))

(define accounts
  (lambda ([account-file "user-accounts.rktd"])
    (define accounts (make-hash))
    (lambda (mud sch make)
      (define load-accounts
        (lambda ()
          (when (file-exists? account-file)
            (log-debug "Loading accounts from ~a" account-file)
            (with-handlers ([exn:fail:filesystem:errno?
                             (lambda (exn) (log-warning "~a" exn))])
              (with-input-from-file account-file
                (lambda () (set! accounts (deserialize (read)))))))))
      (define save-accounts
        (lambda () ; save accounts
          (cond
            [(serializable? accounts)
             (with-output-to-file account-file
               (lambda () (write (serialize accounts)))
               #:exists 'replace)
             (load-accounts)]
            [else (log-warning "Account data not serializable.")])))
      (define create-account
        (lambda (name pass)
          (log-info "Creating new user account ~a" name)
          (hash-set! accounts name (make-hash
                                    (list
                                     (cons 'name name)
                                     (cons 'pass pass)
                                     (cons 'birth-time (current-date)))))
          (save-accounts)))
      (define account? (lambda (name) (hash-has-key? accounts name)))
      (define account (lambda (name) (hash-ref accounts name)))
      (let ([set-hook! (lambda (hook value) (hash-set! (mud-hooks mud) hook value))])
        (set-hook! 'save-accounts save-accounts)
        (set-hook! 'create-account create-account)
        (set-hook! 'account? account?)
        (set-hook! 'account account))
      (load-accounts)
      #f)))

(define mudmap
  (lambda ([areas (make-hash)])
    (lambda (mud sch make)
      (hash-set!
       (mud-hooks mud) 'rooms
       areas)
      (hash-set!
       (mud-hooks mud) 'room
       (lambda (id) (hash-ref areas id)))
      (hash-set!
       (mud-hooks mud) 'move
       (lambda (mover destination)
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
                 (set-location-quality!
                  'contents
                  (remove mover (location-quality 'contents))))))
           (set-mover-quality! 'location destination)
           (set-destination-quality!
            'contents
            (append (list mover) (destination-quality 'contents))))))
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
                           (let ([item (item make)])
                             (set! created-contents
                                   (append (list item)
                                           created-contents))
                             ((quality-setter item) 'location area)))
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
                  (let ([created-actions (list)])
                    (for-each
                     (lambda (action)
                       (let ([record
                              (list thing (car action) (cdr action))])
                         (set! created-actions
                               (append (list record) created-actions))
                         (let ([chance (car action)])
                           (hash-set!
                            actions chance
                            (cond [(hash-has-key? actions chance)
                                   (append (list record)
                                           (hash-ref actions chance))]
                                  [else (list record)])))))
                     ((quality-getter thing) 'actions))
                    ((quality-setter thing)
                     'actions created-actions))))
      (lambda ()
        (let ([triggered (list)])
          (hash-map actions
                    (lambda (chance records)
                      (for-each (lambda (record)
                                 (when (<= (random 10000) chance)
                                   (set! triggered
                                         (append (list record)
                                                 triggered))))
                               records)))
          (for-each
           (lambda (action)
             (let* ([actor (first action)]
                    [task (third action)]
                    [actor-quality (quality-getter actor)]
                    [actor-location (actor-quality 'location)]
                    [actor-exits (actor-quality 'exits)])
               (cond
                 [(string? task)
                  ;send to things in th environment
                  (let* ([environment (cond [actor-location actor-location]
                                            [actor-exits actor])])
                    (when (procedure? environment)
                      (let ([environment-contents
                             ((quality-getter environment) 'contents)])
                        (for-each
                         (lambda (thing)
                           (((string-quality-appender thing) 'client-out)
                           task))
                         (things-with-quality environment-contents 'client-out)))))
                  ])))
           triggered))))))


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
          (let ([massive-contents (things-with-quality location-contents 'mass)])
          (unless (null? massive-contents)
            (add-to-out
             (format "Contents: ~a"
                     (oxfordize-list
                      (map (lambda (thing) (thing (lambda (thing) (thing-name thing)))) massive-contents)))))))
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
                                 (evt this-mud)]
                                [else (log-warning "Non-procedure event scheduled: ~a" evt)]))
                        sevts)
                       (set! sevts '())
                       (for-each (lambda (srv) (srv)) (mud-services this-mud))
                       (set! time (cim))))))
    (define clock (λ (mud)
                    (log-info "Starting MUD tick.")
                    (set! tick (tick mud))
                    (λ () (let tock () (tick) (tock)))))
    (λ (mud)
      (current-logger logs)
      (log-info "Loading MUD ~a" (mud-name this-mud))
      (define make (make-thing this-mud sch))
      (set-mud-services! this-mud (filter values (map (lambda (srv) (srv this-mud sch make)) (mud-services this-mud))))
      (log-debug "Hooks are now ~a" (hash-keys (mud-hooks this-mud)))
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
    (area #:name name  #:description description
          #:exits exits #:contents contents)))

(define room
  (lambda (#:name name #:description [description #f] #:exits [exits #f]
           #:contents [contents #f])
    (area #:name name #:description description
          #:exits exits #:contents contents)))

(define inn
  (lambda (#:name name #:description [description #f] #:exits [exits #f]
           #:contents [contents #f])
    (room #:name name #:description description
           #:exits exits #:contents contents)))

(define road
  (lambda (#:name name #:description [description #f] #:exits [exits #f]
           #:contents [contents #f])
    (outdoors #:name name #:description description
              #:exits exits #:contents contents)))

(define lookable
  (lambda (#:name name #:description [description #f]
           #:actions [actions #f])
    (lambda (make)
      (make name
            #:qualities
            (list
             (cond [description (cons 'description description)]
                   [else #f])
             (cond [actions (cons 'actions actions)]
                   [else #f]))))))

(define person
  (lambda (#:name name #:description [description #f]
           #:contents [contents #f] #:actions [actions #f]
           #:mass [mass #f])
    (lambda (make)
      (make name
            #:qualities
            (list
             (cond [description (cons 'description description)]
                   [else #f])
             (cons 'contents
                   (cond [contents contents] [else (cons 'contents (list))]))
             (cond [actions (cons 'actions actions)]
                   [else #f])
             (cond [mass (cons 'mass mass)]
                   [else #f]))))))

(define human
  (lambda (#:name name #:description [description #f]
           #:contents [contents #f] #:actions [actions #f])
    (person #:name name #:description description
            #:contents contents #:actions actions
            #:mass 1)))

(define ghost
  (lambda (#:name name #:description [description #f]
           #:contents [contents #f] #:actions [actions #f])
    (person #:name name #:description description
            #:contents contents #:actions actions)))

(define alfric
  (ghost #:name "Alfric"
         #:description "This is Alfric, a ghost that haunts Crossed Candles Inn."
         #:actions '((3 . "Alfric floats around a bit."))))

(define lexandra
  (human #:name "Lexandra Terr"))

(define windows
  (lookable #:name "windows"))
(define cots
  (lookable #:name "cots"))
  
(define crossed-candles-inn
  (inn #:name "Crossed Candles Inn"
       #:description "This is the Crossed Candles Inn: a simple wooden shack with several shuttered windows. Accomodations consist of a single large room with wooden cots. A door leads out to Arathel County."
       #:exits '((out . outside-crossed-candles-inn))
       #:contents (list alfric lexandra windows cots)))

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
                                  (accounts)
                                  (actions)
                                  (mudmap teraum-map))))
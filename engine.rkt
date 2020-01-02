#lang racket

(require "./utilities/strings.rkt")

(provide make-engine
         run-engine
         (struct-out mud)
         (struct-out thing)
         quality-getter
         quality-setter
         string-quality-appender
         things-with-quality
         matches?
         search
         name
         rename!)

(struct mud (name logger tick events things hooks maker) #:mutable)
(struct thing (name grammar qualities mud) #:mutable)

(define (thing-maker mud)
  (lambda (name
           #:nouns [nouns #f]
           #:adjectives [adjectives #f]
           #:qualities [qualities #f])
  (log-debug "Making a thing named ~a" name)
  (let ([thing
         (thing name
                (make-hash
                 (list
                  (cons 'nouns
                        (merge-stringy-lists nouns))
                  (cons 'adjectives
                        (merge-stringy-lists adjectives))))
                (cond
                  [qualities
                   (make-hash (filter values qualities))]
                  [else (make-hash)])
                mud)])
    (define handler (λ (f) (f thing)))
    (when qualities
      (hash-map (thing-qualities thing)
                (λ (id quality)
                  (let ([apply-proc-key
                         (str-and-sym-list-joiner
                          (list "apply" id "quality") "-")]
                        [hooks (mud-hooks (cdr mud))])
                    (when (hash-has-key? hooks apply-proc-key)
                      ((hash-ref hooks apply-proc-key) handler))))))
    (set-mud-things! (cdr mud) (append (list handler) (mud-things (cdr mud))))
    handler)))

(define (quality-getter thing)
  (λ (quality)
    (thing (lambda (thing)
             (with-handlers
                 ([exn:fail:contract?
                   (λ (exn)
                     (log-warning "Tried to get non-existent ~a quality from ~a." quality (thing-name thing))
                     #f)])
               (hash-ref (thing-qualities thing) quality))))))

(define (quality-setter thing)
  (λ (quality value)
    (log-debug "Setting quality ~a of thing ~a to ~a"
               quality (name thing)
               value)
    (thing (λ (thing) (hash-set! (thing-qualities thing) quality value)))))

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

(define (things-with-quality things quality)
  (log-debug "Looking at things ~a for quality ~a" things quality)
    (filter values (map (λ (thing) (let ([result (thing (λ (thing) (hash-has-key? (thing-qualities thing) quality)))]) (cond [result thing][else result]))) things)))

(define (matches? thing term)
    (cond [(string=? (string-downcase (name thing)) term) #t]
          [else #f]))

(define search
  (lambda (things term)
    (let ([matches
           (filter
            values
            (map
             (lambda (thing)
               (cond [(matches? thing term) thing]
                     [else #f]))
             things))])
      (cond
        [(= (length matches) 0)
         "No matching things."]
        [(= (length matches) 1)
         (car matches)]
        [else
         (format "Multiple matches: ~a"
                 (oxfordize-list
                  (map (lambda (thing) (name thing)) matches)))]))))
(define name
  (lambda (thing)
    (thing (lambda (thing) (thing-name thing)))))
(define rename!
  (lambda (thing name)
    (thing (lambda (thing) (set-thing-name! thing name)))))

; Given a name and perhaps a sequence of functions, returns a pair, the first element of which is the engine's scheduling function and the second element of which is the MUD's current state.
(define (make-engine name [events #f])
  (define l (make-logger 'MUD))
  (define L (make-log-receiver l 'debug))
  (current-logger l)
  (define M (mud name ; MUD's name
                 (cons l L) ; logger and log-receiver
                 0 ; tick-count
                 (cond [events events][else '()]) ; scheduled events
                 '() ; things
                 (make-hash) ; hooks
                 (void))) ; maker
  (define (s e) (when (procedure? e) (set-mud-events! M (append (mud-events M) (list e)))))
  (define R (cons s M))
  (set-mud-maker! M (thing-maker R))
  ; M : state, s : scheduler, R: pair of scheduler and state
  (log-debug "Made MUD engine named ~a." name)
  R)

; Given the MUD's current state, calls all scheduled functions and returns the MUD's new state.
(define (tick R)
  ; "Le temps est ce qui empêche que tout soit donné tout d'un coup."
  (let* ([state (cdr R)]
         [events (mud-events state)])
    (let loop ()
      (unless (null? events)
        (let ([event (car events)])
          (let ([event-result (event R)])
            (when event-result (set! R event-result)))
          (set! events (cdr events))
          (let ([current-state (cdr R)])
            (set-mud-events! current-state (cdr (mud-events current-state))))
        (loop))))
    R))

; Given a MUD's state, sets up a thread for "ticking" the state forward. Passes through the current state.
(define (run-engine R)
  (let ([S (car R)] [M (cdr R)])
    ; S : scheduler, M : state
    (define (cim) (current-inexact-milliseconds))
    (define t (cim))
    (thread
     (λ ()
       (let loop ()
         (define q (sync (cdr (mud-logger M))))
         (printf "~a, tick #~a: ~a\n"
                 (vector-ref q 0) (mud-tick M) (vector-ref q 1))
         (loop))))
    (thread
     (λ ()
       (let loop ()
         (when (> (- (cim) t) 333)
           (set-mud-tick! M (add1 (mud-tick M)))
           (set! R (tick R)) (set! t (cim)))
         (loop))))
    R))

; So to use:

; (define teraum (run-engine (make-engine "Teraum")))
; (define schedule (car teraum))
; (schedule (lambda (R)
;    (let ([same-scheduler (car R)]
;          [mud-state (cdr R)])
;    (log-debug "Current events are ~a"
;       (mud-events mud-state)))
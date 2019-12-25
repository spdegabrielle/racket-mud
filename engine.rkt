#lang racket

(require "./utilities/strings.rkt")

(provide (struct-out mud)
         (struct-out thing)
         start-mud
         quality-getter
         quality-setter
         string-quality-appender
         name
         set-name!
         things-with-quality
         matches?
         search)

(struct mud (name services hooks things events) #:mutable)
(struct thing (name nouns adjectives qualities handler) #:mutable)

(struct exn:mud exn:fail ())
(struct exn:mud:thing exn:mud ())
(struct exn:mud:thing:creation exn:mud:thing ())

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

(define make-thing
  (lambda (mud sch)
    (lambda (name #:nouns [nouns #f]
                  #:adjectives [adjectives #f]
                  #:qualities [qualities #f])
      (log-debug "Making a thing named ~a" name)
      (let* ([thing (thing name (merge-stringy-lists nouns) (merge-stringy-lists adjectives) (cond [qualities (make-hash (filter values qualities))] [else (make-hash)]) (void))])
        (define handler (lambda (event) (event thing)))
        (set-thing-handler! thing handler)
        (when qualities
          (hash-map (thing-qualities thing)
                    (lambda (id quality)
                      (let ([apply-proc-key 
                             (str-and-sym-list-joiner (list "apply" id "quality") "-")]
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
(define set-name!
  (lambda (thing name)
    (thing (lambda (thing) (set-thing-name! thing name)))))

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
      (set-mud-services! this-mud (filter values (map (lambda (srv) (log-debug "Loading ~a" srv) (srv this-mud sch make)) (mud-services this-mud))))
      (log-debug "Loaded hooks are ~a" (hash-keys (mud-hooks this-mud)))
      (thread (clock mud))
      (thread (λ () (let loop () (define l (sync logr))
                      (printf "~a, tick #~a: ~a\n"
                              (vector-ref l 0) tc (vector-ref l 1))
                      (loop))))
      sch)))

(define start-mud
  (lambda (name services)
    (let ([m (make-mud name services)]) (m m))))

#lang racket
(require uuid)

(require "./logger.rkt")

(provide (struct-out thing)
         extant-things
         create-thing
         destroy-thing
         thing-has-qualities?
         give-thing-new-qualities
         replace-thing-qualities
         get-thing-quality
         get-thing-qualities
         set-thing-quality
         add-noun-to-thing)

(struct thing (id adjectives nouns qualities) #:mutable)

(define extant-things (make-hash))

(define (create-thing [adjectives #f] [nouns #f]
                      [qualities #f] [updates #f])
  (let ([new-thing
         (thing (generate-thing-id)
                (cond
                  [(list? adjectives)
                   adjectives]
                  [else (void)])
                (cond
                  [(list? nouns)
                   nouns]
                  [else (list "thing")])
                (cond
                  [(list? qualities)
                   qualities]
                  [else (list)]))])
    (when (hash? updates)
      (hash-map
       (lambda (quality value)
         (hash-set! (thing-qualities thing) quality value))
       updates))
    (hash-set! extant-things (thing-id new-thing) new-thing)
    new-thing))

(define (add-noun-to-thing noun thing)
  (set-thing-nouns! thing (append (list noun) (thing-nouns thing))))

(define (thing-has-qualities? thing qualitiesp)
  (let ([answer #f])
    (map
     (lambda (qualities)
       (when (qualitiesp qualities)
         (set! answer #t)))
     (thing-qualities thing))
    answer))

(define (give-thing-new-qualities thing qualities)
  (set-thing-qualities! thing
        (append (thing-qualities thing) qualities)))

(define (get-thing-quality thing setp quality)
  (let ([match (void)])
    (map (lambda (set)
           (when (setp set)
             (set! match (quality set))))
         (thing-qualities thing))
    match))

(define (get-thing-qualities thing setp)
  (let ([match (void)])
    (map (lambda (set)
           (when (setp set)
             (set! match set)))
         (thing-qualities thing))))
  ;(let ([matches
  ;       (map (lambda (set)
  ;              (when (setp set)
  ;                (log-debug "match")
  ;                set))
  ;            (thing-qualities thing))])
  ;    (car (remq* (list (void)) matches)))))

(define (set-thing-quality thing setp quality-setter value)
  (current-logger (make-logger 'Thing-set-thing-quality
                               mudlogger))
  (map (lambda (set)
         (when (setp set)
           (quality-setter set value)))
       (thing-qualities thing)))

(define (replace-thing-qualities thing setp new-qualities)
  (map (lambda (current-set)
         (when (setp current-set)
           (set-thing-qualities!
            thing
            (append (remove current-set (thing-qualities thing))
                    (list new-qualities)))))
       (thing-qualities thing)))

(define (destroy-thing id)
  (hash-remove! extant-things id))

(define (generate-thing-id)
  (let ([potential-id (uuid-string)])
    ; if the ID is in the Table of Extant Things, try again.
    (cond
      [(hash-has-key? extant-things potential-id)
       (generate-thing-id)]
      [else
       potential-id])))
#lang racket
(require uuid)

(require "./logger.rkt")
(require "./utilities/string.rkt")

(provide (struct-out thing)
         (struct-out quality)
         (struct-out recipe)
         extant-things
         create-thing
         destroy-thing
         thing-has-qualities?
         thing-has-quality?
         give-thing-new-qualities
         get-thing-quality
         get-thing-qualities
         set-thing-quality
         add-noun-to-thing
         first-noun
         term-matches-thing?
         get-quality-attribute
         set-quality-attribute!
         get-thing-quality-attribute
         get-thing-quality-attributes
         set-thing-quality-attribute!
         things-with-quality
         make-recipe)

(struct thing (id nouns adjectives qualities) #:mutable)
(struct quality (procedure attributes) #:mutable)
(struct recipe (nouns adjectives qualities) #:mutable)


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

(define (things-with-quality things quality)
  (filter values
          (map (lambda (thing)
                 (cond [(thing-has-quality? thing quality)
                        thing]
                       [else #f]))
               things)))

(define (make-recipe recipe)
  (log-debug "making recipe ~a: ~a\n~a\n~a" recipe (recipe-nouns recipe) (recipe-adjectives recipe) (recipe-qualities recipe))
  (let ([new-thing 
         (thing (generate-thing-id) (recipe-nouns recipe)
                (recipe-adjectives recipe)
                (recipe-qualities recipe))])
    (hash-map (thing-qualities new-thing)
             (lambda (quality-key quality-value)
               ((quality-procedure quality-value) new-thing)))
    new-thing))

(define (first-noun thing)
  (when (thing? thing)
  (first (thing-nouns thing))))

(define (give-thing-new-qualities thing qualities)
  (log-debug "give thing new qualities new qualities are ~a" qualities)
  (hash-map qualities
            (lambda (quality-key quality-value)
              (hash-set! (thing-qualities thing) quality-key quality-value)
              ((quality-procedure (get-thing-quality thing quality-key)) thing))))

(define (get-thing-quality thing quality-symbol)
  (let ([qualities (thing-qualities thing)])
    (cond
      [(hash-has-key? qualities quality-symbol)
       (hash-ref qualities quality-symbol)]
      [else
       (log-warning "Looked for ~a quality in thing #~a (~a) but it lacks it."
                    quality-symbol (thing-id thing) (first (thing-nouns thing)))])))

(define (thing-has-quality? thing quality-symbol)
  (hash-has-key? (thing-qualities thing) quality-symbol))

(define (get-quality-attribute quality attribute)
  (cond [(hash-has-key? (quality-attributes quality) attribute)
         (hash-ref (quality-attributes quality) attribute)]
        [else
         (log-warning "Looked up ~a attribute in quality ~a but it lacked it."
                      attribute quality)]))

(define (set-quality-attribute! quality attribute value)
  (hash-set! (quality-attributes quality) attribute value))

(define (get-thing-quality-attribute thing quality attribute)
  (get-quality-attribute (get-thing-quality thing quality) attribute))

(define (get-thing-quality-attributes thing quality)
  (quality-attributes (get-thing-quality thing quality)))

(define (set-thing-quality-attribute! thing quality attribute value)
  (log-debug "setting ~a ~a ~a to ~a" thing quality attribute value)
  (hash-set! (get-thing-quality-attributes thing quality) attribute value)
  (log-debug "its now ~a" (get-thing-quality-attribute thing quality attribute)))

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

(define (destroy-thing id)
  (hash-remove! extant-things id))

(define (term-matches-thing? term thing)
  (log-debug "termmatches-thing? looking at ~a:\n~a\n~a\n~a"
             (first (thing-nouns thing))
             (thing-nouns thing)
             (thing-adjectives thing)
             (thing-qualities thing))
  (let* ([result #f]
         [terml (string-split term)]
         [thing-nouns (thing-nouns thing)]
         [thing-adjectives (thing-adjectives thing)]
         [thing-nounphrases (filter-multiple-word-strings-from-strings thing-nouns)]
         [thing-adjectivephrases (filter-multiple-word-strings-from-strings thing-adjectives)])
    (cond
      [(null? thing-nounphrases)
       (log-debug "thing only has single-word nouns\n")
       ; goto STAGE 2
       (let ([term-noun (last terml)])
         (log-debug (format "term noun is ~a\n" term-noun))
         (cond
           [(member term-noun thing-nouns)
            (log-debug (format "noun matches! ~a\n" term-noun))
            (set! terml (reverse (cdr
                          (reverse terml))))
            (when (string? terml)
              (set! terml (list terml)))
            (log-debug (format "terml is now ~a\n" terml))
            (cond
              [(null? terml)
               (set! result #t)]
              [else 
               (cond
                 [(null? thing-adjectivephrases)
                  (log-debug "thing only has single-word adjectives\n")
                  (let ([matching-adjectives (list)])
                    (map (lambda (term-adjective)
                           (cond
                             [(member term-adjective thing-adjectives)
                              (set! matching-adjectives (append matching-adjectives (list term-adjective)))]))
                         terml)
                    (log-debug (format "matching adjectives are ~a\n" matching-adjectives))
                    (set! terml (remove* matching-adjectives terml))
                    (log-debug (format "terml is now ~a\n" terml)))
                  (cond
                    [(null? terml)
                     (log-debug "whole term matches\n")
                     (set! result #t)]
                    [else
                     (log-debug "leftover adjectives\n")])]
                 [else
               (log-debug "thing has adjective phrases\n")
               (map
                (lambda (thing-adjectivephrase)
                  (let ([length-of-adjectivephrase
                         (length (string-split thing-adjectivephrase))])
                    (cond
                      [(>= (length terml) length-of-adjectivephrase)
                       (let* ([tmp-terml terml]
                              [term-adjectivephrases
                               (append (list (string-join (take terml length-of-adjectivephrase)))
                                       (filter
                                        values
                                        (map
                                         (lambda (iteration)
                                           (log-debug (format "tmp-terml is ~a\n" tmp-terml))
                                           (cond [(>
                                                   (length tmp-terml)
                                                   length-of-adjectivephrase)
                                                  (set! tmp-terml (cdr tmp-terml))
                                                  (string-join
                                                   (take tmp-terml length-of-adjectivephrase))]
                                                 [else #f]))
                                         (build-list length-of-adjectivephrase values))))])
                         (log-debug (format "term-adjectivephrases of appropriate length are ~a\n" term-adjectivephrases))
                         (map
                          (lambda (term-adjectivephrase)
                            (log-debug (format "comparing term-adjectivephrase ~a\n"
                                            term-adjectivephrase))
                            (cond
                              [(member
                                term-adjectivephrase
                                thing-adjectivephrases)
                               (log-debug (format "adjectivephrase matches ~a\n"
                                               term-adjectivephrase))
                               (set! terml (remove* (string-split
                                                     term-adjectivephrase) terml))]))
                          term-adjectivephrases)
                         (cond
                           [(null? terml)
                            (set! result #t)]
                           [else
                            (log-debug (format "still have adjectives to match: ~a" terml))
                            (let ([matching-adjectives (list)])
                              (map (lambda (term-adjective)
                                     (cond
                                       [(member term-adjective thing-adjectives)
                                        (set! matching-adjectives (append matching-adjectives (list term-adjective)))]))
                                   terml)
                              (log-debug (format "matching adjectives are ~a\n" matching-adjectives))
                              (set! terml (remove* matching-adjectives terml))
                              (log-debug (format "terml is now ~a\n" terml)))
                            (cond
                              [(null? terml)
                               (log-debug "whole term matches\n")
                               (set! result #t)]
                              [else
                               (log-debug "leftover adjectives\n")])]))]
                      [else
                       (void)])))
                thing-adjectivephrases)])])]
              [else
               (log-debug (format "no matching nouns - no match.\n"))]))]
      [else
       ; nounphrases need to be looked through
       (log-debug (format "terml is ~a\n" terml))
       (map
        (lambda (thing-nounphrase)
          (let ([length-of-nounphrase (length (string-split thing-nounphrase))])
            (log-debug (format "length of nounphrase is ~a\n" length-of-nounphrase))
            (cond
              [(>= (length terml) length-of-nounphrase)
               (let ([potential-nounphrase
                      (string-downcase (string-join (take-right terml length-of-nounphrase)))])
                 (log-debug (format "thing-nounphrase is ~a potential noun phrase is ~a\n" thing-nounphrase potential-nounphrase))
                 (cond
                   [(string=? thing-nounphrase potential-nounphrase)
                    (map (lambda (position)
                           (set! terml (reverse (cdr (reverse terml))))
                           (log-debug (format "terml is now ~a\n" terml)))
                         (build-list length-of-nounphrase values))
                    (cond
                      [(= (length terml) 0)
                       (set! result #t)]
                      [else
                       (log-debug (format "terml has unmatched parts: ~a\n" terml))
                       ])]))]
              [else
               (log-debug "nounphrase longer than terml\n")])))
        thing-nounphrases)])
    result))

(define (check-string-for-strings string strings)
  (list))

(define (check-thing-adjectives thing term)
  (let* ([thing-adjectives (thing-adjectives thing)]
         [thing-adjective-phrases
          (filter-multiple-word-strings-from-strings
           thing-adjectives)]
         [matches (list)])
    (cond
      [(null? thing-adjective-phrases)
       ; only one-word adjectives
       (for-each
        (lambda (term-adjective)
          (when (member term-adjective thing-adjectives)
            (set! matches
                  (append matches (list term-adjective))))))]
      [else
       ; thing has adjective phrases
       (void)])
    matches))


(define (generate-thing-id)
  (let ([potential-id (uuid-string)])
    ; if the ID is in the Table of Extant Things, try again.
    (cond
      [(hash-has-key? extant-things potential-id)
       (generate-thing-id)]
      [else
       potential-id])))
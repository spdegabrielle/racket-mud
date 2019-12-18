#lang racket
(require uuid)

(require "../logger.rkt")
(require "../utilities/string.rkt")

(provide (struct-out thing)
         generate-thing-id
         destroy-thing
         thing-has-quality?
         add-noun-to-thing
         first-noun
         term-matches-thing?)

(struct thing (id nouns adjectives qualities) #:mutable)

(define extant-things (make-hash))

(define (add-noun-to-thing noun thing)
  (set-thing-nouns! thing (append (list noun) (thing-nouns thing))))

(define (first-noun thing)
  (when (thing? thing)
  (first (thing-nouns thing))))


(define (filter-things-with-quality things quality)
  (filter values
          (map (lambda (thing) (cond [(thing-has-quality? thing quality) thing]
                                     [else #f])) things)))

(define (thing-has-quality? thing quality-symbol)
  (hash-has-key? (thing-qualities thing) quality-symbol))


(define (destroy-thing id)
  (hash-remove! extant-things id))

(define (term-matches-thing? term thing)
  (let* ([result #f]
         [terml (string-split term)]
         [thing-nouns (thing-nouns thing)]
         [thing-adjectives (thing-adjectives thing)]
         [thing-nounphrases (filter-multiple-word-strings-from-strings thing-nouns)]
         [thing-adjectivephrases (filter-multiple-word-strings-from-strings thing-adjectives)])
    (cond
      [(null? thing-nounphrases)
       ; goto STAGE 2
       (let ([term-noun (last terml)])
         (cond
           [(member term-noun thing-nouns)
            (set! terml (reverse (cdr
                          (reverse terml))))
            (when (string? terml)
              (set! terml (list terml)))
            (cond
              [(null? terml)
               (set! result #t)]
              [else 
               (cond
                 [(null? thing-adjectivephrases)
                  (let ([matching-adjectives (list)])
                    (map (lambda (term-adjective)
                           (cond
                             [(member term-adjective thing-adjectives)
                              (set! matching-adjectives (append matching-adjectives (list term-adjective)))]))
                         terml)
                    (set! terml (remove* matching-adjectives terml)))
                  (cond
                    [(null? terml)
                     (set! result #t)])]
                 [else
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
                                           (cond [(>
                                                   (length tmp-terml)
                                                   length-of-adjectivephrase)
                                                  (set! tmp-terml (cdr tmp-terml))
                                                  (string-join
                                                   (take tmp-terml length-of-adjectivephrase))]
                                                 [else #f]))
                                         (build-list length-of-adjectivephrase values))))])
                         (map
                          (lambda (term-adjectivephrase)
                            (cond
                              [(member
                                term-adjectivephrase
                                thing-adjectivephrases)
                               (set! terml (remove* (string-split
                                                     term-adjectivephrase) terml))]))
                          term-adjectivephrases)
                         (cond
                           [(null? terml)
                            (set! result #t)]
                           [else
                            (let ([matching-adjectives (list)])
                              (map (lambda (term-adjective)
                                     (cond
                                       [(member term-adjective thing-adjectives)
                                        (set! matching-adjectives (append matching-adjectives (list term-adjective)))]))
                                   terml)
                              (set! terml (remove* matching-adjectives terml)))
                            (cond
                              [(null? terml)
                               (set! result #t)])]))]
                      [else
                       (void)])))
                thing-adjectivephrases)])])]))]
      [else
       ; nounphrases need to be looked through
       (map
        (lambda (thing-nounphrase)
          (let ([length-of-nounphrase (length (string-split thing-nounphrase))])
            (cond
              [(>= (length terml) length-of-nounphrase)
               (let ([potential-nounphrase
                      (string-downcase (string-join (take-right terml length-of-nounphrase)))])
                 (cond
                   [(string=? thing-nounphrase potential-nounphrase)
                    (map (lambda (position)
                           (set! terml (reverse (cdr (reverse terml)))))
                         (build-list length-of-nounphrase values))
                    (cond
                      [(= (length terml) 0)
                       (set! result #t)])]))])))
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
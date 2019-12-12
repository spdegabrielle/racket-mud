#lang racket

(require uuid)

(require "./logger.rkt")

(require "./qualities/visual.rkt")

(define extant-things (make-hash))

(struct thing (id adjectives nouns qualities) #:mutable)

(struct visual (brief description) #:mutable)

(define (get-visual-brief thing)
  (let ([brief (void)])
    (for-each (lambda (quality)
           (when (visual? quality)
             (set! brief (visual-brief quality))))
      (thing-qualities thing))
    brief))

(define (filter-multiple-word-strings-from-strings strings)
  (filter values
          (map
           (lambda (str)
             (cond
               [(> (length (string-split str)) 1)
                str]
               [else #f]))
           strings)))

(define (term-matches-thing? term thing)
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

; STAGE 1: Matching Noun Phrases
; when there are noun phrases (otherwise move to STAGE 2)
; look through them
; take the last N words of term, where N is the length of the noun phrase
; do they match?
; if so, remove them from the term and move to STAGE 3
; else, move to STAGE 2
; STAGE 2: Matching nouns
; look through the nouns
; take the last word of term, does it match?
; if so, remove it from the term and move to STAGE 3
; STAGE 3: Matching Adjective Phrases
; when there are adjective phrases, look through them (otherwise move to STAGE 4)
; look at every N block of elements, where N is the length of the adjective phrase
; does it match? if so, remove it from the term and keep looking through adjective phrases
; when done, move to STAGE 4
; STAGE 4: Matching Adjectives
; when there are adjectives, look through them
; look at every word of the remaining term
; does it match? if so, remove it and keep looking through the adjectives
; when done, move to STAGE 5
; look at the remaining term
; if there are any words left in it, the term doesn't match, move to STAGE 0
; otherwise, the term matches, move to STAGE 6
; STAGE 6
; return the thing
; STAGE 0
; return an error: term doesn't match

(define apple (thing 1 (list "shiny" "red") (list "apple" "fruit") (list)))

(define john (thing 2 (list "strong") (list "john henry" "man") (list)))

(define medal (thing 3 (list "saint christopher") (list "medal") (list)))

(term-matches-thing? "apple" apple)                                ; #t
(term-matches-thing? "red apple" apple)                            ; #t 
(term-matches-thing? "shiny red apple" apple)                      ; #t
(term-matches-thing? "blue apple" apple)                           ; #f
(term-matches-thing? "John" john)                                  ; #f
(term-matches-thing? "John Henry" john)                            ; #t
(term-matches-thing? "strong John Henry" john)                     ; #t
(term-matches-thing? "medal" medal)                                ; #t
(term-matches-thing? "christopher medal" medal)                    ; #f
(term-matches-thing? "saint christopher medal" medal)              ; #t
(term-matches-thing? "bloody metal saint christopher medal" medal) ; #f

    


;
;(define (generate-thing-id)
;  (let ([potential-id (uuid-string)])
;    ; if the ID is in the Table of Extant Things, try again.
;    (cond
;      [(hash-has-key? extant-things potential-id)
;       (generate-thing-id)]
;      [else
;       potential-id])))
;
;(define (make-recipe recipe)
;  (let ([new-thing (thing (generate-thing-id) (list) (list "thing") (list))]
;        [recipe-adjectives (first recipe)]
;        [recipe-nouns (second recipe)]
;        [recipe-qualities (third recipe)])
;    (add-adjectives-to-thing recipe-adjectives new-thing)
;    (add-nouns-to-thing recipe-nouns new-thing)
;    (add-qualities-to-thing recipe-qualities)
;    new-thing))
;
;(define (add-adjectives-to-thing adjectives thing)
;  (set-thing-adjectives! (append (thing-adjectives)
;                                 (cond
;                                   [(list? adjectives)
;                                    adjectives]
;                                   [(string? adjectives)
;                                    (list adjectives)]))))
;
;(define (add-qualities-to-thing qualities thing)
;  #t)
;
;(define (add-nouns-to-thing nouns thing)
;  (set-thing-nouns! (append (thing-nouns)
;                                 (cond
;                                   [(list? nouns)
;                                    nouns]
;                                   [(string? nouns)
;                                    (list nouns)]))))
;
;(define apple (make-recipe
;               (list
;                (list "shiny" "red") (list "apple" "fruit")
;                (list
;                 (visual
;                  "shiny red apple"
;                  "This is a shiny red apple.")))))
;
;(define astar-henri (make-recipe
;                     (list
;                      (void) "Henri Astar"
;                      (list
;                       (visual
;                        "Henri Astar"
;                        "This is a masculine human.")))))
;                      
;
;(get-visual-brief apple)

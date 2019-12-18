#lang racket

(require "../data-structures/thing.rkt")
(require "../data-structures/quality.rkt")

(provide thing-quality
         thing-quality-structure
         filter-things-with-quality
         give-thing-new-qualities)

(define (thing-quality thing quality-symbol)
  (let ([qualities (thing-qualities thing)])
    (cond
      [(hash-has-key? qualities quality-symbol)
       (hash-ref qualities quality-symbol)]
      [else
       (log-warning "Looked for ~a quality in thing #~a (~a) but it lacks it."
                    quality-symbol (thing-id thing) (first (thing-nouns thing)))])))


(define (thing-quality-structure thing quality)
  (quality-structure (thing-quality thing quality)))


(define (filter-things-with-quality things quality)
  (filter values
          (map (lambda (thing)
                 (cond [(thing-has-quality? thing quality)
                        thing]
                       [else #f]))
               things)))



(define (give-thing-new-qualities thing qualities)
  (hash-map qualities
            (lambda (quality-key quality-value)
              (hash-set! (thing-qualities thing) quality-key quality-value)
              ((quality-procedure (thing-quality thing quality-key)) thing))))
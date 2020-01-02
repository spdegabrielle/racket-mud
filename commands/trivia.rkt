#lang racket

(require "../engine.rkt"
         "../utilities/strings.rkt")
(provide trivia)


(define (trivia thing)
  (define quality (quality-getter thing))
  (define set-quality! (quality-setter thing))
  (define add-to-out ((string-quality-appender thing) 'client-out))
  (define (trivium thing)
    (let ([trivias ((quality-getter thing) 'trivia)])
      (add-to-out
       (cond
         [trivias (car (shuffle trivias))]
         [else "There's no trivia recorded for ~a." (name thing)]))))
  (λ (args)
    (cond [(hash-empty? args)
           (trivium (quality 'location))]
          [(hash-has-key? args "container")
           (add-to-out "Looking inside things doesn't work yet.")]
          [(hash-has-key? args 'line)
           (let* ([look-in (append (quality 'contents)
                                   ((quality-getter (quality 'location)) 'contents))]
                  [matches (search look-in (hash-ref args 'line))])
             (cond
               [(procedure? matches)
                (trivium matches)]
               [(string? matches)
                (add-to-out matches)]))])))
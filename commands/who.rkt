#lang racket
(require "../engine.rkt"
         "../utilities/strings.rkt")
(provide who)
(define (who thing)
    (define quality (quality-getter thing))
    (define set-quality! (quality-setter thing))
    (define add-to-out ((string-quality-appender thing) 'client-out))
    (lambda (args)
      (let ([current-who (quality 'commands)])
        (add-to-out (format
                     "The following users are currently connected: ~a"
                     (oxfordize-list ()))))))
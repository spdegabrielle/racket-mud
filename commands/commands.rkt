#lang racket
(require "../engine.rkt")
(require "../utilities/strings.rkt")
(provide commands)
(define commands
  (lambda (sch thing)
    (define quality (quality-getter thing))
    (define set-quality! (quality-setter thing))
    (define add-to-out ((string-quality-appender thing) 'client-out))
    (lambda (args)
      (let ([commands (quality 'commands)])
        (add-to-out (format
                     "You have the following commands: ~a"
                     (oxfordize-list (hash-keys commands))))))))
#lang racket

(require "../engine.rkt")
(require "./look.rkt")
(provide move)
(define move
  (lambda (sch thing)
    (define quality (quality-getter thing)) (define set-quality! (quality-setter thing))
    (define add-to-out ((string-quality-appender thing) 'client-out))
    (lambda (args)
      (let* ([location (quality 'location)]
             [location-quality (quality-getter location)]
             [location-exits (location-quality 'exits)]
             [desired-exit (string->symbol args)])
        (cond
          [(hash-has-key? location-exits desired-exit)
           (add-to-out (format "You attempt to move ~a" args))
           (sch (lambda (mud)
                  ((hash-ref (mud-hooks mud) 'move) thing (hash-ref location-exits desired-exit))
                  ((look sch thing) (make-hash))))]
          [else (add-to-out "Invalid exit.")])))))
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
             [location-exits (location-quality 'exits)])
        (cond
          [(hash-has-key? args 'line)
           (let ([desired-exit (string->symbol (hash-ref args 'line))])
             (cond 
               [(hash-has-key? location-exits desired-exit)
                (add-to-out (format "You attempt to move ~a" (hash-ref args 'line)))
                (sch (lambda (mud)
                       ((hash-ref (mud-hooks mud) 'move) thing (hash-ref location-exits desired-exit))
                       ((look sch thing) (make-hash))))]
               [else (add-to-out "Invalid exit.")]))]
          [else
           (add-to-out "You must use this command with an exit. You can find those by using the \"look\" command.")])))))
#lang racket

(require "../engine.rkt")
(require "../utilities/strings.rkt")
(provide look)
(define look
  (lambda (sch thing)
    (define quality (quality-getter thing)) (define set-quality! (quality-setter thing))
    (define add-to-out ((string-quality-appender thing) 'client-out))
    (define look-area
      (lambda (area)
        (let* ([area-quality (quality-getter area)]
               [area-desc (area-quality 'description)]
               [area-exits (area-quality 'exits)]
               [area-contents (area-quality 'contents)])
          (add-to-out (format "[~a]" (name area)))
          (when area-desc (add-to-out (format "~a" area-desc)))
          (when area-contents
            (let ([massive-contents
                   (things-with-quality area-contents 'mass)])
              (unless (null? massive-contents)
                (add-to-out
                 (format "Contents: ~a"
                         (oxfordize-list
                          (map (lambda (thing)
                                 (name thing))
                          massive-contents)))))
              (when area-exits
                (add-to-out
                 (format "Exits: ~a"
                         (oxfordize-list
                          (map symbol->string
                               (hash-keys area-exits)))))))))))
    (lambda (args)
      (cond [(hash-empty? args)
              (look-area (quality 'location))]))))
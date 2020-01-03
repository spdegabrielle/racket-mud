#lang racket

(require "../engine.rkt"
         "../utilities/strings.rkt")
(provide look)

(define (look thing)
  (define quality (quality-getter thing))
  (define set-quality! (quality-setter thing))
  (define add-to-out ((string-quality-appender thing) 'client-out))
  (define (look-area area)
    (let* ([area-quality (quality-getter area)]
           [area-desc (area-quality 'description)]
           [area-exits (area-quality 'exits)]
           [area-contents (area-quality 'contents)])
      (log-debug "area contents are ~a" area-contents)
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
                           (hash-keys area-exits))))))))))
  (define (look-item item)
    (let* ([item-quality (quality-getter item)]
           [item-desc (item-quality 'description)]
           [item-contents (item-quality 'contents)])
      (log-debug "ITEM CONTENTS ARE ~a" item-contents)
      (add-to-out (format "[~a]" (name item)))
      (when item-desc (add-to-out (format "~a" item-desc)))
      (when item-contents
            (let ([massive-contents
                   (things-with-quality item-contents 'mass)])
              (unless (null? massive-contents)
                (add-to-out
                 (format "Contents: ~a"
                         (oxfordize-list
                          (map (lambda (thing)
                                 (name thing))
                               massive-contents)))))))))
  (λ (args)
    (cond [(hash-empty? args)
           (look-area (quality 'location))]
          [(hash-has-key? args "container")
           (add-to-out "Looking inside things doesn't work yet.")]
          [(hash-has-key? args 'line)
           ; > look hairy banana
           ; collect list of (looker inventory + looker location's contents)
           (let* ([look-in (append (quality 'contents)
                                   ((quality-getter (quality 'location)) 'contents))]
                  [matches (search look-in (hash-ref args 'line))])
             (cond
               [(procedure? matches)
                (look-item matches)]
               [(string? matches)
                (add-to-out matches)]))])))
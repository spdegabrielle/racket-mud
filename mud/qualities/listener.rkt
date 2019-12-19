#lang racket

(require "../data-structures/thing.rkt")
(require "../data-structures/quality.rkt")
(require "../services/talker.rkt")
(require "../utilities/thing.rkt")

(provide listener-quality
         listener-channels
         set-listener-channels!
         add-listener-channel!
         remove-listener-channel!
         listener-of-channel?)

(struct listener-struct (channels) #:mutable)

(define (apply-listener-quality thing)
  (for-each (lambda (channel) (add-channel-listener! channel thing))
            (listener-channels thing)))

(define (listener-quality channels)
  (quality apply-listener-quality
           (listener-struct channels)))

(define (get-listener-structure thing)
  (thing-quality-structure thing 'listener))

(define (listener-channels thing)
  (listener-struct-channels (get-listener-structure thing)))

(define (set-listener-channels! thing channels)
  (set-listener-struct-channels! (get-listener-structure thing) channels))

(define (add-listener-channel! thing channel)
  (set-listener-channels! thing (append (list channel) (listener-channels thing))))
(define (remove-listener-channel! thing channel)
  (set-listener-channels! thing (remove channel (listener-channels thing))))


(define (listener-of-channel? thing channel)
  (cond
    [(member channel (listener-channels thing))
     #t]
    [else #f]))

#lang racket

(require "./engine.rkt")
(provide talker)
(define (talker [chans '("cq")])
  (define channels (make-hash
                    (map
                     (lambda (channel) (cons channel (list)))
                     chans)))
  (λ (state)
    (define (add-listener! name listener)
      (let ([listeners (hash-ref channels name)])
        (hash-set! channels name (append (list listener) listeners))
        ((quality-setter listener)
         'channels (append (list name) ((quality-getter listener) 'channels)))))
    (define (remove-listener! name listener)
      (let ([listeners (hash-ref channels name)])
        (hash-set! channels name (remove listener listeners))))
    (define (broadcast chan speaker message)
      (map
       (λ (listener)
         (define add-to-out
           ((string-quality-appender listener) 'client-out))
         (add-to-out (format "(~a) ~a: ~a"
                             chan
                             (name speaker)
                             message)))
       (hash-ref channels chan)))
    (define (tune-in chan listener)
      (define
        tune-in (λ (chan listener)
                  (unless (member
                           chan
                           ((quality-getter listener) 'channels))
                    (add-listener! chan listener))))
      (cond
        [(list? chan) (for-each (λ (chan) (tune-in chan listener))
                                chan)]
        [(string? chan)
         (tune-in chan listener)]))
  (define (tune-out chan listener)
    (define
      tune-out (λ (chan listener)
                 (remove-listener! chan listener)))
    (cond
      [(list? chan) (for-each (λ (chan) (tune-out chan listener))
                              chan)]
      [(string? chan)
       (tune-out chan listener)]))
    (let ([hooks (mud-hooks (cdr state))])
      (hash-set! hooks 'broadcast broadcast)
      (hash-set! hooks 'tune-in tune-in)
      (hash-set! hooks 'tune-out tune-out))
    state))
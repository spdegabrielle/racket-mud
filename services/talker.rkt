#lang racket

(require "../engine.rkt")
(provide talker)
(define talker
  (lambda ([chans (list "cq")])
    (define channels (make-hash
                      (map
                       (lambda (channel) (cons channel (list)))
                       chans)))
    (lambda (mud sch make)
      (define add-listener!
        (lambda (name listener)
          (let ([listeners (hash-ref channels name)])
            (hash-set! channels name (append (list listener) listeners))
            ((quality-setter listener)
             'channels (append (list name) ((quality-getter listener) 'channels))))))
      (define remove-listener!
        (lambda (name listener)
          (let ([listeners (hash-ref channels name)])
            (hash-set! channels name (remove listener listeners)))))
      (define broadcast
        (lambda (chan speaker message)
          (map
           (lambda (listener)
             (define add-to-out
               ((string-quality-appender listener) 'client-out))
             (add-to-out (format "(~a) ~a: ~a"
                                 chan
                                 (name speaker)
                                 message)))
           (hash-ref channels chan))))
      (define tune-in
        (lambda (chan listener)
          (define
            tune-in (lambda (chan listener)
                      (unless (member
                               chan
                               ((quality-getter listener) 'channels))
                        (add-listener! chan listener))))
          (cond
            [(list? chan) (for-each (lambda (chan) (tune-in chan listener))
                                    chan)]
            [(string? chan)
             (tune-in chan listener)])))
      (define tune-out
        (lambda (chan listener)
          (define
            tune-out (lambda (chan listener)
            (remove-listener! chan listener)))
          (cond
            [(list? chan) (for-each (lambda (chan) (tune-out chan listener))
                                    chan)]
            [(string? chan)
             (tune-out chan listener)])))
      (let ([hooks (mud-hooks mud)])
        (hash-set! hooks 'broadcast broadcast)
        (hash-set! hooks 'tune-in tune-in)
        (hash-set! hooks 'tune-out tune-out))
      #f)))
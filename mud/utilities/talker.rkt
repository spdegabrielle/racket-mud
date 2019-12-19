#lang racket

(require "../engine.rkt")
(require "../qualities/listener.rkt")
(require "../qualities/user.rkt")
(require "../services/talker.rkt")

(provide tune-listener-into-channel
         tune-listener-into-channels)

(define (tune-listener-into-channel listener channel-name)
  (add-listener-channel! listener channel-name)
  (add-channel-listener! channel-name listener))

(define (tune-listener-into-channels listener channel-names)
  (log-debug "tuning listener into ~a" channel-names)
  (for-each (lambda (channel-name)
              (tune-listener-into-channel listener channel-name))
            channel-names))
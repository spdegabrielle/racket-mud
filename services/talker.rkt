#lang racket

(require "../engine.rkt")
(require "../logger.rkt")
(require "../service.rkt")
(require "../thing.rkt")

(provide talker-service
         tune-channel
         drop-channel
         known-channels
         (struct-out channel))

(struct channel (listeners history))

(define known-channels
  (make-hash (list (cons "wanji" (channel (list) (list)))
                   (cons "nunpa" (channel (list) (list))))))

(define (create-channel channel)
  (void))

;; add listener to talker's listeners
(define (tune-channel channel-name listener)
  (current-logger (make-logger 'Talker-tune-channel
                               mudlogger))
  (log-debug "called; tuning ~a into ~a" listener channel-name)
  ;; add talker channel name to listener's talker-channels quality
  (append-thing-quality
   listener 'talker-channels
   (list channel-name))
  ;; add listener to talker's listeners
  (hash-set!
   known-channels channel-name
   (struct-copy
    channel (hash-ref known-channels channel-name)
    [listeners (append
                (channel-listeners (hash-ref known-channels
                                             channel-name))
                (list listener))])))


(define (drop-channel channel listener)
  (void))


(define talker-service
  (service
   'talker-service
   #f #f #f #f))
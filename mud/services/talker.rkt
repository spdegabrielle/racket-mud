#lang racket

(require "../engine.rkt")
(require "../data-structures/service.rkt")
(require "../data-structures/thing.rkt")

(provide talker-service
         drop-channel
         known-channels
         add-channel-listener!
         (struct-out channel))

(struct channel (listeners history) #:mutable)

(define known-channels
  (make-hash (list (cons "cq" (channel (list) (list))))))

(define (create-channel channel)
  (void))

(define (add-channel-listener! channel-name listener)
  (let ([channel-data (hash-ref known-channels channel-name)])
    (log-debug "working on channel ~a" channel-data)
    (set-channel-listeners! channel-data (append (list listener) (channel-listeners channel-data)))))

(define (drop-channel channel listener)
  (void))


(define talker-service
  (service
   'talker-service
   #f #f #f #f))
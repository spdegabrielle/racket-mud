#lang racket

(require "../engine.rkt")
(require "../data-structures/thing.rkt")
(require "../services/talker.rkt")
(require "../data-structures/event.rkt")

(provide broadcast-event)

(define (broadcast-procedure payload)
  (log-debug "called with payload ~a" payload)
  (let* ([channel-name
          (hash-ref payload 'channel)]
         [channel-data
         (hash-ref known-channels
                   channel-name)]
         [speaker (hash-ref payload 'speaker)]
         [message (hash-ref payload 'message)])
    (log-debug "channel is ~a"
               channel-name)
    (log-debug "channel listeners are ~a"
               (channel-listeners channel-data))
    (map (lambda (listener)
           (schedule
            'send
            (hash 'recipient listener
                  'message (format
                            "(~a) ~a: ~a"
                            channel-name
                            (first-noun speaker)
                            message))))
         (channel-listeners channel-data))))



(define broadcast-event (event 'broadcast broadcast-procedure))
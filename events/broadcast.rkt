#lang racket

(require "../engine.rkt")
(require "../logger.rkt")
(require "../thing.rkt")
(require "../services/talker.rkt")

(provide broadcast-event)

(define (broadcast-event payload)
  (current-logger (make-logger 'Broadcast-event mudlogger))
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
                            (thing-id speaker)
                            message))))
         (channel-listeners channel-data))))
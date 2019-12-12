#lang racket

(require racket/serialize)

(require "../engine.rkt")
(require "../logger.rkt")
(require "../thing.rkt")
(require "../service.rkt")

(require "../qualities/container.rkt")
(require "../qualities/physical.rkt")
(require "../qualities/visual.rkt")

(provide action-service
         known-actions)

(define tick-count 0)

(define known-actions (make-hash))


(define (tick-action)
  (current-logger (make-logger 'Action-service mudlogger))
  (when (= (/ tick-count 50) 0)
    (log-debug "AHHHH ~a" known-actions))
  (when (= (remainder tick-count 10000) 0)
    (let ([bingo (random 1000)]
          [triggered-actions (list)])
      (hash-map
       known-actions
       (lambda (chance record)
         (when (<= (random 1000) chance)
           (set! triggered-actions
                 (append (list record)
                         triggered-actions)))))
      (unless (null? triggered-actions)
        (log-debug "triggered actions are ~a" triggered-actions))
      (for-each
       (lambda (action)
         (let ([actor (first action)]
               [task (last action)])
           (cond
             [(string? task)
            (log-debug "Action is a string, send it to environment. Actor is ~a" (first-noun actor))
            (let ([environment (get-physical-location actor)])
              (log-debug "environment is ~a" (first-noun environment))
              (when (thing? environment)
                (for-each (lambda (thing)
                          (schedule 'send (hash 'recipient thing
                                                'message task)))
                          (things-with-quality (get-container-inventory environment) 'client))))]
              ;(when (thing-has-quality? actor 'physical)
               ; (when (thing? (get-physical-location actor))
                ;  (for-each
                 ;  (lambda (thing)
                  ;   (schedule 'send (hash 'recipient thing
                   ;                        'message task)))
                   ;(get-container-inventory
                    ;(get-physical-location actor)))))]
             [else (log-debug
                    "No handling for non-string action tasks.")])))
       triggered-actions)))
  (set! tick-count (+ tick-count 1)))

(define action-service (service 'action-service
                              #f #f tick-action #f))
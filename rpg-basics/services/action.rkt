#lang racket

(require racket/serialize)

(require "../../mud/engine.rkt")
(require "../../mud/logger.rkt")
(require "../../mud/data-structures/thing.rkt")
(require "../../mud/data-structures/service.rkt")
(require "../../mud/utilities/thing.rkt")

(require "../data-structures/action-record.rkt")
(require "../qualities/container.rkt")
(require "../qualities/physical.rkt")
(require "../qualities/visual.rkt")

(provide action-service
         known-actions)

(define tick-count 0)

(define known-actions (make-hash))


(define (tick-action)
  (when (= tick-count 0)
    (log-debug "known actions are ~a" known-actions))
  (when (= (remainder tick-count 10000) 0)
    (let ([triggered-actions (list)])
      (hash-map
       known-actions
       (lambda (chance records)
         (for-each (lambda (record)
                     
                     (when (<= (random 10000) chance)
                       (set! triggered-actions
                             (append (list record)
                                     triggered-actions))))
                   records)))
      (for-each
       (lambda (action)
         (let ([actor (action-record-actor action)]
               [task (action-record-task action)])
           (cond
             [(string? task)
            (let ([environment (physical-location actor)])
              (when (thing? environment)
                (for-each (lambda (thing)
                          (schedule 'send (hash 'recipient thing
                                                'message task)))
                          (filter-things-with-quality (container-inventory environment) 'client))))]
             [(procedure? task)
              (log-debug "task is a procedure, trying it.")
              (task actor)]
             [else
              (log-debug
                    "No handling for non-string/procedure action tasks: ~a" task)])))
       triggered-actions)))
  (set! tick-count (+ tick-count 1)))

(define action-service (service 'action-service
                              #f #f tick-action #f))

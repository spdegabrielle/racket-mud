#lang racket

(require "../thing.rkt")
(require "../services/action.rkt")

(provide actions
         get-actions
         get-action-recipes
         set-action-records!)

; action = recipe
; action-record = full action w/ associated thing

(define (get-actions thing)
  (get-thing-quality thing 'actions))

(define (get-action-recipes thing)
  (get-thing-quality-attribute thing 'actions 'recipes))

(define (set-action-records! thing records)
  (set-thing-quality-attribute! thing 'actions 'record
                               records))

(define (apply-actions-quality thing)
  (let ([created-actions (list)])
    (for-each (lambda (action-recipe)
                (let ([action-record (list thing (car action-recipe)
                                           (cdr action-recipe))])
                (set! created-actions
                      (append (list action-record) created-actions))
                (hash-set! known-actions (car action-recipe)
                      action-record)))
              (get-action-recipes thing))
    (set-action-records! thing created-actions)))

(define (actions recipes)
  (quality apply-actions-quality
           (make-hash
            (list (cons 'recipes recipes)))))

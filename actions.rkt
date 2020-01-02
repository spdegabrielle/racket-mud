#lang racket
(require "./engine.rkt")
(provide actions)
(define (actions)
  (define actions (make-hash))
  (define (load state)
    (let ([schedule (car state)]
          [mud (cdr state)])
      (hash-set! (mud-hooks mud)
               'apply-actions-quality
               (λ (thing)
                 (let ([created-actions (list)])
                   (for-each
                    (λ (action)
                      (let ([record
                             (list thing (car action) (cdr action))])
                        (set! created-actions
                              (append (list record) created-actions))
                        (let ([chance (car action)])
                          (hash-set!
                           actions chance
                           (cond [(hash-has-key? actions chance)
                                  (append (list record)
                                          (hash-ref actions chance))]
                                 [else (list record)])))))
                    ((quality-getter thing) 'actions))
                   ((quality-setter thing)
                    'actions created-actions))))
      (schedule tick)
      state))
  (define (tick state)
    (let ([triggered (list)]
          [schedule (car state)]
          [mud (cdr state)])
      (hash-map actions
                (λ (chance records)
                  (for-each (λ (record)
                              (when (<= (random 10000) chance)
                                (set! triggered
                                      (append (list record)
                                              triggered))))
                            records)))
         (for-each
           (λ (action)
             (let* ([actor (first action)]
                    [task (third action)]
                    [actor-quality (quality-getter actor)]
                    [actor-location (actor-quality 'location)]
                    [actor-exits (actor-quality 'exits)])
               (cond
                 [(string? task)
                  ;send to things in th environment
                  (let* ([environment (cond [actor-location actor-location]
                                            [actor-exits actor])])
                    (when (procedure? environment)
                      (let ([environment-contents
                             ((quality-getter environment) 'contents)])
                        (for-each
                         (λ (thing)
                           (((string-quality-appender thing) 'client-out)
                           task))
                         (things-with-quality environment-contents 'client-out)))))
                  ])))
           triggered)
      (schedule tick)
      state))
  load)
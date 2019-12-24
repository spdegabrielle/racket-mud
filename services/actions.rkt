#lang racket
(require "../engine.rkt")
(provide actions)
(define actions
  (lambda ()
    (define actions (make-hash))
    (lambda (mud sch make)
      (hash-set! (mud-hooks mud)
                'apply-actions-quality
                (lambda (thing)
                  (let ([created-actions (list)])
                    (for-each
                     (lambda (action)
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
      (lambda ()
        (let ([triggered (list)])
          (hash-map actions
                    (lambda (chance records)
                      (for-each (lambda (record)
                                 (when (<= (random 10000) chance)
                                   (set! triggered
                                         (append (list record)
                                                 triggered))))
                               records)))
          (for-each
           (lambda (action)
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
                         (lambda (thing)
                           (((string-quality-appender thing) 'client-out)
                           task))
                         (things-with-quality environment-contents 'client-out)))))
                  ])))
           triggered))))))

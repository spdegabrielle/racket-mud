#lang racket

(require "../../mud/data-structures/thing.rkt")
(require "../qualities/container.rkt")
(require "../qualities/physical.rkt")

(provide search-physical-environment)

(define (search-physical-environment thing name)
  (let* ([thing-inventory (cond [(thing-has-quality? thing 'container)
                                 (container-inventory thing)]
                                [else (list)])]
         [thing-location (cond [(thing-has-quality? thing 'physical)
                                (physical-location thing)]
                               [else (void)])]
         [location-inventory
          (cond
            [(and (thing? thing-location) (thing-has-quality? 'container))
             (container-inventory (physical-location thing))]
            [else (list)])]
         [all-nearby-things (append thing-inventory location-inventory)]
         [matching-things
          (filter values
                  (map (lambda (thing)
                         (cond
                           [(term-matches-thing? name thing) thing]
                           [else #f])) all-nearby-things))])
    matching-things))

#lang racket

(require "../thing.rkt")
(require "./container.rkt")

(provide physical
         get-physical-location
         set-physical-location!
         search-physical-environment
         move-thing-into-container-inventory
         remove-thing-from-container-inventory)

(define (apply-physical-quality thing)
  thing)

(define (physical location)
  (quality apply-physical-quality
           (make-hash
            (list (cons 'location location)))))

(define (get-physical-location thing)
  (get-thing-quality-attribute thing 'physical 'location))

(define (set-physical-location! thing location)
  (set-quality-attribute! (get-thing-quality thing 'physical) 'location
                          location))

(define (move-thing-into-container-inventory thing container)
  (log-debug "moving ~a into ~a" (first-noun thing) (first-noun container))
  (let ([current-location (get-physical-location thing)])
    (when (thing? current-location)
      (log-debug "~a is already in a container, ~a" (first-noun thing) (first-noun current-location))
      (remove-thing-from-container-inventory! thing current-location))
    (add-thing-to-container-inventory thing container)
    (set-physical-location! thing container)))

(define (remove-thing-from-container-inventory! thing container)
  (set-container-inventory!
   container
   (remove thing (get-container-inventory container))))

(define (search-physical-environment thing name)
  (log-debug "searching the environment of thing #~a (~a)" (thing-id thing) (first (thing-nouns thing)))
  (log-debug "it has an inventory of ~a" (get-container-inventory thing))
  (let* ([thing-inventory (cond [(thing-has-quality? thing 'container)
                                 (get-container-inventory thing)]
                                [else (list)])]
         [thing-location (cond [(thing-has-quality? thing 'physical)
                                (get-physical-location thing)]
                               [else (void)])]
         [location-inventory
          (cond
            [(and (thing? thing-location) (thing-has-quality? 'container))
             (get-container-inventory (get-physical-location thing))]
            [else (list)])]
         [all-nearby-things (append thing-inventory location-inventory)]
         [matching-things
          (filter values
                  (map (lambda (thing)
                         (log-debug "all nearby things are ~a" (map (lambda (thing) (first-noun thing)) all-nearby-things))
                         (cond
                           [(term-matches-thing? name thing) thing]
                           [else #f])) all-nearby-things))])
    matching-things))

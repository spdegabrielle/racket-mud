#lang racket

(require "../../mud/engine.rkt")
(require "../../mud/data-structures/command.rkt")
(require "../../mud/data-structures/thing.rkt")

(require "../../mud/utilities/string.rkt")
(require "../../mud/utilities/thing.rkt")

(require "../qualities/container.rkt")
(require "../qualities/physical.rkt")
(require "../qualities/area.rkt")
(require "../qualities/visual.rkt")
(require "../utilities/physical.rkt")

(provide look-command)


(define help-brief
   "The command for looking at something.")

(define help-syntax
  (list
   "look [--container=backpack] [apple]"
   "Look at the [apple] in the [backpack] container."))

(define help-long
  "Blah blah priority of targets.")

(define (look-procedure client [kwargs #f] [args #f])
  (let ([target #f] [container #f] [response #f])
    (when (hash? kwargs)
      (when (hash-has-key? kwargs "container")
        (set! container (car (hash-ref kwargs "container")))))
    (when (string? args)
       (set! target args))
    (cond
      [(string? container)
       (let ([potential-containers
              (search-physical-environment client container)])
         (cond
           [(> (length potential-containers) 0)
            (cond
              [(= (length potential-containers) 1)
               (set! container (first potential-containers))]
              [else
               (set! response "Found multiple matching containers.")])]
           [else
            (set! response "Didn't find any matching containers.")]))]
      [else
       (set! container (physical-location client))])
    (cond
      [(thing? container)
       (cond
         [(string? target)
          (let ([potential-targets
                 (search-physical-environment container target)])
            (cond
              [(> (length potential-targets) 0)
               (cond
                 [(= (length potential-targets) 1)
                  (set! target (first potential-targets))]
                 [else
                  (set! response "Found multiple matching targets.")])]
              [else
               (set! response "Didn't find any matching targets.")]))]
         [else
          (set! target container)])]
      [else
       (set! response "Invalid container.")])
    (cond
      [(thing? target)
       (cond
         [(thing-has-quality? target 'area)
          (set! response (render-area-look target))]
         [(thing-has-quality? target 'visual)
          (set! response (render-visual-look target))]
         [else
          (set! response "Valid target, but you can't look at it.")])]
      [else
       (set! response "Invalid target.")])
    (unless response
      (set! response "You can't see anything. Don't worry, it's probably temporary."))
    (schedule 'send
              (hash 'recipient client
                    'message response))))

(define (render-visual-look target)
  (cond [(string? (visual-description target))
         (visual-description target)]
        [else (visual-brief target)]))

(define (render-area-look target)
  (format "~a\n~a~a\n~a"
          (visual-brief target)
          (visual-description target)
          (cond
            [(area-has-exits? target)
             (format "\nExits: ~a"
                     (oxfordize-list (hash-keys (area-exits target))))]
            [else ""])
          (format "Contents: ~a"
                  (oxfordize-list
                   (filter
                    values
                    (map (lambda (item)
                           (cond
                             [(> (physical-mass item) 0) (cond [(thing-has-quality? item 'visual) (visual-brief item)]
                                                               [else (first-noun item)])]
                             [else #f]))
                         (filter-things-with-quality
                          (container-inventory target)
                          'physical)))))))

(define look-command
  (command
   look-procedure
   (hash 'brief help-brief
         'syntax help-syntax
         'long help-long)))

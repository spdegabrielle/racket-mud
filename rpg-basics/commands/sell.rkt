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

(provide sell-command)


(define help-brief
   "The command for selling at something.")

(define help-syntax
  (list
   "sell [--vendor=sam] [apples]"
   "sell the [apple] to the vendor named Sam."))

(define help-long
  "Blah blah priority of targets.")

(define (sell-procedure client [kwargs #f] [args #f])
  (let ([target #f] [vendor #f] [response #f])
    (when (hash? kwargs)
      (when (hash-has-key? kwargs "vendor")
        (set! vendor (car (hash-ref kwargs "vendor")))))
    (when (string? args)
       (set! target args))
    (cond
      [(string? vendor)
       (let ([potential-vendors
              (search-physical-environment client vendor)])
         (cond
           [(> (length potential-vendors) 0)
            (cond
              [(= (length potential-vendors) 1)
               (set! vendor (first potential-vendors))]
              [else
               (set! response "Found multiple matching vendors.")])]
           [else
            (set! response "Didn't find any matching vendors.")]))]
      [else
       (set! response "No vendor specified.")])
    (cond
      [(thing? vendor)
       (cond
         [(string? target)
          (let ([potential-targets (search-physical-environment client target)])
            (cond
              [(> (length potential-targets) 0)
               (cond
                 [(= (length potential-targets) 1)
                  (set! target (first potential-targets))]
                 [else
                  (set! response "Found multiple matching targets.")])]
              [else
               (set! response "Didn't find any matching targets.")]))])]
      [else
       (set! response "Invalid vendor.")])
    (cond
      [(thing? target)
       (set! response (format "You attempt to sell ~a to ~a" (first-noun target) (first-noun vendor)))
       (schedule 'sell (hash 'seller client
                             'vendor vendor
                             'target target))]
      [else
       (set! response "Invalid target.")])
    (unless response
      (set! response "You failed to sell for some reason."))
    (schedule 'send
              (hash 'recipient client
                    'message response))))

(define (render-visual-sell target)
  (cond [(string? (visual-description target))
         (visual-description target)]
        [else (visual-brief target)]))

(define (render-area-sell target)
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

(define sell-command
  (command
   sell-procedure
   (hash 'brief help-brief
         'syntax help-syntax
         'long help-long)))

#lang racket

(require "../../mud/engine.rkt")
(require "../../mud/data-structures/command.rkt")
(require "../../mud/utilities/string.rkt")
(require "../../mud/utilities/thing.rkt")

(require "../qualities/container.rkt")
(require "../qualities/physical.rkt")
(require "../qualities/visual.rkt")

(provide inventory-command)


(define help-brief
   "Request information on a container's inventory.")

(define help-syntax
  (list
   "inventory [thing]"
   help-brief))

(define help-long
  "Returns a list of the container's inventory.")

(define (inventory-procedure client [kwargs #f] [args #f])
  (let* ([target client]
         [inventory (filter-things-with-quality (container-inventory target) 'physical)])
    (schedule 'send
              (hash 'recipient client
                    'message (format (cond [(null? inventory) "That doesn't contain anything."]
                                           [else "Contents: ~a"
                                                 (oxfordize-list (map (lambda (item) (visual-brief item)) inventory))]))))))

(define inventory-command
  (command
   inventory-procedure
   (hash 'brief help-brief
         'syntax help-syntax
         'long help-long)))

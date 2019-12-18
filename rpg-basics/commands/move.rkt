#lang racket

(require "../../mud/engine.rkt")
(require "../../mud/data-structures/command.rkt")
(require "../../mud/data-structures/thing.rkt")

(require "../qualities/physical.rkt")
(require "../qualities/area.rkt")
(require "../qualities/visual.rkt")
(require "../utilities/physical.rkt")

(provide move-command)

(define help-brief
   "Moves something from one container to another.")

(define help-syntax
  (list
   "move [--object=$apple] [destination]"
   "Moves a thing from one container to another."))

(define help-long
  "This command is used to move a thing - including yourself - from \
one container to another.")

(define (move-procedure client [kwargs #f] [args #f])
  ; look for object
  ; look for destination
  ; validate object can move into destination
  ; remove object from its current location
  ; add object to destination
  (let ([target #f] [destination #f] [response #f])
    (cond
      [(hash-has-key? kwargs "object")
        (set! target
              (search-physical-environment
               (hash-ref kwargs "object")))]
      [else
       (log-debug "No specified object, assuming it's the mover.")
       (set! target client)
       (let ([target-area-exits
              (area-exits (physical-location target))]
             [wanted-exit args])
         (cond
           [(hash-has-key? target-area-exits wanted-exit)
            (set! destination (hash-ref target-area-exits wanted-exit))]
           [else
            (set! response
                  (format "Invalid exit ~a" wanted-exit))]))])
    (cond
      [(and (thing? target) (thing? destination))
       (schedule 'move (hash 'mover target 'destination destination))
       (schedule 'send (hash 'recipient client
                             'message (format "~a moves ~a"
                                              (first-noun target)
                                              (cond [(thing-has-quality? destination 'visual)
                                                     (visual-brief destination)]
                                                    [else (first-noun destination)]))))]
      [else
       (schedule 'send
                 (hash 'recipient client
                       'message
                       (format
                        "Move failed for some reason: ~a"
                        (when (string? response) response))))])))

(define move-command
  (command
   move-procedure
   (hash 'brief help-brief
         'syntax help-syntax
         'long help-long)))     
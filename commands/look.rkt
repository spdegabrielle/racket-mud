#lang racket

(require "../command.rkt")
(require "../logger.rkt")
(require "../engine.rkt")
(require "../thing.rkt")

(require "../utilities/string.rkt")

(require "../qualities/container.rkt")
(require "../qualities/physical.rkt")
(require "../qualities/room.rkt")
(require "../qualities/visual.rkt")

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
  (current-logger (make-logger 'Look-command mudlogger))
  (log-debug "kwargs are ~a and args are ~a" kwargs args)
  (let ([target #f] [container #f] [response #f])
    (when (hash? kwargs)
      (when (hash-has-key? kwargs "container")
        (set! container (car (hash-ref kwargs "container")))))
    (when (string? args)
       (set! target args))
    (log-debug "container is ~a and target is ~a" container target)
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
       (log-debug "assuming client means to look in the container they're in, ~a" (get-physical-location client))
       (set! container (get-physical-location client))])
    (log-debug "container is ~a and target is ~a" container target)
    (cond
      [(thing? container)
       (log-debug "container is ~a" (first-noun container))
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
    (log-debug "container is ~a and target is ~a" container target)
    (cond
      [(thing? target)
       (cond
         [(thing-has-quality? target 'room)
          (set! response (render-room-look target))]
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
  (cond [(string? (get-visual-description target))
         (get-visual-description target)]
        [else (get-visual-brief target)]))

(define (render-room-look target)
  (format "~a\n~a~a\n~a"
          (get-visual-brief target)
          (get-visual-description target)
          (cond
            [(room-has-exits? target)
             (format "\nExits: ~a"
                     (oxfordize-list (hash-keys (get-room-exits target))))]
            [else ""])
          (format "Contents: ~a"
                     (oxfordize-list
                      (map (lambda (item) (first (thing-nouns item)))
                      (get-container-inventory-with-quality
                       target 'client))))))

(define look-command
  (command
   look-procedure
   (hash 'brief help-brief
         'syntax help-syntax
         'long help-long)))
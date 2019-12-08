#lang racket

(require "../command.rkt")
(require "../logger.rkt")
(require "../engine.rkt")
(require "../thing.rkt")

(require "../utilities/string.rkt")

(require "../qualities/container.rkt")
(require "../qualities/physical.rkt")
(require "../qualities/room.rkt")

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
    (cond
      [(hash? kwargs)
       (when (hash-has-key? kwargs "container")
         (set! container (car (hash-ref kwargs "domain"))))]
      [(list? args)
       (set! target (car args))]
      [(and (false? kwargs) (false? args))
       (set! target (get-physical-location client))])
    (log-debug "Container is ~a and target is ~a"
               container target)
    (when (thing? target)
      (cond [(thing-has-qualities? target physical?)
             (set! response (render-physical-look target))]
            [(thing-has-qualities? target room?)
             (set! response (render-room-look target))]))
    (when (false? response)
      (set! response "You can't see anything. Don't worry, it's \
probably temporary."))
    (schedule 'send (hash 'recipient client 'message response))))

(define (render-physical-look target)
  (get-physical-description target))

(define (render-room-look target)
  (format "~a\n~a~a\n~a"
          (get-room-name target)
          (get-room-description target)
          (cond
            [(room-has-exits? target)
             (format "\nExits: ~a"
                     (oxfordize-list (hash-keys (get-room-exits target))))]
            [else ""])
          (format "Contents: ~a"
                     (oxfordize-list
                      (map (lambda (thing) (get-physical-proper-name thing))
                          (get-container-inventory target))))))

(define look-command
  (command
   look-procedure
   (hash 'brief help-brief
         'syntax help-syntax
         'long help-long)))
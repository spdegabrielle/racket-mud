#lang racket

(require "../command.rkt")
(require "../engine.rkt")
(require "../logger.rkt")

(require "../services/room.rkt")
(require "../services/user.rkt")
(require "../qualities/physical.rkt")
(require "../qualities/room.rkt")

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
  (current-logger (make-logger 'Move-command mudlogger))
  (let ([target #f] [destination #f] [response #f])
    (cond
      [(hash-has-key? kwargs "object")
        (set! target
              (search-physical-environment
               (hash-ref kwargs "object")))]
      [else
       (log-debug "No specified object, assuming it's the mover.")
       (set! target client)
       (let ([target-room-exits
              (get-room-exits (get-physical-location target))]
             [wanted-exit (car args)])
         (cond
           [(hash-has-key? target-room-exits wanted-exit)
            (set! destination
                  (get-room (hash-ref target-room-exits wanted-exit)))]
           [else
            (set! response
                  (format "Invalid exit ~a" wanted-exit))]))])
    (cond
      [(and target destination)
       (schedule 'move (hash 'mover target 'destination destination))]
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
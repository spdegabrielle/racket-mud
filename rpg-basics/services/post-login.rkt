#lang racket

(require "../../mud/engine.rkt")
(require "../../mud/data-structures/service.rkt")
(require "../../mud/data-structures/thing.rkt")
(require "../../mud/services/mudsocket.rkt")
(require "../../mud/qualities/client.rkt")
(require "../../mud/qualities/mudsocket-client.rkt")
(require "../../mud/qualities/user.rkt")
(require "../../mud/utilities/thing.rkt")

(require "../commands/look.rkt")
(require "../commands/move.rkt")
(require "../commands/say.rkt")
(require "../commands/whereami.rkt")
(require "../qualities/container.rkt")
(require "../qualities/physical.rkt")
(require "../qualities/visual.rkt")

(provide post-login-service
         set-spawn-area!)

(define spawn-area (void))
(define (set-spawn-area! area)
  (set! spawn-area area))

(define (tick-post-login-service)
  (hash-map socket-connections
            (lambda (id thing)
              (when (= (mudsocket-client-login-stage thing) 9)
                (give-thing-new-qualities
                 thing
                 (hash 'container (container (list))
                       'physical (physical (void) 1)
                       'visual (visual (user-name thing) "This is a living person.")))
                (schedule 'move
                          (hash 'mover thing
                                'destination spawn-area))
                (add-client-commands!
                 thing (hash
                        "look" look-command
                        "move" move-command
                        "say" say-command
                        "whereami" whereami-command))
                (set-mudsocket-client-login-stage! thing 10)))))

(define post-login-service
  (service
   'post-login-service
   #f #f tick-post-login-service #f))

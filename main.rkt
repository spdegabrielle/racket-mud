#lang racket


(require "./mud/engine.rkt")
(require "./mud/logger.rkt")
(require "./mud/data-structures/mud-library.rkt")
(require "./mud/data-structures/mud-server.rkt")
(require "./mud/events/parse.rkt")
(require "./mud/events/send.rkt")
(require "./mud/services/mudsocket.rkt")
(require "./mud/services/user.rkt")


(require "./rpg-basics/events/move.rkt")
(require "./rpg-basics/services/action.rkt")
(require "./rpg-basics/services/post-login.rkt")
(require "./rpg-basics/services/map.rkt")

(require "./teraum/services/map.rkt")
(require "./teraum/services/post-login.rkt")

(define core-library
  (mud-library
   "Core"
   (list send-event
         parse-event)
   (list mudsocket-service
         ; talker-service
         user-service)))

(define rpg-basics-library
  (mud-library
   "RPG Basics"
   (list
    move-event)
   (list
    action-service
    post-login-service
    map-service)))

(define teraum-library
  (mud-library
   "Teraum"
   (list)
   (list teraum-map-service
         teraum-post-login-service)))



(define racket-mud-dev-server
  (mud-server "Racket-MUD Development Server"
              "0.1.0"
              (list core-library
                    rpg-basics-library
                    teraum-library
                    )))

(void
 (current-logger mudlogger)
 (thread
  (λ()(let loop ()
        (define v (sync mudlog-receiver))
        (printf "[~a] ~a\n" (vector-ref v 0) (vector-ref v 1))
        (loop)))))

(when (load-mud racket-mud-dev-server)
  (when (start-mud)
    (run-mud)))

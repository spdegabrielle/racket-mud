#lang racket

(require "../service.rkt")

(provide
 mudsocket-service)

(define socket-listener (void))
(define socket-port 4242)
(define socket-connections (list))

(define (load-mudsocket)
  #t)

(define (start-mudsocket)
  (set! socket-listener (tcp-listen 4242 5 #t))
  #t)

(define (tick-mudsocket)
  ; when there's a new connection:
  ; -> create a new thing
  ; -> give it a mudsocket-connection quality, its value a pair of in/out from tcp-accept
  (when (tcp-accept-ready? socket-listener)
    (define-values (in out) (tcp-accept socket-listener))
    (define-values (lip lport rip rport) (tcp-addresses in #t))
    (flush-output out)))

(define (stop-mudsocket)
  (tcp-close socket-listener)
  #t)


(define mudsocket-service
  (service "mudsocket"
           load-mudsocket
           start-mudsocket
           tick-mudsocket
           stop-mudsocket))

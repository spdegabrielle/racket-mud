#lang racket

(require "../service.rkt")

(provide
 mudsocket-service)

(define (load-mudsocket)
  #t)

(define (start-mudsocket)
  #t)

(define (tick-mudsocket)
  #t)

(define (stop-mudsocket)
  #t)


(define mudsocket-service
  (service "mudsocket"
           load-mudsocket
           start-mudsocket
           tick-mudsocket
           stop-mudsocket))

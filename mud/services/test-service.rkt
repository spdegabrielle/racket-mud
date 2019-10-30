#lang racket

(require "../service.rkt")

(provide
 test-service)


(define (load-test-service) #t)
(define (start-test-service) #t)
(define (tick-test-service) #t)
(define (stop-test-service) #t)

(define test-service
  (service "test-service"
           load-test-service
           start-test-service
           tick-test-service
           stop-test-service))

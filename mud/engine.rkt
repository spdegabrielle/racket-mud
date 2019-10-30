#lang racket

(require "service.rkt")

(require "./services/mudsocket.rkt")
(require "./services/test-service.rkt")

(provide
  services-to-load
  tickable-services
  load
  start
  run
  tick
  load-services
  start-services
  tick-services)

(define tickable-services (make-hash))

(define services-to-load (list
                          test-service
                          mudsocket-service))

(define (load)
  (load-services services-to-load))

(define (load-services services)
   (map (lambda (service)
     (let ([load-proc (service-load-proc service)])
       (if (procedure? load-proc)
         (load-proc)
         #f)))
     services))

(define (start-services services)
  (map (lambda (service)
    (let ([start-proc (service-start-proc service)])
      (if (procedure? start-proc)
        (start-proc)
	#f)))
    services))

(define (tick-services services)
  (map (lambda (service)
    (let ([tick-proc (service-tick-proc service)])
      (if (procedure? tick-proc)
        (tick-proc)
        #f)))
    services))


(define (start)
  (start-services services-to-load))

(define (stop)
  (map (lambda (service)
         (let ([stop-proc (service-stop-proc service)])
           (when (procedure? stop-proc)
             (stop-proc))))
       services-to-load))

(define (run)
  (map (lambda (service)
    (let ([tick-proc (service-tick-proc service)])
      (when (procedure? tick-proc)
        (hash-set! tickable-services (service-id service) tick-proc))))
    services-to-load)
  (tick))

(define (tick)
  (map (lambda (tick-proc) (tick-proc)) (hash-values tickable-services))
  (tick))

#lang racket

(struct service/0.1.0 (id load-proc start-proc tick-proc stop-proc))

(define (load-test-service/0.1.0) #t)
(define (start-test-service/0.1.0) #t)
(define (tick-test-service/0.1.0) #t)
(define (stop-test-service/0.1.0) #t)

(define services-to-load/0.1.0 (list
  (service/0.1.0 "test-service"
    load-test-service/0.1.0
    start-test-service/0.1.0
    tick-test-service/0.1.0
    stop-test-service/0.1.0)))

(define (load-services/0.1.0 services)
  (map (lambda (service)
    ((service/0.1.0-load-proc service))) services))

(define (load/0.1.0)
  (load-services/0.1.0 services-to-load/0.1.0))

(define services-to-load/0.1.1 (list
  (service/0.1.0 "test-service"
  #f
  #f
  tick-test-service/0.1.0
  #f)))

(define (load-services/0.1.1 services)
   (map (lambda (service)
     (let ([load-proc (service/0.1.0-load-proc service)])
       (if (procedure? load-proc)
         (load-proc)
         #f)))
     services))

(define (start-services/0.1.0 services)
  (map (lambda (service)
    (let ([start-proc (service/0.1.0-start-proc service)])
      (if (procedure? start-proc)
        (start-proc)
	#f)))
    services))

(define (tick-services/0.1.0 services)
  (map (lambda (service)
    (let ([tick-proc (service/0.1.0-tick-proc service)])
      (if (procedure? tick-proc)
        (tick-proc)
        #f)))
    services))


(define (start/0.1.0)
  (start-services/0.1.0 services-to-load/0.1.0))

(define tickable-services/0.1.0 (make-hash))

(define (run/0.1.0)
  (map (lambda (service)
    (let ([tick-proc (service/0.1.0-tick-proc service)])
      (when (procedure? tick-proc)
        (hash-set! tickable-services/0.1.0 (service/0.1.0-id service) tick-proc))))
    services-to-load/0.1.0)
  (tick/0.1.0))

(define (tick/0.1.0)
  (map (lambda (tick-proc) (tick-proc)) (hash-values tickable-services/0.1.0))
  (tick/0.1.0))

(provide
  service/0.1.0
  load-test-service/0.1.0
  start-test-service/0.1.0
  tick-test-service/0.1.0
  stop-test-service/0.1.0
  services-to-load/0.1.0
  load/0.1.0
  services-to-load/0.1.1
  load-services/0.1.1
  start-services/0.1.0
  tick-services/0.1.0
  start/0.1.0
  tickable-services/0.1.0
  run/0.1.0
  tick/0.1.0)

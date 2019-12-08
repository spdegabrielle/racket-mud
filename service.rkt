#lang racket
(provide (struct-out service)
         service-ids)
;; Data Structures
;;;;;;; Service structure
(struct service (id load-proc start-proc tick-proc stop-proc))

(define (service-ids services)
  (map (lambda (service)
         (service-id service))
       services))
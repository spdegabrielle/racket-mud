#lang racket
(provide test-event)
(define (test-event payload)
  (printf (format "Triggered test event, ~a~n" payload)))
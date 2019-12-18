#lang racket
(provide mudlogger
         mudlog-receiver)

(define mudlogger (make-logger 'Racket-MUD))
(define mudlog-receiver (make-log-receiver mudlogger 'debug))
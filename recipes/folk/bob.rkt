#lang racket

(require "../../qualities/physical.rkt")
(provide bob)

(define bob
   (list
    (physical
     "Bob"
     (list "human")
     "This is masculine human."
     (void))))
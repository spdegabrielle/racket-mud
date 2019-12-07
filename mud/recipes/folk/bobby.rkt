#lang racket


(define bobby
  ((lambda ()
     (let ([bobby (create-thing (thing-qualities bob))])
       (set-user-name bobby "bobby")
       bobby))))
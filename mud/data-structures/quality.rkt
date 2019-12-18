#lang racket

(provide (struct-out quality))


(struct quality (procedure structure) #:mutable)
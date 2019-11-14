#lang racket

(require libuuid)


(provide
 (struct-out thing)
 extant-things
 create-thing
 destroy-thing
 set-thing-quality
 set-thing-qualities
 get-thing-quality
 generate-thing-id)

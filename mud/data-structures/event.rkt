#lang racket
(provide (struct-out event))

(struct event (id procedure))
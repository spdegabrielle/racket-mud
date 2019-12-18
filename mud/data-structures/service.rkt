#lang racket
(provide (struct-out service))

(struct service (id load-proc start-proc tick-proc stop-proc))

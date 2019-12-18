#lang racket

(provide (struct-out action-record))
(struct action-record (actor chance task))
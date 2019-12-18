#lang racket

(provide (struct-out mud-library))

(struct mud-library (id events services))
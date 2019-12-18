#lang racket

(provide (struct-out mud-server))

(struct mud-server (id version libraries))
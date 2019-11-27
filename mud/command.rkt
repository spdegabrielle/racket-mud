#lang racket
(provide (struct-out command))
(struct command (procedure help-strings))
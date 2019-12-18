#lang racket

(provide (struct-out recipe))

(struct recipe (nouns adjectives qualities) #:mutable)
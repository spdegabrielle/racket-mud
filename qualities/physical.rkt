#lang racket

(require "../thing.rkt")
(require "./container.rkt")

(provide (struct-out physical)
         get-physical-proper-name
         set-physical-proper-name
         get-physical-common-names
         get-physical-description
         get-physical-location
         set-physical-location
         search-physical-environment)
(struct physical (proper-name common-names description location) #:mutable)

(define (search-physical-environment thing name)
  (let* ([thing-inventory (get-container-inventory thing)]
         [location-inventory
          (get-container-inventory (get-physical-location thing))]
         [all-nearby-things (append thing-inventory location-inventory)]
         [name-noun (last (string-split name))]
         [name-adjectives
          (reverse (cdr (reverse (string-split name))))]
         [things-with-matching-nouns
          (map (lambda (thing)
                 (when (member name-noun (thing-nouns thing))
                   thing))
               all-nearby-things)]
         [things-with-matching-adjectives
          (map (lambda (thing)
                 (when (andmap
                        (lambda (adjective)
                          (unless (member
                                 adjective (thing-adjectives thing))
                            #f))
                        name-adjectives)
                   thing))
               things-with-matching-nouns)])
    things-with-matching-adjectives))

(define (get-physical-proper-name thing)
  (get-thing-quality thing physical? physical-proper-name))
(define (set-physical-proper-name thing new-name)
  (set-thing-quality thing physical? set-physical-proper-name! new-name))
(define (get-physical-common-names thing)
  (get-thing-quality thing physical? physical-common-names))
(define (get-physical-description thing)
  (get-thing-quality thing physical? physical-description))
(define (get-physical-location thing)
  (get-thing-quality thing physical? physical-location))
(define (set-physical-location thing location)
  (set-thing-quality thing physical? set-physical-location! location))

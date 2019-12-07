#lang racket

(require "../thing.rkt")

(provide (struct-out physical)
         get-physical-proper-name
         get-physical-common-names
         get-physical-description
         get-physical-location
         set-physical-location)
(struct physical (proper-name common-names description location) #:mutable)

(define (get-physical-proper-name thing)
  (get-thing-quality thing physical? physical-proper-name))
(define (get-physical-common-names thing)
  (get-thing-quality thing physical? physical-common-names))
(define (get-physical-description thing)
  (get-thing-quality thing physical? physical-description))
(define (get-physical-location thing)
  (get-thing-quality thing physical? physical-location))
(define (set-physical-location thing location)
  (set-thing-quality thing physical? set-physical-location! location))

#lang racket

(require "../../../qualities/container.rkt")
(require "../../../qualities/physical.rkt")
(require "../../../qualities/visual.rkt")

(provide teraum-goat)
(define teraum-goat
  (list (void) (list "goat")
        (list 
   (visual
    "goat"
    "This is a goat.")
   (physical (void))
   (container (list)))))

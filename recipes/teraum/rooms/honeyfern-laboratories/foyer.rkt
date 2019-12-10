#lang racket

(require "../../../../qualities/container.rkt")
(require "../../../../qualities/room.rkt")
(require "../../../../qualities/visual.rkt")

(provide teraum-honeyfern-laboratories-foyer)
(define teraum-honeyfern-laboratories-foyer
  (list (list "honeyfern laboratories") (list "foyer")
        (list
   (room
    'teraum-honeyfern-laboratories-foyer
    (make-hash
     (list (cons "outside" 'arathel-county)
      )))
   (visual
    "foyer of Honeyfern Laboratories"
    "This is the entrance room of Honeyfern Laboratories.")
   (container (list)))))

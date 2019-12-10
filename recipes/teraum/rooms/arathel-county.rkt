#lang racket

(require "../../../qualities/container.rkt")
(require "../../../qualities/room.rkt")
(require "../../../qualities/visual.rkt")

(provide teraum-arathel-county)
(define teraum-arathel-county
  (list (void) (list "Arathel County")
        (list
   (room
    'teraum-arathel-county
    (make-hash
     (list (cons "honeyfern-laboratories" 'teraum-honeyfern-laboratories)
           (cons "south" 'teraum-bellybrush)
      )))
   (visual
    "foyer of Honeyfern Laboratories"
    "This is the entrance room of Honeyfern Laboratories.")
   (container (list)))))
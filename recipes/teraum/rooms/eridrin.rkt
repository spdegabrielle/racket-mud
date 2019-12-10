#lang racket

(require "../../../qualities/container.rkt")
(require "../../../qualities/room.rkt")
(require "../../../qualities/visual.rkt")

(provide teraum-eridrin)
(define teraum-eridrin
  (list (void) (list "eridrin")
        (list 
   (room
    'teraum-eridrin
    (make-hash
     (list (cons "northwest" 'teraum-bellybrush)
           (cons "southeast" 'teraum-marby-county))))
   (visual
    "Eridrin"
    "This is the town of Eridrin. It consists of about a dozen wattle cottages erected near the gravel banks of the Marlbreen River, grey with silt. A well-worn road reveals sandy loam under thin topsoil. The road leads northwest to the large town of Bellybrush, and southeast through Marby County.")
   (container (list)))))

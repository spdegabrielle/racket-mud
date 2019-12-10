#lang racket

(require "../../../qualities/container.rkt")
(require "../../../qualities/room.rkt")
(require "../../../qualities/visual.rkt")

(provide teraum-marby-county)
(define teraum-marby-county
  (list (list "marby") (list "county")
        (list 
   (room
    'teraum-marby-county
    (make-hash
     (list (cons "north" 'teraum-bellybrush)
           (cons "east" 'teraum-sherwyn-county)
           (cons "west" 'teraum-marby-county-coast)
           (cons "eridrin" 'teraum-eridrin))))
   (visual
    "Marby County"
    "This is Marby County. Rolling grassy hills crest and break to reveal sandy loam. To the west, there is the Optic Ocean. Sherwyn County is to the east. To the north, Ack and Bellybrush. And to the south, the imposing Widewoods.\n\n\
Marby County itself has several small communities, including the county seat, the town of Marby. There's also Eridrin, Sharrin, Alindest, Arlonest, Nulbuk, and Dorth.")
   (container (list)))))

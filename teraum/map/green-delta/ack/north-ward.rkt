#lang racket

(require "../../../recipes/areas/green-delta/ack/district.rkt")

(provide north-ward)

(define north-ward
  (district
   'teraum/green-delta/ack/north-ward
   #:brief "North Ward"
   #:description "This is the North Ward, where Ack's first gentry moved to get away from the working class. To the north is the road to Arathel County. To the northeast is the Astar Ward. To the east is the Red Ward. To the south is the Dock Ward. To the northwest is the Wineglass."
   #:exits '(("north" . teraum/green-delta/arathel-county/south-arathel-ack-road)
             ("northeast" . teraum/green-delta/ack/astar-ward)
             ("east" . teraum/green-delta/ack/red-ward)
             ("south" . teraum/green-delta/ack/dock-ward)
             ("northwest" . teraum/green-delta/ack/wineglass))))
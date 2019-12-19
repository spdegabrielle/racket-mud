#lang racket

(require "../../../recipes/areas/gloaming/belcaer/room.rkt")

(provide offices)

(define offices
  (room
   'teraum/gloaming/belcaer/offices
   #:brief "Belcaer Offices"
   #:description "This is the foyer which leads to the offices of various companies in Belcaer."
   #:exits '(("out" . teraum/gloaming/belcaer/lobby)
             ("chandlers" . teraum/gloaming/belcaer/chandlers-guild-office))))
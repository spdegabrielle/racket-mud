#lang racket

(require "../../../recipes/areas/gloaming/belcaer/room.rkt")

(provide lobby)

(define lobby
  (room
   'teraum/gloaming/belcaer/lobby
   #:brief "Belcaer Lobby"
   #:description "This is Belcaer, a \"town\" in the Gloaming. The settlement was originally created by powerful magic users, who raised a giant mesa and carved into a fortress. In the years immediately after the Break, Belcaer was squatted by bandits, then adventurers. In recent years, it has been transformed into a large casino complex."
   #:exits '(("east" . teraum/gloaming/central-longroad)
             ("offices" . teraum/gloaming/belcaer/offices))))
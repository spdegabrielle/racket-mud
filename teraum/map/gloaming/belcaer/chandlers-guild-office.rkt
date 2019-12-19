#lang racket

(require "../../../../rpg-basics/recipes/people/basic.rkt")
(require "../../../recipes/areas/gloaming/belcaer/room.rkt")

(provide chandlers-guild-office)

(define abeth
  (person
   #:brief "Abeth Harbrook"
   #:description "Abeth Harbrook is a feminine human. She is the representative of the Chandlers Guild in Belcaer, helping the casino fill its paper and office supply needs."
   #:actions '((2 . "Abeth Harbrook says, \"Most people don't think about how far the paper they use has come.\"")
               (1 . "Abeth Harbrook says, \"I tried suggesting the casion move to paper instead of coins.\""))))

(define chandlers-guild-office
  (room
   'teraum/gloaming/belcaer/chandlers-guild-office
   #:brief "Chandlers Guild Office"
   #:description "This is the office of the Chandlers Guild in Belcaer."
   #:exits '(("out" . teraum/gloaming/belcaer/offices))
   #:contents (list abeth)))
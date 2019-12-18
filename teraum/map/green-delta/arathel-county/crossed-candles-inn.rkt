#lang racket

(require "../../../../rpg-basics/recipes/areas/rooms/inn.rkt")
(require "../../../../rpg-basics/recipes/people/ghost.rkt")
(require "../../../../rpg-basics/recipes/people/innkeep.rkt")

(provide crossed-candles-inn)

(define alfric
  (ghost
   #:brief "ghost of Alfric"
   #:description "Alfric was a human soldier during the Great Wars, who visited the Crossed Candles Inn on campaign. While there, he tried to start a bar fight, but slipped in a puddle, cracked his head, and died. Now, his ghost haunts the Inn."
   ; alric's whispers should cause a chance of a yokel fighting someone in the inn
   #:actions '((1 . "Someone whispers something and you feel paranoid."))))

(define lexandra
  (innkeep
   #:brief "Lexandra Terr"
   #:description "Lexandra Terr is a small feminine human wearing a simple blue cotton dress."))

(define crossed-candles-inn
  (inn
   'teraum/arathel-county/crossed-candles-inn
   #:brief "Crossed Candles Inn"
   #:description "This is the Crossed Candles Inn: a simple wooden shack with several shuttered windows. Accomodations consist of a single large room with wooden cots. The Inn is said to be haunted by the coast of a human man named Alfric. The innkeeper is a short human woman named Lexandra Terr. She is a retired thief, and maintains a collection of various maps.A door leads out to Arathel County."
   #:exits '(("out" . teraum/arathel-county/outside-crossed-candles-inn))
   #:contents (list alfric lexandra)))
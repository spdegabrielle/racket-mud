#lang racket

(require "../../../../rpg-basics/recipes/areas/rooms/inn.rkt")
(require "../../../../rpg-basics/recipes/people/innkeep.rkt")

(provide broken-arrow-inn)

(define geda
  (innkeep
   #:brief "Geda"
   #:description "Geda owns the Broken Arrow Inn, where she makes cheddar and whey."))

(define broken-arrow-inn
  (inn
   'teraum/arathel-county/broken-arrow-inn
   #:brief "Broken Arrow Inn"
   #:description "The Broken Arrow Inn is a single-storey stone-walled building, with a small fenced yard and a large cellar. Accommodations consist of several small rooms with wooden cots. The owner, Geda, makes cheddar and whey."
   #:exits '(("out" . teraum/arathel-county/outside-broken-arrow-inn))
   #:contents (list geda)))